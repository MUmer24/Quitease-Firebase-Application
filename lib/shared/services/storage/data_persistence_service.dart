import 'package:get/get.dart';
import 'package:quitease/shared/services/storage/shared_prefs_provider.dart';
import 'package:quitease/shared/repositories/auth/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataPersistenceService extends GetxController {
  static DataPersistenceService get instance => Get.find();

  final SharedPrefsProvider _sharedPrefsProvider = Get.find();
  final UserRepository _userRepository = Get.find();

  // Data streams
  final Rx<DateTime?> quitDate = Rx<DateTime?>(null);
  final Rx<double> cigarettesPerDay = 0.0.obs;
  final Rx<double> cigarettesPerPack = 0.0.obs;
  final Rx<double> pricePerPack = 0.0.obs;
  final Rx<bool> isOnboardingComplete = false.obs;
  final Rx<String> userFullName = ''.obs;
  final Rx<String> userEmail = ''.obs;
  final Rx<String> userProfilePicture = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Load initial data
    await loadAllData();
  }

  /// Load all data from both local and remote sources
  Future<void> loadAllData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      // Load from Firebase if user is authenticated
      if (currentUser != null) {
        try {
          final userData = await _userRepository.fetchUserDetails(
            currentUser.uid,
          );

          if (userData.isOnboardingComplete) {
            // Update local storage with Firebase data
            if (userData.quitDate != null) {
              await _sharedPrefsProvider.setQuitDate(userData.quitDate!);
              quitDate.value = userData.quitDate;
            }
            await _sharedPrefsProvider.setCigarettesPerDay(
              userData.cigarettesCount,
            );
            await _sharedPrefsProvider.setCigarettesPerPack(
              userData.smokesPerPack,
            );
            await _sharedPrefsProvider.setPricePerPack(userData.pricePerPack);
            await _sharedPrefsProvider.setSetupComplete(
              userData.isOnboardingComplete,
            );
            await _sharedPrefsProvider.setUserFullName(userData.fullName);
            await _sharedPrefsProvider.setUserEmail(userData.email);
            await _sharedPrefsProvider.setUserProfilePicture(
              userData.profilePicture,
            );

            // Update reactive variables
            cigarettesPerDay.value = userData.cigarettesCount;
            cigarettesPerPack.value = userData.smokesPerPack;
            pricePerPack.value = userData.pricePerPack;
            isOnboardingComplete.value = userData.isOnboardingComplete;

            if (currentUser.isAnonymous) {
              userFullName.value = "Guest";
              userEmail.value = 'None';
            } else {
              userFullName.value = userData.fullName;
              userEmail.value = userData.email;
            }

            userProfilePicture.value = userData.profilePicture;

            return;
          }
        } catch (e) {
          // Continue to local data if Firebase fails
        }
      }

      // Load from local storage
      quitDate.value = await _sharedPrefsProvider.getQuitDate();
      cigarettesPerDay.value = await _sharedPrefsProvider.getCigarettesPerDay();
      cigarettesPerPack.value = await _sharedPrefsProvider
          .getCigarettesPerPack();
      pricePerPack.value = await _sharedPrefsProvider.getPricePerPack();
      isOnboardingComplete.value = await _sharedPrefsProvider.isSetupComplete();

      // Handle guest user display for local data as well

      if (currentUser != null && currentUser.isAnonymous) {
        userFullName.value = 'Guest';
        userEmail.value = 'None';
      } else {
        userFullName.value = await _sharedPrefsProvider.getUserFullName();
        userEmail.value = await _sharedPrefsProvider.getUserEmail();
      }

      userProfilePicture.value = await _sharedPrefsProvider
          .getUserProfilePicture();
    } catch (e) {
      // Handle errors silently or log them
    }
  }

  /// Update smoking data in both local and remote storage
  Future<void> updateSmokingData({
    required DateTime newQuitDate,
    required double newCigarettesPerDay,
    required double newCigarettesPerPack,
    required double newPricePerPack,
    required bool newIsOnboardingComplete,
  }) async {
    // Update local storage
    await _sharedPrefsProvider.setQuitDate(newQuitDate);
    await _sharedPrefsProvider.setCigarettesPerDay(newCigarettesPerDay);
    await _sharedPrefsProvider.setCigarettesPerPack(newCigarettesPerPack);
    await _sharedPrefsProvider.setPricePerPack(newPricePerPack);
    await _sharedPrefsProvider.setSetupComplete(newIsOnboardingComplete);

    // Update reactive variables
    quitDate.value = newQuitDate;
    cigarettesPerDay.value = newCigarettesPerDay;
    cigarettesPerPack.value = newCigarettesPerPack;
    pricePerPack.value = newPricePerPack;
    isOnboardingComplete.value = newIsOnboardingComplete;

    // Sync with Firebase if user is authenticated
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await _userRepository.updateSmokingData(
          currentUser.uid,
          cigarettesCount: newCigarettesPerDay,
          smokesPerPack: newCigarettesPerPack,
          pricePerPack: newPricePerPack,
          quitDate: newQuitDate,
          isOnboardingComplete: newIsOnboardingComplete,
        );
      } catch (e) {
        // Log error but don't fail the operation
      }
    }
  }

  /// Update user profile data
  Future<void> updateUserProfile({
    String? fullName,
    String? email,
    String? profilePicture,
  }) async {
    if (fullName != null) {
      await _sharedPrefsProvider.setUserFullName(fullName);
      userFullName.value = fullName;
    }

    if (email != null) {
      await _sharedPrefsProvider.setUserEmail(email);
      userEmail.value = email;
    }

    if (profilePicture != null) {
      await _sharedPrefsProvider.setUserProfilePicture(profilePicture);
      userProfilePicture.value = profilePicture;
    }

    // Sync with Firebase if user is authenticated
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final updatedUser = await _userRepository.fetchUserDetails(
          currentUser.uid,
        );
        updatedUser.fullName = fullName ?? updatedUser.fullName;
        updatedUser.email = email ?? updatedUser.email;
        updatedUser.profilePicture =
            profilePicture ?? updatedUser.profilePicture;

        await _userRepository.updateUserDetails(updatedUser);
      } catch (e) {
        // Log error but don't fail the operation
      }
    }
  }

  /// Clear all data (for logout/reset)
  Future<void> clearAllData() async {
    await _sharedPrefsProvider.clearAll();

    // Reset reactive variables
    quitDate.value = null;
    cigarettesPerDay.value = 0.0;
    cigarettesPerPack.value = 0.0;
    pricePerPack.value = 0.0;
    isOnboardingComplete.value = false;
    userFullName.value = '';
    userEmail.value = '';
    userProfilePicture.value = '';
  }
}
