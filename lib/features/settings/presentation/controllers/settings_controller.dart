import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/shared/services/storage/data_persistence_service.dart';
import 'package:quitease/features/auth/presentation/screens/auth_screen.dart';
import 'package:quitease/features/settings/presentation/screens/profile_screen.dart';
import 'package:quitease/shared/utils/enums.dart';
import 'package:quitease/core/theme/app_theme.dart';

class SettingsController extends GetxController {
  final DataPersistenceService _dataService = Get.find();

  final isAccountsFeatureEnabled = false.obs;
  final isConnected = false.obs;
  final username = 'Guest'.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnection();
    loadProfileData();
  }

  // From functions.dart
  void checkConnection() {
    // In a real app, this would check Firebase Auth, etc.
    // For now, we'll simulate the user as not logged in.
    isConnected.value = false;
  }

  Future<void> loadProfileData() async {
    debugPrint('Settings Controller loadProfileData started');
    debugPrint('Username loaded after dataservice change: ${username.value}');
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        debugPrint('Current user found: ${currentUser.uid}');
        // Handle guest user display
        if (currentUser.isAnonymous) {
          debugPrint('User is anonymous (guest)');
          username.value = 'Guest';
        } else {
          await _dataService.loadAllData(); // Ensure data is loaded
          debugPrint(
            'Data service user full name: ${_dataService.userFullName.value}',
          );
          username.value = _dataService.userFullName.value.isEmpty
              ? 'User'
              : _dataService.userFullName.value;
          debugPrint('Username set to: ${username.value}');
        }
      } else {
        // No user logged in
        debugPrint('No user logged in');
        username.value = 'User';
      }
    } catch (e) {
      debugPrint('Error in loadProfileData: $e');
      username.value = 'User';
    }

    debugPrint(
      'Settings Controller loadProfileData completed. Final username: ${username.value}',
    );
  }

  // Expose reactive variables from the data service for UI binding
  String get userEmail => _dataService.userEmail.value;
  String get userProfilePicture => _dataService.userProfilePicture.value;

  // ------------------------------------------

  // Navigation
  void navigateToProfile() {
    Get.to(() => ProfileScreen());
  }

  Future<void> resetData() {
    return Get.defaultDialog(
      title: "Reset Data",
      middleText:
          "Are you sure you want to reset all your data? This action cannot be undone.",
      textConfirm: "Reset",
      textCancel: "Cancel",
      onConfirm: () async {
        // Here you would clear all SharedPreferences keys
        // await _prefsProvider.setSetupComplete(false);
        // ... clear other keys ...

        await _dataService.clearAllData();
        // Set onboarding as incomplete through the service
        // Note: This would need to be handled properly in the data service
        // For now, we'll just navigate to auth screen to simulate onboarding

        // Navigate back to the start
        Get.offAll(() => AuthScreen());
      },
    );
  }

  Widget logoutButtonShow() {
    if (isAccountsFeatureEnabled.value) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text("Logout"),
          style: ElevatedButton.styleFrom(
            backgroundColor: SereneAscentTheme.getColor(
              SereneAscentPaletteColor.charcoalGrey,
            ),
            foregroundColor: Colors.white,
          ),
          onPressed: logout,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  // From functions.dart
  void logout() {
    // In a real app, this would sign out from Firebase Auth
    // and then navigate.
    isConnected.value = false;
    Get.offAll(() => AuthScreen());
  }
}
