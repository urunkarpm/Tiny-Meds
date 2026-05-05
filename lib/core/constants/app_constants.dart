/// App-wide constants following Material 3 guidelines
class AppConstants {
  AppConstants._();

  // Spacing increments (4dp base unit)
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing28 = 28.0;
  static const double spacing32 = 32.0;

  // Screen edge padding
  static const double screenPadding = 16.0;

  // Minimum touch target size (Material 3 accessibility requirement)
  static const double minTouchTarget = 48.0;

  // Motion durations
  static const Duration microInteractionDuration = Duration(milliseconds: 150);
  static const Duration transitionDuration = Duration(milliseconds: 300);

  // Expiry status thresholds
  static const int expiringSoonThresholdDays = 30;
  static const int expiringVerySoonThresholdDays = 7;

  // Notification channel IDs
  static const String expiryAlertsChannelId = 'expiry_alerts';
  static const String stockAlertsChannelId = 'stock_alerts';
  static const String doseRemindersChannelId = 'dose_reminders';

  // Work manager task names
  static const String checkExpiryTaskName = 'check_expiry_task';
  static const String checkLowStockTaskName = 'check_low_stock_task';
}
