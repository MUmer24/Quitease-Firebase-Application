import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/shared/services/storage/data_persistence_service.dart';
import 'package:quitease/features/achievements/presentation/controllers/achievement_controller.dart';
import 'package:quitease/shared/utils/savings_calculator.dart';
import 'package:quitease/shared/utils/time_calculator.dart';
import 'package:quitease/shared/services/notification/notification_scheduler.dart';

class AppDataController extends GetxController {
  static AppDataController get instance => Get.find();

  final DataPersistenceService _dataService = Get.find();
  final SavingsCalculator _savingsCalculator = Get.find();
  final TimeWonBackCalculator _timeCalculator = Get.find();
  NotificationScheduler? _notificationScheduler;

  // Timer for periodic updates
  Timer? _timer;

  // Reactive data variables
  final Rx<Duration> timeSinceQuit = Rx(Duration.zero);
  final RxInt totalCigarettesSkipped = 0.obs;
  final RxString moneySaved = '0.0'.obs;
  final RxString timeWonBack = ''.obs;
  final RxString formattedTime = '00 00 00'.obs;
  final RxInt hoursQuit = 0.obs;
  final RxDouble moneySavedValue = 0.0.obs;

  // Previous values for milestone detection
  int _previousCigarettesSkipped = 0;
  double _previousMoneySaved = 0.0;

  @override
  void onInit() {
    super.onInit();
    // Initialize notification scheduler
    try {
      _notificationScheduler = Get.find<NotificationScheduler>();
    } catch (e) {
      // NotificationScheduler might not be registered yet
    }

    // Listen to data changes from the persistence service
    _dataService.quitDate.listen((_) => _startTimer());
    _startTimer();
  }

  @override
  void onClose() {
    // Cancel timer to prevent memory leak
    // Timer will be recreated when controller is initialized again
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer?.cancel();
    if (_dataService.quitDate.value != null) {
      // Update immediately
      _updateStatistics();

      // Log progress immediately
      _logProgress();

      // Then update every second
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _updateStatistics();

        // Log progress every 3 minutes
        if (timer.tick % (3 * 60) == 0) {
          _logProgress();
        }
      });
    }
  }

  Future<void> _updateStatistics() async {
    if (_dataService.quitDate.value == null) return;

    try {
      final now = DateTime.now();
      final duration = now.difference(_dataService.quitDate.value!);
      timeSinceQuit.value = duration;

      // Update formatted time display
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      final seconds = duration.inSeconds.remainder(60);
      formattedTime.value =
          '${hours.toString().padLeft(2, '0')} ${minutes.toString().padLeft(2, '0')} ${seconds.toString().padLeft(2, '0')}';
      hoursQuit.value = hours;

      // Calculate statistics using the calculators
      final savings = _savingsCalculator.calculateSavings(
        quitDate: _dataService.quitDate.value!,
        cigarettesPerDay: _dataService.cigarettesPerDay.value.toInt(),
        cigarettesPerPack: _dataService.cigarettesPerPack.value.toInt(),
        pricePerPack: _dataService.pricePerPack.value,
      );

      totalCigarettesSkipped.value = savings['cigarettesSkipped'];
      moneySaved.value = savings['moneySaved'].toStringAsFixed(1);
      moneySavedValue.value = savings['moneySaved'];

      timeWonBack.value = _timeCalculator.calculateTimeWonBack(
        cigarettesSkipped: totalCigarettesSkipped.value,
      );

      // Check for milestone crossings
      _checkMilestones();
    } catch (e) {
      // Handle errors gracefully - don't crash the app
      debugPrint('❌ Error updating statistics: $e');
      // Keep previous values, don't reset to zero
    }
  }

  /// Check and trigger milestone notifications
  void _checkMilestones() {
    if (_notificationScheduler == null) return;

    // Cigarette milestones: 10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000
    final cigaretteThresholds = [
      10,
      25,
      50,
      100,
      250,
      500,
      1000,
      2500,
      5000,
      10000,
    ];
    for (int threshold in cigaretteThresholds) {
      if (_previousCigarettesSkipped < threshold &&
          totalCigarettesSkipped.value >= threshold) {
        _notificationScheduler!.showCigaretteMilestone(threshold);
        break; // Only show one milestone at a time
      }
    }

    // Money milestones: 20, 50, 100, 500, 1000, 5000, 10000
    final moneyThresholds = [20.0, 50.0, 100.0, 500.0, 1000.0, 5000.0, 10000.0];
    for (double threshold in moneyThresholds) {
      if (_previousMoneySaved < threshold &&
          moneySavedValue.value >= threshold) {
        _notificationScheduler!.showMoneySavedMilestone(threshold);
        break; // Only show one milestone at a time
      }
    }

    // Update previous values
    _previousCigarettesSkipped = totalCigarettesSkipped.value;
    _previousMoneySaved = moneySavedValue.value;
  }

  /// Reset all statistics to zero
  void resetToZero() {
    totalCigarettesSkipped.value = 0;
    moneySaved.value = '0.0';
    timeWonBack.value = '';
    timeSinceQuit.value = Duration.zero;
    formattedTime.value = '00 00 00';
    hoursQuit.value = 0;
    moneySavedValue.value = 0.0;
  }

  /// Refresh all data
  Future<void> refreshData() async {
    await _dataService.loadAllData();
    _updateStatistics();
  }

  // Add this method to AppDataController class
  void _logProgress() {
    final now = DateTime.now();
    final hours = timeSinceQuit.value.inHours;
    final minutes = timeSinceQuit.value.inMinutes.remainder(60);
    final seconds = timeSinceQuit.value.inSeconds.remainder(60);

    final achievementController = Get.find<AchievementController>();

    debugPrint('''

=== Progress Update (${now.hour}:${now.minute}:${now.second}) ===
Time Quit: ${hours}h ${minutes}m ${seconds}s
Cigarettes Avoided: ${totalCigarettesSkipped.value}
Money Saved: \$${moneySavedValue.value.toStringAsFixed(2)}
Time Saved: ${timeWonBack.value}
Achievements: ${achievementController.completedAchievements.value}/${achievementController.totalAchievements.value}
Health Benefits:
- Lungs are starting to clear
- Blood pressure is normalizing
- Oxygen levels are improving
- Risk of heart disease is decreasing
===============================
  ''');
  }
}
