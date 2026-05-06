import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';

/// Service for managing local notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize notification service and create channels
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels
    await _createNotificationChannels();

    _isInitialized = true;
  }

  /// Create notification channels for different alert types
  Future<void> _createNotificationChannels() async {
    const expiryChannel = AndroidNotificationChannel(
      AppConstants.expiryAlertsChannelId,
      'Expiry Alerts',
      description: 'Notifications for medicine expiry dates',
      importance: Importance.high,
    );

    const stockChannel = AndroidNotificationChannel(
      AppConstants.stockAlertsChannelId,
      'Stock Alerts',
      description: 'Notifications for low stock warnings',
      importance: Importance.defaultImportance,
    );

    const doseChannel = AndroidNotificationChannel(
      AppConstants.doseRemindersChannelId,
      'Dose Reminders',
      description: 'Notifications for dose administration reminders',
      importance: Importance.defaultImportance,
    );

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(expiryChannel);
      await androidPlugin.createNotificationChannel(stockChannel);
      await androidPlugin.createNotificationChannel(doseChannel);
    }
  }

  /// Request notification permissions (Android 13+)
  Future<bool> requestPermissions() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }

    return true;
  }

  /// Request exact alarm permission (Android 12+)
  Future<bool> requestExactAlarmPermission() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final granted = await androidPlugin.canScheduleExactNotifications();
      return granted ?? false;
    }

    return true;
  }

  /// Show an immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = AppConstants.expiryAlertsChannelId,
  }) async {
    if (!_isInitialized) {
      throw const NotificationException('Notification service not initialized');
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: channelId == AppConstants.expiryAlertsChannelId
          ? Importance.high
          : Importance.defaultImportance,
      priority: channelId == AppConstants.expiryAlertsChannelId
          ? Priority.high
          : Priority.defaultPriority,
      category: AndroidNotificationCategory.reminder,
      icon: '@mipmap/ic_launcher',
      fullScreenIntent: channelId == AppConstants.expiryAlertsChannelId,
      actions: [
        const AndroidNotificationAction(
          'view',
          'View Details',
          showsUserInterface: true,
        ),
        if (channelId == AppConstants.expiryAlertsChannelId) ...[
          const AndroidNotificationAction(
            'dispose',
            'Mark as Disposed',
            showsUserInterface: true,
          ),
          const AndroidNotificationAction(
            'snooze',
            'Snooze 1 Day',
            showsUserInterface: false,
          ),
        ],
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Schedule a notification for a specific time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String channelId = AppConstants.expiryAlertsChannelId,
  }) async {
    if (!_isInitialized) {
      throw const NotificationException('Notification service not initialized');
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: channelId == AppConstants.expiryAlertsChannelId
          ? Importance.high
          : Importance.defaultImportance,
      priority: channelId == AppConstants.expiryAlertsChannelId
          ? Priority.high
          : Priority.defaultPriority,
      category: AndroidNotificationCategory.reminder,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Schedule a daily recurring notification
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    String? payload,
    String channelId = AppConstants.doseRemindersChannelId,
  }) async {
    if (!_isInitialized) {
      throw const NotificationException('Notification service not initialized');
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // This would typically navigate to the relevant screen
    // Implementation depends on navigation setup
    // debugPrint('Notification tapped'); 
  }

  String _getChannelName(String channelId) {
    switch (channelId) {
      case AppConstants.expiryAlertsChannelId:
        return 'Expiry Alerts';
      case AppConstants.stockAlertsChannelId:
        return 'Stock Alerts';
      case AppConstants.doseRemindersChannelId:
        return 'Dose Reminders';
      default:
        return 'General';
    }
  }

  String _getChannelDescription(String channelId) {
    switch (channelId) {
      case AppConstants.expiryAlertsChannelId:
        return 'Notifications for medicine expiry dates';
      case AppConstants.stockAlertsChannelId:
        return 'Notifications for low stock warnings';
      case AppConstants.doseRemindersChannelId:
        return 'Notifications for dose administration reminders';
      default:
        return 'General notifications';
    }
  }
}
