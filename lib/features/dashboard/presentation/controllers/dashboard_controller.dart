import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quitease/features/dashboard/data/app_data_controller.dart';
import 'package:quitease/shared/services/storage/data_persistence_service.dart';
import 'package:quitease/features/achievements/presentation/screens/achievement_screen.dart';
import 'package:quitease/features/health/presentation/screens/health_improvement_screen.dart';
import 'package:quitease/features/progress/presentation/screens/progress_screen.dart';
import 'package:quitease/features/settings/presentation/screens/profile_screen.dart';
import 'package:quitease/features/settings/presentation/screens/settings_screen.dart';

class DashboardController extends GetxController {
  // Reference to centralized data services
  final AppDataController _appDataController = Get.find();
  final DataPersistenceService _dataService = Get.find();

  // UI-focused reactive variables
  final isLoading = true.obs;

  // Expose data from the centralized services
  DateTime? get quitDate => _dataService.quitDate.value;
  int get totalCigarettesSkipped =>
      _appDataController.totalCigarettesSkipped.value;
  String get moneySaved => _appDataController.moneySaved.value;
  Duration get timeSinceQuit => _appDataController.timeSinceQuit.value;
  String get timeWonBack => _appDataController.timeWonBack.value;
  String get formattedTime => _appDataController.formattedTime.value;
  int get hoursQuit => _appDataController.hoursQuit.value;
  double get moneySavedValue => _appDataController.moneySavedValue.value;

  // User data for UI display
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;

  // GlobalKey to identify the widget we want to capture
  final GlobalKey cardKey = GlobalKey();

  @override
  void onReady() {
    super.onReady();
    // Use a longer delay to ensure data services are ready
    Future.delayed(const Duration(milliseconds: 800), () {
      loadUserData();
    });
  } // Removed onInit and onClose overrides

  // Internal flag to prevent concurrent fetch operations
  bool _isFetching = false;

  Future<void> loadUserData() async {
    // Prevent concurrent loads
    if (_isFetching) {
      debugPrint('⚠️ Load already in progress, skipping...');
      return;
    }

    _isFetching = true; // Set lock

    isLoading.value = true;
    debugPrint('🔄 DashboardController: Loading user data...');

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        debugPrint('❌ No current user');
        _resetToZero();
        return;
      }

      userData.value = {
        'fullName': currentUser.displayName ?? 'User',
        'email': currentUser.email ?? '',
        'isOnboardingComplete': true,
      };

      // Load data from the centralized data service
      await _dataService.loadAllData();

      // Single retry if quit date is null (instead of 3 attempts)
      if (_dataService.quitDate.value == null) {
        debugPrint('⚠️ Quit date is null, retrying once...');
        await Future.delayed(const Duration(milliseconds: 500));
        await _dataService.loadAllData();

        if (_dataService.quitDate.value != null) {
          debugPrint('✅ Quit date loaded on retry');
        } else {
          debugPrint('❌ No quit date found after retry');
          _resetToZero();
        }
      } else {
        debugPrint('✅ Data loaded successfully');
      }
    } catch (e) {
      debugPrint('❌ Error loading user data: $e');
      _resetToZero();
    } finally {
      isLoading.value = false;
      _isFetching = false;
    }
  }

  void _resetToZero() {
    _appDataController.resetToZero();

    // Set default user data
    userData.value = {
      'fullName': 'User',
      'email': '',
      'isOnboardingComplete': false,
    };
  }

  // Share progress functionality as image
  Future<void> shareProgressAsImage() async {
    try {
      // --- 1. Find the widget to capture ---
      RenderRepaintBoundary? boundary =
          cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint("Error: Could not find render boundary.");
        Get.snackbar(
          'Share Failed',
          'Could not capture card. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // --- 2. Convert the widget to an image ---
      // We set pixelRatio for better quality.
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // --- 3. Convert image to byte data (PNG format) ---
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final Uint8List? pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) {
        debugPrint("Error: Could not convert image to bytes.");
        Get.snackbar(
          'Share Failed',
          'Could not process image. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // --- 4. Get a temporary directory to save the file ---
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/quit_journey_card.png';
      final File file = File(filePath);

      // --- 5. Write the byte data to the file ---
      await file.writeAsBytes(pngBytes);
      debugPrint("Image saved to: $filePath");

      // --- 6. Share the file using share_plus ---
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Check out my quit smoking progress!',
        subject: 'My Quit Journey',
      );

      debugPrint('✅ Progress shared successfully as image');
    } catch (e) {
      debugPrint('❌ Error sharing progress as image: $e');
      Get.snackbar(
        'Share Failed',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Navigation methods
  void navigateToSettings() => Get.to(() => SettingsScreen());
  void navigateToProfile() => Get.to(() => ProfileScreen());
  void navigateToProgress() => Get.to(() => ProgressScreen());
  void navigateToAchievements() => Get.to(() => AchievementScreen());
  void navigateToHealth() => Get.to(() => HealthImprovementScreen());

  Future<void> refreshData() async {
    await loadUserData();
  }
}
