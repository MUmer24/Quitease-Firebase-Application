import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/shared/models/user_model.dart';
import 'package:quitease/shared/services/storage/data_persistence_service.dart';

import 'package:quitease/shared/repositories/auth/user_repository.dart';
import 'package:quitease/features/auth/data/auth_wrapper/auth_wrapper.dart';
import 'package:quitease/features/auth/data/auth_wrapper/auth_wrapper_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quitease/shared/utils/savings_calculator.dart';

class SummaryController extends GetxController {
  final DataPersistenceService _dataService = Get.find();

  final SavingsCalculator _savingsCalculator = Get.find();
  final UserRepository _userRepository = Get.find();

  final Map<String, dynamic> args = Get.arguments;

  final cigarettesSkipped = 0.obs;
  final moneySaved = '0.0'.obs;
  final daysSinceQuit = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _calculateInitialSavings();
  }

  void _calculateInitialSavings() {
    try {
      // Use the app data controller's calculator
      final savings = _savingsCalculator.calculateSavings(
        quitDate: args['quitDate'],
        cigarettesPerDay: (args['cigsPerDay'] as double).toInt(),
        cigarettesPerPack: (args['cigsPerPack'] as double).toInt(),
        pricePerPack: args['pricePerPack'],
      );
      cigarettesSkipped.value = savings['cigarettesSkipped'];
      moneySaved.value = (savings['moneySaved'] as double).toStringAsFixed(1);
      daysSinceQuit.value = savings['daysSinceQuit'];
    } catch (e) {
      debugPrint('Error calculating initial savings: $e');
    }
  }

  Future<void> finishOnboarding() async {
    try {
      isLoading.value = true;

      // Validate required data
      if (args['quitDate'] == null ||
          args['cigsPerDay'] == null ||
          args['cigsPerPack'] == null ||
          args['pricePerPack'] == null) {
        throw Exception('Missing required data');
      }

      // Save all the data through the centralized service
      await _dataService.updateSmokingData(
        newQuitDate: args['quitDate'],
        newCigarettesPerDay: args['cigsPerDay'] as double,
        newCigarettesPerPack: args['cigsPerPack'] as double,
        newPricePerPack: args['pricePerPack'],
        newIsOnboardingComplete: true,
      );

      // **CRITICAL: Add delay to ensure data persistence completes**
      await Future.delayed(const Duration(milliseconds: 300));
      debugPrint('✅ Onboarding data saved through centralized service');

      // Save data to Firebase if user is logged in
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        try {
          // For guest users (anonymous), create user document first if it doesn't exist
          if (currentUser.isAnonymous) {
            // Check if user document exists
            final userDoc = await _userRepository.getUserIfExists(
              currentUser.uid,
            );

            if (userDoc == null) {
              // Create new user document for anonymous user
              debugPrint('👤 Creating new user document for guest user');
              final newUser = UserModel(
                id: currentUser.uid,
                email: '', // Anonymous users don't have email
                profilePicture: '',
                cigarettesCount: args['cigsPerDay'] as double,
                smokesPerPack: args['cigsPerPack'] as double,
                pricePerPack: args['pricePerPack'],
                quitDate: args['quitDate'],
                isOnboardingComplete: true,
              );
              await _userRepository.saveUserRecord(newUser);
              debugPrint('✅ Guest user document created in Firebase');
            } else {
              // Update existing anonymous user document
              await _userRepository.updateSmokingData(
                currentUser.uid,
                cigarettesCount: args['cigsPerDay'] as double,
                smokesPerPack: args['cigsPerPack'] as double,
                pricePerPack: args['pricePerPack'],
                quitDate: args['quitDate'],
                isOnboardingComplete: true,
              );
              debugPrint('✅ Guest user data updated in Firebase');
            }
          } else {
            // For regular users (Google sign-in), just update
            await _userRepository.updateSmokingData(
              currentUser.uid,
              cigarettesCount: args['cigsPerDay'] as double,
              smokesPerPack: args['cigsPerPack'] as double,
              pricePerPack: args['pricePerPack'],
              quitDate: args['quitDate'],
              isOnboardingComplete: true,
            );
            debugPrint('✅ User data synced to Firebase');
          }
        } on FirebaseException catch (e) {
          debugPrint(
            'Firebase error saving user data: ${e.code} - ${e.message}',
          );
          // Continue with local data even if Firebase fails
          Get.snackbar(
            'Warning',
            'Data saved locally but sync to cloud failed. Will sync later.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      }

      // Navigate to AuthWrapper which will show Dashboard since onboarding is now complete
      // This approach allows AuthWrapper to handle the navigation logic
      if (currentUser != null) {
        debugPrint('🚀 Onboarding complete, refreshing AuthWrapper...');

        // Refresh the AuthWrapper's onboarding status
        if (Get.isRegistered<AuthWrapperController>()) {
          final authWrapperController = Get.find<AuthWrapperController>();
          await authWrapperController.refreshOnboardingStatus();
        }

        // Navigate to AuthWrapper, which will automatically show Dashboard
        Get.offAll(() => const AuthWrapper());
      }
    } on FirebaseException catch (e) {
      debugPrint(
        'Firebase error in finishOnboarding: ${e.code} - ${e.message}',
      );
      Get.snackbar(
        'Firebase Error',
        'Failed to sync with cloud: ${e.message}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error in finishOnboarding: $e');
      Get.snackbar(
        'Error',
        'Failed to complete setup. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
