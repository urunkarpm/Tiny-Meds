import 'package:drift/drift.dart';

/// Drift table for storing user profiles
@DataClassName('ProfileData')
class Profiles extends Table {
  /// Primary key, auto-increment
  IntColumn get id => integer().autoIncrement()();

  /// Profile name (e.g., "Son", "Mother")
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Color value for UI representation (ARGB)
  IntColumn get colorValue => integer()();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
