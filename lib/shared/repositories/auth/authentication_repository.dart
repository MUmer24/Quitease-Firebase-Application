import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quitease/core/config/app_env.dart';
import 'package:quitease/shared/models/user_model.dart';
import 'package:quitease/shared/services/storage/shared_prefs_provider.dart';
import 'package:quitease/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:quitease/features/onboarding/presentation/screens/quit_date_time_screen.dart';
import 'package:quitease/features/settings/presentation/controllers/settings_controller.dart';
import 'package:quitease/shared/utils/error_handler.dart';
import 'package:quitease/shared/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:quitease/shared/utils/exceptions/firebase_exceptions.dart';
import 'package:quitease/shared/utils/exceptions/format_exceptions.dart';
import 'package:quitease/shared/utils/exceptions/platform_exceptions.dart';
import 'package:quitease/shared/utils/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quitease/shared/repositories/auth/user_repository.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final deviceStorage = GetStorage();

  /* --------------------Federated identity & social sign-in ---------------------------------*/

  // Google Sign-In v7+ uses singleton instance
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool isInitialized = false;

  static Future<void> initSignIn() async {
    if (!isInitialized) {
      // v7+ requires 'clientId' and 'serverClientId' as named parameters in initialize
      await _googleSignIn.initialize(
        clientId: null, // Not needed for Android
        serverClientId: AppEnv.googleServerClientId,
      );
      isInitialized = true;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Show loading overlay
      LoadingOverlay.show(message: 'Signing in with Google...');

      // 1. Initialize Google Sign-In (v7+ API)
      await initSignIn();

      // 2. Trigger Google Authentication Flow (v7+ uses authenticate)
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();

      if (googleUser == null) {
        // User canceled the sign-in
        LoadingOverlay.hide();
        return null;
      }

      // 3. Obtain Authentication Details for Firebase
      // In v7+, authentication is a property, not a future
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // 4. Create credential for Firebase using ID token
      // Note: For Firebase, idToken is sufficient. AccessToken is for Google APIs.
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken:
            googleAuth.idToken, // Use idToken as accessToken for Firebase
      );

      // 5. Sign in to Firebase with the credential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;

      if (user != null) {
        final userRepository = Get.put(UserRepository());
        final existingUser = await userRepository.getUserIfExists(user.uid);

        // Extract user data from Google account
        final String displayName = googleUser.displayName ?? 'User';
        final String email = googleUser.email;
        final String photoUrl = googleUser.photoUrl ?? '';

        if (existingUser == null) {
          // New user - create basic record with Google data
          final newUser = UserModel(
            id: user.uid,
            fullName: displayName,
            email: email,
            profilePicture: photoUrl,
            cigarettesCount: 0.0,
            smokesPerPack: 0.0,
            pricePerPack: 0.0,
            quitDate: null,
            createdAt: DateTime.now(),
            isOnboardingComplete: false,
          );
          await userRepository.saveUserRecord(newUser);

          // Also save to SharedPreferences for immediate access
          await _saveUserDataToPrefs(newUser);

          Get.offAll(() => QuitDateTimeScreen());
        } else {
          // Existing user - update their profile with latest Google data
          final updatedUser = existingUser.copyWithProfile(
            fullName: displayName,
            profilePicture: photoUrl,
          );
          await userRepository.updateUserDetails(updatedUser);

          // Existing user - check if onboarding is complete
          if (existingUser.isOnboardingComplete) {
            // **CRITICAL: Use SharedPrefsProvider for complete data sync**
            debugPrint('📥 Syncing user data to SharedPreferences...');
            final sharedPrefsProvider = Get.find<SharedPrefsProvider>();

            // Use the built-in loadFromFirebase method
            final loadSuccess = await sharedPrefsProvider.loadFromFirebase(
              user.uid,
            );

            if (!loadSuccess) {
              debugPrint(
                '⚠️ loadFromFirebase failed, using fallback method...',
              );
              await _loadCompleteUserDataToPrefs(existingUser);
            }

            // Verify data was actually saved
            await Future.delayed(const Duration(milliseconds: 200));
            final verifyQuitDate = await sharedPrefsProvider.getQuitDate();
            final verifyCigsPerDay = await sharedPrefsProvider
                .getCigarettesPerDay();
            debugPrint('✅ Verification after sync:');
            debugPrint('   Quit Date: $verifyQuitDate');
            debugPrint('   Cigarettes/Day: $verifyCigsPerDay');

            if (verifyQuitDate == null) {
              debugPrint('❌ CRITICAL: Quit date still null after sync!');
              // Try one more time with direct method
              await _loadCompleteUserDataToPrefs(existingUser);
              await Future.delayed(const Duration(milliseconds: 500));
            }

            // Navigate to dashboard
            Get.offAll(() => DashboardScreen(user: _auth.currentUser!));
          } else {
            // Update SharedPreferences with profile data only
            await _saveUserDataToPrefs(updatedUser);
            Get.offAll(() => QuitDateTimeScreen());
          }
        }
      }
      // After successful sign in, refresh settings
      if (Get.isRegistered<SettingsController>()) {
        await Get.find<SettingsController>().loadProfileData();
      }

      return userCredential;
      // Provide clear user feedback
    } on FirebaseAuthException catch (e) {
      LoadingOverlay.hide(); // Hide loading on error
      ErrorHandler.showError(TFirebaseAuthException(e.code).message);
    } on FirebaseException catch (e) {
      LoadingOverlay.hide(); // Hide loading on error
      ErrorHandler.showError(TFirebaseException(e.code).message);
    } on FormatException catch (_) {
      LoadingOverlay.hide(); // Hide loading on error
      ErrorHandler.showError(const TFormatException().message);
    } on PlatformException catch (e) {
      LoadingOverlay.hide(); // Hide loading on error
      ErrorHandler.showError(TPlatformException(e.code).message);
    } catch (e) {
      LoadingOverlay.hide(); // Hide loading on error
      debugPrint('Something went wrong in signInWithGoogle: $e');
      // For unknown errors, throw a generic exception
      // throw 'An unexpected error occurred. Please try again.';
      Get.snackbar(
        'Login Failed',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Always hide loading at the end
      LoadingOverlay.hide();
    }
    return null;
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserDataToPrefs(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userFullName', user.fullName);
      await prefs.setString('userEmail', user.email);
      await prefs.setString('userProfilePicture', user.profilePicture);
      await prefs.setString('username', user.fullName);
    } catch (e) {
      debugPrint('Error saving user data to prefs: $e');
    }
  }

  // Load complete user data including smoking info to SharedPreferences
  Future<void> _loadCompleteUserDataToPrefs(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save profile data
      await prefs.setString('userFullName', user.fullName);
      await prefs.setString('userEmail', user.email);
      await prefs.setString('userProfilePicture', user.profilePicture);
      await prefs.setString('username', user.fullName);

      // Save smoking cessation data
      if (user.quitDate != null) {
        await prefs.setInt('quitDate', user.quitDate!.millisecondsSinceEpoch);
      }
      await prefs.setInt('cigarettesPerDay', user.cigarettesCount.toInt());
      await prefs.setInt('cigarettesPerPack', user.smokesPerPack.toInt());
      await prefs.setDouble('pricePerPack', user.pricePerPack);
      await prefs.setBool('isSetupComplete', user.isOnboardingComplete);

      debugPrint('✅ Complete user data loaded to SharedPreferences');
      debugPrint('   Quit Date: ${user.quitDate}');
      debugPrint('   Cigarettes/Day: ${user.cigarettesCount}');
      debugPrint('   Price/Pack: ${user.pricePerPack}');
    } catch (e) {
      debugPrint('❌ Error loading complete user data to prefs: $e');
    }
  }

  Future<UserCredential> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
