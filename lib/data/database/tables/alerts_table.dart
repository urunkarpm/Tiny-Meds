import 'package:drift/drift.dart';
import '../../models/enums.dart';
import 'medicine_inventory_table.dart';

/// Drift table for storing alerts
@DataClassName('AlertData')
class Alerts extends Table {
  /// Primary key, auto-increment
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key to MedicineInventory
  IntColumn get medicineId => integer().references(MedicineInventory, #id)();

  /// Alert type: expiry, low_stock, dose_reminder
  TextColumn get type => text().map(const AlertTypeConverter())();

  /// Trigger date/time for the alert
  DateTimeColumn get triggerDate => dateTime()();

  /// Recurrence pattern: none, daily, weekly, custom
  TextColumn get recurrence => text().map(const RecurrencePatternConverter()).nullable()();

  /// Whether the alert is active
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// Last time this alert was notified
  DateTimeColumn get lastNotified => dateTime().nullable()();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Converter for AlertType enum
class AlertTypeConverter extends TypeConverter<AlertType, String> {
  const AlertTypeConverter();

  @override
  AlertType fromSql(String fromDb) {
    return AlertTypeExtension.fromString(fromDb);
  }

  @override
  String toSql(AlertType value) {
    return value.name;
  }
}

/// Converter for RecurrencePattern enum
class RecurrencePatternConverter extends TypeConverter<RecurrencePattern, String> {
  const RecurrencePatternConverter();

  @override
  RecurrencePattern fromSql(String fromDb) {
    return RecurrencePatternExtension.fromString(fromDb);
  }

  @override
  String toSql(RecurrencePattern value) {
    return value.name;
  }
}
