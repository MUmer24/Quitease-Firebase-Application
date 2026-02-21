import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quitease/core/config/app_env.dart';
import 'package:quitease/shared/repositories/auth/user_repository.dart';
import 'package:quitease/shared/services/storage/shared_prefs_provider.dart';
import 'package:quitease/features/auth/data/auth_wrapper/auth_wrapper_controller.dart';
import 'package:quitease/shared/utils/popups/loaders.dart';

class AccountLinkingController extends GetxController {
  static AccountLinkingController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = Get.find();
  final SharedPrefsProvider _prefsProvider = Get.find();

  final isLinking = false.obs;
  final isGuestAccount = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAccountType();
  }

  /// Check if current user is a guest (anonymous) account
  void _checkAccountType() {
    final user = _auth.currentUser;
    isGuestAccount.value = user?.isAnonymous ?? false;
  }

  /// Link anonymous account to Google
  Future<bool> linkWithGoogle() async {
    try {
      isLinking.value = true;

      // Get current user
      final User? currentUser = _auth.currentUser;
      if (currentUser == null || !currentUser.isAnonymous) {
        TLoaders.errorSnackBar(
          title: 'Error',
          message: 'This feature is only available for guest accounts.',
        );
        return false;
      }

      // Show confirmation dialog
      final confirmed = await _showLinkConfirmationDialog();
      if (!confirmed) {
        isLinking.value = false;
        return false;
      }

      // Initialize Google Sign In (v7+ API)
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        clientId: null, // Not needed for Android
        serverClientId: AppEnv.googleServerClientId,
      );

      // Trigger Google Sign In (v7+ uses authenticate)
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        // User canceled the sign-in
        isLinking.value = false;
        return false;
      }

      // Get authentication details (must be awaited in v7+)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create Google credential using the tokens
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.idToken, // Use idToken for Firebase
      );

      // Link anonymous account with Google credential
      debugPrint('🔗 Linking anonymous account to Google...');
      final UserCredential linkedUserCredential = await currentUser
          .linkWithCredential(credential);

      debugPrint('✅ Account linked successfully!');
      debugPrint('   User ID: ${linkedUserCredential.user?.uid}');
      debugPrint('   Email: ${linkedUserCredential.user?.email}');
      debugPrint(
        '   Name from Firebase: ${linkedUserCredential.user?.displayName}',
      );
      debugPrint('   Name from Google: ${googleUser.displayName}');
      debugPrint('   Photo from Google: ${googleUser.photoUrl}');

      // Update Firebase user profile with Google account info
      // Firebase doesn't automatically set display name and photo from Google
      if (linkedUserCredential.user != null) {
        await linkedUserCredential.user!.updateDisplayName(
          googleUser.displayName,
        );
        await linkedUserCredential.user!.updatePhotoURL(googleUser.photoUrl);
        debugPrint('✅ Updated Firebase user profile with Google data');
      }

      // Update user data in Firestore with Google profile information
      // Use googleUser data, not Firebase user (which may not have profile yet)
      await _updateUserProfileAfterLinking(
        linkedUserCredential.user!,
        googleUser,
      );

      // Update SharedPreferences with new profile data
      await _updateSharedPrefsAfterLinking(googleUser);

      // Force reload the user to get updated profile (with multiple attempts)
      for (int i = 0; i < 3; i++) {
        await linkedUserCredential.user!.reload();
        await Future.delayed(const Duration(milliseconds: 300));
      }

      final updatedUser = _auth.currentUser;

      debugPrint('✅ User profile after linking:');
      debugPrint('   Display Name: ${updatedUser?.displayName}');
      debugPrint('   Email: ${updatedUser?.email}');
      debugPrint('   Photo URL: ${updatedUser?.photoURL}');
      debugPrint(
        '   Providers: ${updatedUser?.providerData.map((p) => p.providerId).toList()}',
      );

      // Show success message
      TLoaders.successSnackBar(
        title: 'Account Linked!',
        message:
            'Your guest account has been successfully linked to ${linkedUserCredential.user?.email}',
      );

      // Update account type status
      _checkAccountType();

      // Refresh the current user data in AuthController
      if (Get.isRegistered<AuthWrapperController>()) {
        await Get.find<AuthWrapperController>().refreshUser();
      }

      // Wait a bit more to ensure all updates propagate
      await Future.delayed(const Duration(milliseconds: 500));

      // Close the current screen
      Get.back(); // Close profile screen

      // Show a dialog suggesting to reopen profile to see changes
      await Future.delayed(const Duration(milliseconds: 300));
      Get.snackbar(
        'Profile Updated',
        'Your profile has been updated with Google information. Open Profile again to see changes.',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ FirebaseAuthException: ${e.code} - ${e.message}');

      if (e.code == 'credential-already-in-use') {
        TLoaders.errorSnackBar(
          title: 'Account Already Exists',
          message:
              'This Google account is already linked to another user. Please use a different account.',
        );
      } else if (e.code == 'provider-already-linked') {
        TLoaders.errorSnackBar(
          title: 'Already Linked',
          message: 'This account is already linked to Google.',
        );
      } else if (e.code == 'invalid-credential') {
        TLoaders.errorSnackBar(
          title: 'Invalid Credential',
          message: 'The credential is invalid. Please try again.',
        );
      } else {
        TLoaders.errorSnackBar(
          title: 'Linking Failed',
          message: e.message ?? 'Failed to link account. Please try again.',
        );
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error linking account: $e');
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'An unexpected error occurred. Please try again.',
      );
      return false;
    } finally {
      isLinking.value = false;
    }
  }

  /// Update user profile in Firestore after linking
  Future<void> _updateUserProfileAfterLinking(
    User user,
    GoogleSignInAccount googleUser,
  ) async {
    try {
      final existingUser = await _userRepository.getUserIfExists(user.uid);

      if (existingUser != null) {
        // Update the user object with Google profile data
        existingUser.email = user.email ?? existingUser.email;
        existingUser.fullName = googleUser.displayName ?? existingUser.fullName;
        existingUser.profilePicture =
            googleUser.photoUrl ?? existingUser.profilePicture;
        existingUser.updatedAt = DateTime.now();

        // Save the updated user back to Firestore
        await _userRepository.updateUserDetails(existingUser);

        debugPrint('✅ User profile updated in Firestore');
        debugPrint('   Full Name: ${existingUser.fullName}');
        debugPrint('   Email: ${existingUser.email}');
        debugPrint('   Profile Picture: ${existingUser.profilePicture}');
      }
    } catch (e) {
      debugPrint('❌ Error updating user profile in Firestore: $e');
    }
  }

  /// Update SharedPreferences after linking
  Future<void> _updateSharedPrefsAfterLinking(
    GoogleSignInAccount googleUser,
  ) async {
    try {
      await _prefsProvider.setUserFullName(googleUser.displayName ?? 'User');
      await _prefsProvider.setUserEmail(googleUser.email);
      await _prefsProvider.setUserProfilePicture(googleUser.photoUrl ?? '');
      debugPrint('✅ SharedPreferences updated with Google profile data');
      debugPrint('   Display Name: ${googleUser.displayName}');
      debugPrint('   Email: ${googleUser.email}');
      debugPrint('   Photo URL: ${googleUser.photoUrl}');
    } catch (e) {
      debugPrint('❌ Error updating SharedPreferences: $e');
    }
  }

  /// Show confirmation dialog before linking
  Future<bool> _showLinkConfirmationDialog() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.link, color: Colors.blue),
            SizedBox(width: 8),
            Text('Link Account'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Link your guest account to Google?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text('Benefits:'),
            SizedBox(height: 8),
            Text('✅ Access your data from any device'),
            Text('✅ Automatic cloud backup'),
            Text('✅ Never lose your progress'),
            Text('✅ Enhanced account security'),
            SizedBox(height: 16),
            Text(
              'Your current progress will be preserved.',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Get.back(result: true),
            icon: const Icon(Icons.link),
            label: const Text('Link Account'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return result ?? false;
  }

  /// Get linked provider names
  List<String> getLinkedProviders() {
    final user = _auth.currentUser;
    if (user == null) return [];

    return user.providerData.map((info) => info.providerId).toList();
  }

  /// Check if account is linked to specific provider
  bool isLinkedTo(String providerId) {
    return getLinkedProviders().contains(providerId);
  }
}
