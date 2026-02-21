import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

// Screen imports for navigation
import 'package:quitease/features/achievements/presentation/screens/achievement_screen.dart';
import 'package:quitease/features/health/presentation/screens/health_improvement_screen.dart';
import 'package:quitease/features/progress/presentation/screens/progress_screen.dart';

/// Service for managing local notifications in the QuitEase app
/// Handles initialization, scheduling, and displaying notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Notification channel IDs
  static const String _motivationalChannelId = 'motivational_channel';
  static const String _milestonesChannelId = 'milestones_channel';
  static const String _healthChannelId = 'health_channel';
  static const String _dailyRemindersChannelId = 'daily_reminders_channel';

  // Notification channel names
  static const String _motivationalChannelName = 'Motivational Messages';
  static const String _milestonesChannelName = 'Milestone Celebrations';
  static const String _healthChannelName = 'Health Progress';
  static const String _dailyRemindersChannelName = 'Daily Reminders';

  bool _initialized = false;

  /// Initialize the notification service
  /// Should be called once during app startup
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize timezone database
      tz.initializeTimeZones();

      // Set local time zone (default to Pakistan)
      tz.setLocalLocation(tz.getLocation('Asia/Karachi'));

      // Android initialization settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: androidSettings);

      // Initialize plugin
      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channels for Android
      await _createNotificationChannels();

      _initialized = true;
      debugPrint('✅ NotificationService initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing NotificationService: $e');
    }
  }

  /// Create Android notification channels
  Future<void> _createNotificationChannels() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin == null) return;

    // Motivational Channel - Default importance
    const AndroidNotificationChannel motivationalChannel =
        AndroidNotificationChannel(
          _motivationalChannelId,
          _motivationalChannelName,
          description: 'Daily motivational messages to keep you on track',
          importance: Importance.defaultImportance,
          playSound: true,
          enableVibration: false,
        );

    // Milestones Channel - High importance with sound and vibration
    const AndroidNotificationChannel milestonesChannel =
        AndroidNotificationChannel(
          _milestonesChannelId,
          _milestonesChannelName,
          description: 'Celebrate your achievements and milestones',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          enableLights: true,
        );

    // Health Progress Channel - Default importance
    const AndroidNotificationChannel healthChannel = AndroidNotificationChannel(
      _healthChannelId,
      _healthChannelName,
      description: 'Updates on your health improvements',
      importance: Importance.defaultImportance,
      playSound: true,
      enableVibration: false,
    );

    // Daily Reminders Channel - Low importance
    const AndroidNotificationChannel dailyRemindersChannel =
        AndroidNotificationChannel(
          _dailyRemindersChannelId,
          _dailyRemindersChannelName,
          description: 'Daily check-ins and gentle reminders',
          importance: Importance.low,
          playSound: false,
          enableVibration: false,
        );

    // Create all channels
    await androidPlugin.createNotificationChannel(motivationalChannel);
    await androidPlugin.createNotificationChannel(milestonesChannel);
    await androidPlugin.createNotificationChannel(healthChannel);
    await androidPlugin.createNotificationChannel(dailyRemindersChannel);

    debugPrint('✅ Android notification channels created');
  }

  /// Request notification permissions (Android 13+)
  Future<bool> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin == null) return false;

    try {
      final bool? granted = await androidPlugin
          .requestNotificationsPermission();
      if (granted == true) {
        debugPrint('✅ Notification permissions granted');
        return true;
      } else {
        debugPrint('❌ Notification permissions denied');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error requesting notification permissions: $e');
      return false;
    }
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin == null) return false;

    try {
      final bool? enabled = await androidPlugin.areNotificationsEnabled();
      return enabled ?? false;
    } catch (e) {
      debugPrint('❌ Error checking notification status: $e');
      return false;
    }
  }

  /// Show an immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required NotificationChannel channel,
    String? payload,
  }) async {
    if (!_initialized) {
      debugPrint('⚠️ NotificationService not initialized');
      return;
    }

    try {
      final AndroidNotificationDetails androidDetails = _getAndroidDetails(
        channel,
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );

      await _notificationsPlugin.show(
        id,
        title,
        body,
        platformDetails,
        payload: payload,
      );

      debugPrint('✅ Notification shown: $title');
    } catch (e) {
      debugPrint('❌ Error showing notification: $e');
    }
  }

  /// Schedule a notification for a specific time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required NotificationChannel channel,
    String? payload,
  }) async {
    if (!_initialized) {
      debugPrint('⚠️ NotificationService not initialized');
      return;
    }

    try {
      final AndroidNotificationDetails androidDetails = _getAndroidDetails(
        channel,
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );

      debugPrint('✅ Notification scheduled for: $scheduledTime');
    } catch (e) {
      debugPrint('❌ Error scheduling notification: $e');
    }
  }

  /// Schedule a daily notification at a specific time
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay notificationTime,
    required NotificationChannel channel,
    String? payload,
  }) async {
    if (!_initialized) {
      debugPrint('⚠️ NotificationService not initialized');
      return;
    }

    try {
      final AndroidNotificationDetails androidDetails = _getAndroidDetails(
        channel,
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );

      // Calculate next occurrence of the specified time
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        notificationTime.hour,
        notificationTime.minute,
        0, // seconds
      );

      // If the time has already passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );

      debugPrint(
        '✅ Daily notification scheduled at: ${notificationTime.hour}:${notificationTime.minute}',
      );
    } catch (e) {
      debugPrint('❌ Error scheduling daily notification: $e');
    }
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
      debugPrint('✅ Notification $id cancelled');
    } catch (e) {
      debugPrint('❌ Error cancelling notification: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      debugPrint('✅ All notifications cancelled');
    } catch (e) {
      debugPrint('❌ Error cancelling all notifications: $e');
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      final List<PendingNotificationRequest> pending =
          await _notificationsPlugin.pendingNotificationRequests();
      debugPrint('📋 Pending notifications: ${pending.length}');
      return pending;
    } catch (e) {
      debugPrint('❌ Error getting pending notifications: $e');
      return [];
    }
  }

  /// Get Android notification details based on channel
  AndroidNotificationDetails _getAndroidDetails(NotificationChannel channel) {
    const String defaultIcon = '@mipmap/ic_launcher';
    const Color brandColor = Color(0xFF1976D2); // SereneAscent deepBlue

    switch (channel) {
      case NotificationChannel.motivational:
        return BigTextStyleInformation(
          '', // Content will be replaced by the body
          contentTitle: 'Motivation',
          summaryText: 'You\'ve got this!',
        ).toAndroidDetails(
          _motivationalChannelId,
          _motivationalChannelName,
          channelDescription:
              'Daily motivational messages to keep you on track',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          color: brandColor,
          largeIcon: const DrawableResourceAndroidBitmap(defaultIcon),
        );

      case NotificationChannel.milestones:
        return BigTextStyleInformation(
          '',
          contentTitle: 'Achievement Unlocked! 🏆',
          summaryText: 'Milestone reached',
        ).toAndroidDetails(
          _milestonesChannelId,
          _milestonesChannelName,
          channelDescription: 'Celebrate your achievements and milestones',
          importance: Importance.high,
          priority: Priority.high,
          color: brandColor,
          largeIcon: const DrawableResourceAndroidBitmap(defaultIcon),
          enableVibration: true,
          enableLights: true,
          ledColor: brandColor,
          ledOnMs: 1000,
          ledOffMs: 500,
        );

      case NotificationChannel.health:
        return BigTextStyleInformation(
          '',
          contentTitle: 'Health Update',
          summaryText: 'Your body is healing',
        ).toAndroidDetails(
          _healthChannelId,
          _healthChannelName,
          channelDescription: 'Updates on your health improvements',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          color: brandColor,
          largeIcon: const DrawableResourceAndroidBitmap(defaultIcon),
        );

      case NotificationChannel.dailyReminders:
        return BigTextStyleInformation(
          '',
          contentTitle: 'Daily Catch-up',
          summaryText: 'Stay on track',
        ).toAndroidDetails(
          _dailyRemindersChannelId,
          _dailyRemindersChannelName,
          channelDescription: 'Daily check-ins and gentle reminders',
          importance: Importance.low,
          priority: Priority.low,
          color: brandColor,
          largeIcon: const DrawableResourceAndroidBitmap(defaultIcon),
        );
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');

    final payload = response.payload;
    if (payload == null || payload.isEmpty) {
      // No payload, navigate to dashboard
      _navigateToDashboard();
      return;
    }

    // Parse payload format: "type:subtype:value"
    final parts = payload.split(':');
    final type = parts.isNotEmpty ? parts[0] : '';

    switch (type) {
      case 'milestone':
        // Navigate to achievements screen
        _navigateToAchievements();
        break;
      case 'health':
        // Navigate to health improvements screen
        _navigateToHealth();
        break;
      case 'daily':
      case 'checkin':
        // Navigate to progress screen
        _navigateToProgress();
        break;
      case 'motivational':
      case 'craving':
        // Navigate to dashboard
        _navigateToDashboard();
        break;
      default:
        // Unknown type, navigate to dashboard
        debugPrint('⚠️ Unknown notification type: $type');
        _navigateToDashboard();
    }
  }

  /// Navigation helper methods
  void _navigateToDashboard() {
    try {
      // DashboardScreen requires user parameter, so navigate to home route instead
      Get.offAllNamed('/home');
    } catch (e) {
      debugPrint('❌ Error navigating to dashboard: $e');
    }
  }

  void _navigateToAchievements() {
    try {
      Get.to(() => AchievementScreen());
    } catch (e) {
      debugPrint('❌ Error navigating to achievements: $e');
      _navigateToDashboard();
    }
  }

  void _navigateToHealth() {
    try {
      Get.to(() => HealthImprovementScreen());
    } catch (e) {
      debugPrint('❌ Error navigating to health: $e');
      _navigateToDashboard();
    }
  }

  void _navigateToProgress() {
    try {
      Get.to(() => ProgressScreen());
    } catch (e) {
      debugPrint('❌ Error navigating to progress: $e');
      _navigateToDashboard();
    }
  }
}

extension BigTextStyleAndroidDetails on BigTextStyleInformation {
  AndroidNotificationDetails toAndroidDetails(
    String channelId,
    String channelName, {
    required String channelDescription,
    required Importance importance,
    required Priority priority,
    required Color color,
    required DrawableResourceAndroidBitmap largeIcon,
    bool enableVibration = false,
    bool enableLights = false,
    Color? ledColor,
    int? ledOnMs,
    int? ledOffMs,
  }) {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: priority,
      color: color,
      largeIcon: largeIcon,
      styleInformation: this,
      enableVibration: enableVibration,
      enableLights: enableLights,
      ledColor: ledColor,
      ledOnMs: ledOnMs ?? 0,
      ledOffMs: ledOffMs ?? 0,
    );
  }
}

/// Notification channel types
enum NotificationChannel { motivational, milestones, health, dailyReminders }
