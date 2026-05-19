import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// State class for app settings
class SettingsState {
  final bool expiryAlertsEnabled;
  final bool lowStockAlertsEnabled;
  final bool doseRemindersEnabled;
  final bool quietHoursEnabled;
  final String quietHoursStart;
  final String quietHoursEnd;
  final String notificationSound;
  final int defaultLeadTime;
  final int lowStockThreshold;
  final String defaultLocation;
  final String? geminiApiKey;

  SettingsState({
    required this.expiryAlertsEnabled,
    required this.lowStockAlertsEnabled,
    required this.doseRemindersEnabled,
    required this.quietHoursEnabled,
    required this.quietHoursStart,
    required this.quietHoursEnd,
    required this.notificationSound,
    required this.defaultLeadTime,
    required this.lowStockThreshold,
    required this.defaultLocation,
    this.geminiApiKey,
  });

  SettingsState copyWith({
    bool? expiryAlertsEnabled,
    bool? lowStockAlertsEnabled,
    bool? doseRemindersEnabled,
    bool? quietHoursEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    String? notificationSound,
    int? defaultLeadTime,
    int? lowStockThreshold,
    String? defaultLocation,
    String? geminiApiKey,
  }) {
    return SettingsState(
      expiryAlertsEnabled: expiryAlertsEnabled ?? this.expiryAlertsEnabled,
      lowStockAlertsEnabled: lowStockAlertsEnabled ?? this.lowStockAlertsEnabled,
      doseRemindersEnabled: doseRemindersEnabled ?? this.doseRemindersEnabled,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      notificationSound: notificationSound ?? this.notificationSound,
      defaultLeadTime: defaultLeadTime ?? this.defaultLeadTime,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      defaultLocation: defaultLocation ?? this.defaultLocation,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
    );
  }
}

/// Notifier for managing app settings
class SettingsNotifier extends StateNotifier<AsyncValue<SettingsState>> {
  SettingsNotifier() : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const secureStorage = FlutterSecureStorage();
      final apiKey = await secureStorage.read(key: 'gemini_api_key');

      state = AsyncValue.data(SettingsState(
        expiryAlertsEnabled: prefs.getBool('expiry_alerts_enabled') ?? true,
        lowStockAlertsEnabled:
            prefs.getBool('low_stock_alerts_enabled') ?? true,
        doseRemindersEnabled: prefs.getBool('dose_reminders_enabled') ?? false,
        quietHoursEnabled: prefs.getBool('quiet_hours_enabled') ?? false,
        quietHoursStart: prefs.getString('quiet_hours_start') ?? '22:00',
        quietHoursEnd: prefs.getString('quiet_hours_end') ?? '07:00',
        notificationSound:
            prefs.getString('notification_sound') ?? 'Soft chime',
        defaultLeadTime: prefs.getInt('default_lead_time') ?? 7,
        lowStockThreshold: prefs.getInt('low_stock_threshold') ?? 3,
        defaultLocation: prefs.getString('default_location') ?? 'Kitchen',
        geminiApiKey: apiKey,
      ));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateSetting<T>(String key, T value) async {
    if (key == 'gemini_api_key') {
      const secureStorage = FlutterSecureStorage();
      if (value == null || (value is String && value.isEmpty)) {
        await secureStorage.delete(key: key);
      } else {
        await secureStorage.write(key: key, value: value as String);
      }
      state.whenData((current) {
        state = AsyncValue.data(current.copyWith(geminiApiKey: value as String?));
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }

    state.whenData((current) {
      state = AsyncValue.data(_updateStateFromKey(current, key, value));
    });
  }

  SettingsState _updateStateFromKey(
      SettingsState current, String key, dynamic value) {
    switch (key) {
      case 'expiry_alerts_enabled':
        return current.copyWith(expiryAlertsEnabled: value);
      case 'low_stock_alerts_enabled':
        return current.copyWith(lowStockAlertsEnabled: value);
      case 'dose_reminders_enabled':
        return current.copyWith(doseRemindersEnabled: value);
      case 'quiet_hours_enabled':
        return current.copyWith(quietHoursEnabled: value);
      case 'quiet_hours_start':
        return current.copyWith(quietHoursStart: value);
      case 'quiet_hours_end':
        return current.copyWith(quietHoursEnd: value);
      case 'notification_sound':
        return current.copyWith(notificationSound: value);
      case 'default_lead_time':
        return current.copyWith(defaultLeadTime: value);
      case 'low_stock_threshold':
        return current.copyWith(lowStockThreshold: value);
      case 'default_location':
        return current.copyWith(defaultLocation: value);
      default:
        return current;
    }
  }
}

/// Provider for app settings
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<SettingsState>>((ref) {
  return SettingsNotifier();
});
