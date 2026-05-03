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
    const androidDetails = AndroidNotificationDetails(
      AppConstants.expiryAlertsChannelId,
      'Expiry Alerts',
      channelDescription: 'Notifications for medicine expiry dates',
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.Reminder,
      icon: '@mipmap/ic_launcher',
    );

    const stockChannelDetails = AndroidNotificationDetails(
      AppConstants.stockAlertsChannelId,
      'Stock Alerts',
      channelDescription: 'Notifications for low stock warnings',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      category: AndroidNotificationCategory.Reminder,
      icon: '@mipmap/ic_launcher',
    );

    const doseChannelDetails = AndroidNotificationDetails(
      AppConstants.doseRemindersChannelId,
      'Dose Reminders',
      channelDescription: 'Notifications for dose administration reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      category: AndroidNotificationCategory.Reminder,
      icon: '@mipmap/ic_launcher',
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidDetails);

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(stockChannelDetails);

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(doseChannelDetails);
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
      return granted;
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
      throw NotificationException('Notification service not initialized');
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
      category: AndroidNotificationCategory.Reminder,
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
      throw NotificationException('Notification service not initialized');
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
      category: AndroidNotificationCategory.Reminder,
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
    print('Notification tapped: ${response.payload}');
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
