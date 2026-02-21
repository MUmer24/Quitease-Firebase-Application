import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Model for user notification preferences and settings
class NotificationSettingsModel {
  // Notification type toggles
  bool motivationalEnabled;
  bool milestonesEnabled;
  bool healthUpdatesEnabled;
  bool dailyCheckInsEnabled;
  bool cravingTipsEnabled;

  // Quiet hours configuration
  bool quietHoursEnabled;
  int quietHoursStart; // Hour (0-23)
  int quietHoursEnd; // Hour (0-23)

  // Frequency preference
  NotificationFrequency frequency;

  // Last notification timestamps (to prevent spam)
  DateTime? lastMotivationalNotification;
  DateTime? lastHealthNotification;
  DateTime? lastDailyCheckIn;

  NotificationSettingsModel({
    this.motivationalEnabled = true,
    this.milestonesEnabled = true,
    this.healthUpdatesEnabled = true,
    this.dailyCheckInsEnabled = true,
    this.cravingTipsEnabled = true,
    this.quietHoursEnabled = true,
    this.quietHoursStart = 22, // 10 PM
    this.quietHoursEnd = 7, // 7 AM
    this.frequency = NotificationFrequency.medium,
    this.lastMotivationalNotification,
    this.lastHealthNotification,
    this.lastDailyCheckIn,
  });

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'motivationalEnabled': motivationalEnabled,
      'milestonesEnabled': milestonesEnabled,
      'healthUpdatesEnabled': healthUpdatesEnabled,
      'dailyCheckInsEnabled': dailyCheckInsEnabled,
      'cravingTipsEnabled': cravingTipsEnabled,
      'quietHoursEnabled': quietHoursEnabled,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
      'frequency': frequency.name,
      'lastMotivationalNotification': lastMotivationalNotification
          ?.toIso8601String(),
      'lastHealthNotification': lastHealthNotification?.toIso8601String(),
      'lastDailyCheckIn': lastDailyCheckIn?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      motivationalEnabled: json['motivationalEnabled'] ?? true,
      milestonesEnabled: json['milestonesEnabled'] ?? true,
      healthUpdatesEnabled: json['healthUpdatesEnabled'] ?? true,
      dailyCheckInsEnabled: json['dailyCheckInsEnabled'] ?? true,
      cravingTipsEnabled: json['cravingTipsEnabled'] ?? true,
      quietHoursEnabled: json['quietHoursEnabled'] ?? true,
      quietHoursStart: json['quietHoursStart'] ?? 22,
      quietHoursEnd: json['quietHoursEnd'] ?? 7,
      frequency: NotificationFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
        orElse: () => NotificationFrequency.medium,
      ),
      lastMotivationalNotification: json['lastMotivationalNotification'] != null
          ? DateTime.parse(json['lastMotivationalNotification'])
          : null,
      lastHealthNotification: json['lastHealthNotification'] != null
          ? DateTime.parse(json['lastHealthNotification'])
          : null,
      lastDailyCheckIn: json['lastDailyCheckIn'] != null
          ? DateTime.parse(json['lastDailyCheckIn'])
          : null,
    );
  }

  /// Save settings to SharedPreferences
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = toJson();
    final jsonString = jsonEncode(jsonData);
    await prefs.setString('notification_settings', jsonString);
  }

  /// Load settings from SharedPreferences
  static Future<NotificationSettingsModel> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('notification_settings');

    if (jsonString == null || jsonString.isEmpty) {
      return NotificationSettingsModel(); // Return default settings
    }

    try {
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      return NotificationSettingsModel.fromJson(jsonData);
    } catch (e) {
      return NotificationSettingsModel(); // Return default on error
    }
  }

  /// Check if current time is within quiet hours
  bool isQuietHours() {
    if (!quietHoursEnabled) return false;

    final now = DateTime.now();
    final currentHour = now.hour;

    if (quietHoursStart < quietHoursEnd) {
      // Normal range (e.g., 22-7 doesn't cross midnight)
      // This shouldn't happen with default 22-7, but handle it
      return currentHour >= quietHoursStart && currentHour < quietHoursEnd;
    } else {
      // Range crosses midnight (e.g., 22-7 means 10 PM to 7 AM)
      return currentHour >= quietHoursStart || currentHour < quietHoursEnd;
    }
  }

  /// Get notification count based on frequency preference
  int get dailyNotificationCount {
    switch (frequency) {
      case NotificationFrequency.low:
        return 1;
      case NotificationFrequency.medium:
        return 3;
      case NotificationFrequency.high:
        return 5;
    }
  }
}

/// Notification frequency preference
enum NotificationFrequency {
  low, // 1-2 notifications per day
  medium, // 3-4 notifications per day
  high, // 5-6 notifications per day
}
