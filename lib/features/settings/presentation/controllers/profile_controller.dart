import 'package:get/get.dart';
import 'package:quitease/features/dashboard/data/app_data_controller.dart';
import 'package:quitease/shared/services/storage/data_persistence_service.dart';
import 'package:quitease/features/achievements/presentation/controllers/achievement_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quitease/shared/repositories/auth/user_repository.dart';
import 'package:quitease/features/auth/data/auth_wrapper/auth_wrapper.dart';
import 'package:quitease/features/auth/data/auth_wrapper/auth_wrapper_controller.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ProfileController extends GetxController {
  // Dependencies - Updated to use centralized services
  final DataPersistenceService _dataService = Get.find();
  final AppDataController _appDataController = Get.find();
  final AchievementController _achievementController = Get.find();
  final UserRepository _userRepository = Get.find();

  // Reactive Variables
  final username = 'Guest'.obs;
  final email = 'user@example.com'.obs;
  final profilePicture = ''.obs;

  // Expose data from the centralized services
  DateTime? get quitDate => _dataService.quitDate.value;
  int get cigarettesSkipped => _appDataController.totalCigarettesSkipped.value;
  String get moneySaved => _appDataController.moneySaved.value;
  String get timeWonBack => _appDataController.timeWonBack.value;

  final completedAchievements = 0.obs;
  final totalAchievements = 0.obs;

  // Account Information
  final isEmailVerified = false.obs;
  final Rx<DateTime?> accountCreatedAt = Rx<DateTime?>(null);
  final Rx<DateTime?> lastSignInAt = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    // Load username and email
    username.value = _dataService.userFullName.value;
    email.value = _dataService.userEmail.value;
    profilePicture.value = _dataService.userProfilePicture.value;

    // Load Firebase user metadata
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      isEmailVerified.value = currentUser.emailVerified;

      // Get account creation and last sign-in dates
      if (currentUser.metadata.creationTime != null) {
        accountCreatedAt.value = currentUser.metadata.creationTime;
      }
      if (currentUser.metadata.lastSignInTime != null) {
        lastSignInAt.value = currentUser.metadata.lastSignInTime;
      }

      // Handle guest user display
      if (currentUser.isAnonymous) {
        username.value = 'Guest';
        email.value = 'No Email';
      } else {
        username.value = _dataService.userFullName.value;
        email.value = _dataService.userEmail.value;
      }
    } else {
      // No user logged in
      username.value = 'Guest';
      email.value = 'No Email';
    }

    // Get achievement stats from the dedicated controller
    completedAchievements.value =
        _achievementController.completedAchievements.value;
    totalAchievements.value = _achievementController.totalAchievements.value;
  }

  // Original text-based share functionality
  Future<void> shareProgress() async {
    try {
      final days = quitDate != null
          ? DateTime.now().difference(quitDate!).inDays
          : 0;

      final message =
          '''
🚭 My Quit Smoking Journey 🚭

I've been smoke-free for $days days!
💪 Cigarettes avoided: $cigarettesSkipped
💰 Money saved: Rs $moneySaved
⏰ Time won back: $timeWonBack

Join me in quitting smoking with QuitEase!
''';

      await Share.share(message);
      debugPrint('✅ Progress shared successfully');
    } catch (e) {
      debugPrint('❌ Error sharing progress: $e');
      Get.snackbar(
        'Share Failed',
        'Failed to share progress. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Reset progress functionality - only reset app data, not personal data
  Future<void> resetProgress(BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text(
          'Are you sure you want to reset your quit journey? This will clear all your progress and you will need to start over.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Get current user
        final currentUser = FirebaseAuth.instance.currentUser;

        // Reset Firebase data if user is logged in (only app data, not personal data)
        if (currentUser != null) {
          await _userRepository.updateSmokingData(
            currentUser.uid,
            cigarettesCount: 0.0,
            smokesPerPack: 0.0,
            pricePerPack: 0.0,
            quitDate: DateTime.now(),
            isOnboardingComplete: false,
          );
        }

        // Clear only app-related data from local storage, preserve personal data
        await _clearAppDataOnly();

        // Reset only app-related reactive variables through the centralized service
        _appDataController.resetToZero();

        // Refresh the AuthWrapper's onboarding status to reflect the reset
        if (Get.isRegistered<AuthWrapperController>()) {
          final authWrapperController = Get.find<AuthWrapperController>();
          await authWrapperController.refreshOnboardingStatus();
        }

        // Navigate to AuthWrapper which will properly handle the navigation based on onboarding status
        Get.offAll(() => const AuthWrapper());

        Get.snackbar(
          'Progress Reset',
          'Your quit journey has been reset. Please set your quit date to start over.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } catch (e) {
        debugPrint('Error during reset progress: $e');
        Get.snackbar(
          'Error',
          'Failed to reset progress. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  // Helper method to clear only app-related data, not personal data
  Future<void> _clearAppDataOnly() async {
    // Get current personal data to preserve it
    final currentUsername = _dataService.userFullName.value;
    final currentEmail = _dataService.userEmail.value;
    final currentProfilePicture = _dataService.userProfilePicture.value;

    // Clear all data through the centralized service
    await _dataService.clearAllData();

    // Restore personal data
    await _dataService.updateUserProfile(
      fullName: currentUsername,
      email: currentEmail,
      profilePicture: currentProfilePicture,
    );

    // Explicitly set onboarding as incomplete
    // This would need to be added to DataPersistenceService
  }
}
