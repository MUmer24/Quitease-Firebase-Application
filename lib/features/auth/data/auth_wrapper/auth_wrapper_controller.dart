// File: lib/auth_wrapper_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// Your other imports for UserRepository, UserModel, TLoaders, etc.
import 'package:quitease/shared/models/user_model.dart';
import 'package:quitease/shared/repositories/auth/user_repository.dart';
import 'package:quitease/shared/utils/popups/loaders.dart';
import 'package:quitease/shared/services/storage/data_persistence_service.dart';

class AuthWrapperController extends GetxController {
  late AppLinks _appLinks;
  // Compatibility with previous AuthController API
  final RxBool isLoading = false.obs;
  final RxInt userRefreshTrigger = 0.obs;

  Future<void> logout() async {
    try {
      isLoading.value = true;
      final confirmed = await _showLogoutConfirmation();
      if (!confirmed) {
        isLoading.value = false;
        return;
      }
      await FirebaseAuth.instance.signOut();
      await _dataService.clearAllData();
      isOnboardingComplete.value = false;
      firebaseUser.value = null;
      Get.snackbar(
        'Logged Out',
        'You have been successfully logged out.',
        backgroundColor: Get.theme.colorScheme.secondary,
        colorText: Get.theme.colorScheme.onSecondary,
        duration: const Duration(seconds: 2),
      );
      Get.offAllNamed('/auth');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInAsGuest() async {
    try {
      isLoading.value = true;
      await FirebaseAuth.instance.signInAnonymously();
      await _dataService.loadAllData();
      isOnboardingComplete.value = false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Guest sign-in failed: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void startOnboarding() {
    // Navigate to the onboarding quit date screen
    Get.toNamed('/onboarding-quit-date');
  }

  Future<void> refreshUser() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      userRefreshTrigger.value++;
    } catch (e) {
      // log error
    }
  }

  Future<bool> _showLogoutConfirmation() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
    return result ?? false;
  }

  StreamSubscription<Uri>? _linkSubscription;
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final isOnboardingComplete = false.obs;
  final isDataLoading = true.obs;
  final DataPersistenceService _dataService = Get.find();

  @override
  void onInit() {
    super.onInit();
    // Bind the user's auth state to our Rx variable
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
    // _checkOnboardingStatus();
    _loadUserDataAndCheckStatus(); // Load user data AND check onboarding status
    _initDeepLinks();
  }

  @override
  void onReady() {
    super.onReady();
    // Remove the native splash screen after the first frame is rendered
    FlutterNativeSplash.remove();
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  /// Load user data and check onboarding status
  Future<void> _loadUserDataAndCheckStatus() async {
    try {
      isDataLoading.value = true;

      // Load all data from the centralized service
      await _dataService.loadAllData();

      // Check onboarding status after data is loaded
      await _checkOnboardingStatus();
    } catch (e) {
      isOnboardingComplete.value = false;
    } finally {
      isDataLoading.value = false;
    }
  }

  /// Check if user has completed onboarding
  Future<void> _checkOnboardingStatus() async {
    try {
      // Use the centralized data service to check onboarding status
      isOnboardingComplete.value = _dataService.isOnboardingComplete.value;
    } catch (e) {
      isOnboardingComplete.value = false;
    }
  }

  /// Refresh onboarding status (call this after completing onboarding)
  Future<void> refreshOnboardingStatus() async {
    await _checkOnboardingStatus();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle the link that launched the app
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _processSignInLink(initialUri.toString());
    }

    // Listen for links while the app is running
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _processSignInLink(uri.toString());
    });
  }

  Future<void> _processSignInLink(String link) async {
    // The link will now be 'quitease-smoking://auth/signin?oobCode=...'
    final oobCode = Uri.parse(link).queryParameters['oobCode'];
    final auth = FirebaseAuth.instance;

    if (oobCode != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final email = prefs.getString('emailForSignIn');

        if (email != null) {
          // --- THIS IS THE CRUCIAL STEP ---
          // Reconstruct the original Firebase link that the SDK expects
          final fullLink =
              'https://${auth.tenantId ?? auth.app.options.authDomain}/__/auth/action?oobCode=$oobCode&mode=signIn';

          // Now, call signInWithEmailLink with the reconstructed link
          if (auth.isSignInWithEmailLink(fullLink)) {
            final userCredential = await auth.signInWithEmailLink(
              email: email,
              emailLink: fullLink,
            );
            await prefs.remove('emailForSignIn');

            // This is where your user creation logic now lives!
            if (userCredential.additionalUserInfo?.isNewUser ?? false) {
              final newUser = UserModel(
                id: userCredential.user!.uid,
                email: userCredential.user!.email!,
                profilePicture: '',
              );
              final userRepository = Get.find<UserRepository>();
              await userRepository.saveUserRecord(newUser);
            }
          }
        }
      } catch (e) {
        TLoaders.errorSnackBar(title: 'Sign-In Failed', message: e.toString());
      }
    }
  }
}
