import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitease/shared/models/notification_config.dart';
import 'package:quitease/features/achievements/models/notification_settings_model.dart';
import 'package:quitease/shared/services/notification/notification_service.dart';

/// Service for scheduling and managing notification timing
/// Handles adaptive scheduling, quiet hours, and milestone notifications
class NotificationScheduler {
  static NotificationScheduler get instance => Get.find();

  final NotificationService _notificationService = Get.find();
  final Random _random = Random();

  // Settings - will be loaded from user preferences
  NotificationSettingsModel _settings = NotificationSettingsModel();

  /// Initialize scheduler with user settings
  Future<void> initialize(NotificationSettingsModel settings) async {
    _settings = settings;
    debugPrint('✅ NotificationScheduler initialized');
  }

  /// Update settings (when user changes preferences)
  void updateSettings(NotificationSettingsModel settings) {
    _settings = settings;
    debugPrint('🔄 NotificationScheduler settings updated');
  }

  /// Schedule daily check-in notifications
  Future<void> scheduleDailyCheckIns() async {
    if (!_settings.dailyCheckInsEnabled) {
      debugPrint('⏭️ Daily check-ins disabled, skipping');
      return;
    }

    // Morning check-in at 9 AM
    await _scheduleCheckInIfNotQuiet(
      id: NotificationConfig.dailyCheckInBaseId,
      time: const TimeOfDay(hour: 9, minute: 0),
      message: NotificationConfig.dailyCheckIns[0], // "Good morning!"
    );

    // Evening check-in at 8 PM
    await _scheduleCheckInIfNotQuiet(
      id: NotificationConfig.dailyCheckInBaseId + 1,
      time: const TimeOfDay(hour: 20, minute: 0),
      message: NotificationConfig.dailyCheckIns[2], // "Evening check-in"
    );

    debugPrint('✅ Daily check-ins scheduled');
  }

  /// Schedule motivational messages based on adaptive frequency
  Future<void> scheduleMotivationalMessages(int daysSinceQuit) async {
    if (!_settings.motivationalEnabled) {
      debugPrint('⏭️ Motivational messages disabled, skipping');
      return;
    }

    final int count = _getAdaptiveCount(daysSinceQuit);
    debugPrint(
      '📅 Scheduling $count motivational messages for day $daysSinceQuit',
    );

    for (int i = 0; i < count; i++) {
      final DateTime scheduledTime = _generateRandomTime(i, count);

      if (_isWithinQuietHours(TimeOfDay.fromDateTime(scheduledTime))) {
        continue; // Skip if it falls in quiet hours
      }

      final String message = _getRandomMotivationalMessage();

      await _notificationService.scheduleNotification(
        id: NotificationConfig.motivationalBaseId + i,
        title: '💪 Stay Strong',
        body: message,
        scheduledTime: scheduledTime,
        channel: NotificationChannel.motivational,
      );
    }

    debugPrint('✅ $count motivational messages scheduled');
  }

  /// Schedule health update notifications based on quit timeline
  Future<void> scheduleHealthUpdates(int hoursSinceQuit) async {
    if (!_settings.healthUpdatesEnabled) {
      debugPrint('⏭️ Health updates disabled, skipping');
      return;
    }

    // Get the appropriate health milestone
    final milestone = NotificationConfig.getHealthMilestone(hoursSinceQuit);

    // Schedule for a reasonable time (avoid immediate spam)
    final DateTime scheduledTime = DateTime.now().add(
      const Duration(minutes: 5),
    );

    if (_isWithinQuietHours(TimeOfDay.fromDateTime(scheduledTime))) {
      debugPrint('⏭️ Health update falls in quiet hours, skipping');
      return;
    }

    await _notificationService.scheduleNotification(
      id: NotificationConfig.healthBaseId,
      title: milestone['title']!,
      body: milestone['body']!,
      scheduledTime: scheduledTime,
      channel: NotificationChannel.health,
    );

    debugPrint('✅ Health update scheduled');
  }

  /// Trigger immediate milestone notification
  Future<void> showMilestoneNotification({
    required String title,
    required String body,
    int? customId,
  }) async {
    if (!_settings.milestonesEnabled) {
      debugPrint('⏭️ Milestones disabled, skipping');
      return;
    }

    await _notificationService.showNotification(
      id: customId ?? NotificationConfig.milestoneBaseId,
      title: title,
      body: body,
      channel: NotificationChannel.milestones,
    );

    debugPrint('🎉 Milestone notification shown: $title');
  }

  /// Show cigarette milestone celebration
  Future<void> showCigaretteMilestone(int cigarettesAvoided) async {
    final milestone = NotificationConfig.getCigaretteMilestone(
      cigarettesAvoided,
    );
    await showMilestoneNotification(
      title: milestone['title']!,
      body: milestone['body']!,
      customId: NotificationConfig.milestoneBaseId + 1,
    );
  }

  /// Show money saved milestone celebration
  Future<void> showMoneySavedMilestone(double amountSaved) async {
    final milestone = NotificationConfig.getMoneySavedMilestone(amountSaved);
    await showMilestoneNotification(
      title: milestone['title']!,
      body: milestone['body']!,
      customId: NotificationConfig.milestoneBaseId + 2,
    );
  }

  /// Show craving tip notification
  Future<void> showCravingTip() async {
    if (!_settings.cravingTipsEnabled) {
      debugPrint('⏭️ Craving tips disabled, skipping');
      return;
    }

    final String tip = _getRandomCravingTip();

    await _notificationService.showNotification(
      id: NotificationConfig.cravingTipBaseId,
      title: '🧘 Craving Management',
      body: tip,
      channel: NotificationChannel.motivational,
    );

    debugPrint('💡 Craving tip shown');
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAllScheduled() async {
    await _notificationService.cancelAllNotifications();
    debugPrint('🗑️ All scheduled notifications cancelled');
  }

  // ==================== PRIVATE HELPERS ====================

  /// Get adaptive notification count based on quit duration
  int _getAdaptiveCount(int daysSinceQuit) {
    // Base frequency from user settings
    int baseCount = _settings.dailyNotificationCount;

    // Adaptive logic:
    // - Week 1: High frequency (boost by 100%)
    // - Weeks 2-4: Medium-high (boost by 50%)
    // - After 30 days: Reduce to base setting
    if (daysSinceQuit <= 7) {
      return (baseCount * 2).clamp(2, 6);
    } else if (daysSinceQuit <= 30) {
      return (baseCount * 1.5).round().clamp(1, 5);
    } else {
      return baseCount;
    }
  }

  /// Generate random time for notification (avoiding quiet hours)
  DateTime _generateRandomTime(int index, int totalCount) {
    final now = DateTime.now();

    // Distribute notifications throughout the day
    // Avoid early morning (6-8 AM) and late night (10 PM - 6 AM)
    final int startHour = 8;
    final int endHour = 22;
    final int availableHours = endHour - startHour;

    // Calculate slot for this notification
    final int slotDuration = (availableHours * 60) ~/ totalCount; // in minutes
    final int slotStart = startHour * 60 + (index * slotDuration);

    // Add random variation within the slot (±30 minutes)
    final int randomOffset = _random.nextInt(60) - 30;
    final int totalMinutes = (slotStart + randomOffset).clamp(
      startHour * 60,
      endHour * 60,
    );

    final int hour = totalMinutes ~/ 60;
    final int minute = totalMinutes % 60;

    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  /// Check if time is within quiet hours
  bool _isWithinQuietHours(TimeOfDay time) {
    return _settings.isQuietHours();
  }

  /// Schedule a check-in if not in quiet hours
  Future<void> _scheduleCheckInIfNotQuiet({
    required int id,
    required TimeOfDay time,
    required String message,
  }) async {
    if (_isWithinQuietHours(time)) {
      debugPrint(
        '⏭️ Check-in at ${time.hour}:${time.minute} falls in quiet hours, skipping',
      );
      return;
    }

    await _notificationService.scheduleDailyNotification(
      id: id,
      title: '📊 Daily Check-In',
      body: message,
      notificationTime: time,
      channel: NotificationChannel.dailyReminders,
    );
  }

  /// Get random motivational message
  String _getRandomMotivationalMessage() {
    final int index = _random.nextInt(
      NotificationConfig.motivationalMessages.length,
    );
    return NotificationConfig.motivationalMessages[index];
  }

  /// Get random craving tip
  String _getRandomCravingTip() {
    final int index = _random.nextInt(NotificationConfig.cravingTips.length);
    return NotificationConfig.cravingTips[index];
  }
}
