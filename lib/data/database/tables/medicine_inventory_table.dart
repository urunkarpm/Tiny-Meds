import 'package:drift/drift.dart';
import '../../models/enums.dart';
import 'profiles_table.dart';

/// Drift table for storing medicine inventory items
class MedicineInventory extends Table {
  /// Primary key, auto-increment
  IntColumn get id => integer().autoIncrement()();

  /// Medicine name (required)
  TextColumn get name => text().withLength(min: 1, max: 200)();

  /// Brand name (optional)
  TextColumn get brand => text().withLength(min: 1, max: 200).nullable()();

  /// Medicine form: liquid, tablet, cream, inhaler, other (required)
  TextColumn get form => text().map(const MedicineFormConverter())();

  /// Strength (optional, e.g., "500mg", "10%")
  TextColumn get strength => text().withLength(min: 1, max: 100).nullable()();

  /// Quantity available (required)
  IntColumn get quantity => integer()();

  /// Unit of measurement (required, e.g., mL, mg, tablets)
  TextColumn get unit => text().withLength(min: 1, max: 50)();

  /// Expiry date (required)
  DateTimeColumn get expiryDate => dateTime()();

  /// Date when the item was opened (optional, for post-open shelf life)
  DateTimeColumn get openedDate => dateTime().nullable()();

  /// Storage location (optional, e.g., "Bathroom cabinet", "Diaper bag")
  TextColumn get location => text().withLength(min: 1, max: 200).nullable()();

  /// Low stock threshold for alerts (optional)
  IntColumn get lowStockThreshold => integer().nullable()();

  /// How many times per day to take this medicine
  IntColumn get frequency => integer().nullable()();

  /// Amount per dose
  RealColumn get doseAmount => real().nullable()();

  /// Profile association (required for organization)
  IntColumn get profileId => integer().nullable().references(Profiles, #id)();

  /// Whether the item needs a refill (shopping list)
  BoolColumn get needsRefill => boolean().withDefault(const Constant(false))();

  /// Whether the item has been disposed
  BoolColumn get isDisposed => boolean().withDefault(const Constant(false))();

  /// AI generated summary of the medicine
  TextColumn get summary => text().nullable()();

  /// AI generated chemical composition of the medicine
  TextColumn get chemicalComposition => text().nullable()();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Last update timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Converter for MedicineForm enum
class MedicineFormConverter extends TypeConverter<MedicineForm, String> {
  const MedicineFormConverter();

  @override
  MedicineForm fromSql(String fromDb) {
    return MedicineFormExtension.fromString(fromDb);
  }

  @override
  String toSql(MedicineForm value) {
    return value.name;
  }
}
