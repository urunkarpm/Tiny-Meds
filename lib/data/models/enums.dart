import 'package:drift/drift.dart';

/// Enum for medicine forms
enum MedicineForm {
  liquid,
  tablet,
  capsule,
  cream,
  inhaler,
  other,
}

/// Extension to get display name for medicine form
extension MedicineFormExtension on MedicineForm {
  String get displayName {
    switch (this) {
      case MedicineForm.liquid:
        return 'Liquid';
      case MedicineForm.tablet:
        return 'Tablet';
      case MedicineForm.capsule:
        return 'Capsule';
      case MedicineForm.cream:
        return 'Cream';
      case MedicineForm.inhaler:
        return 'Inhaler';
      case MedicineForm.other:
        return 'Other';
    }
  }

  static MedicineForm fromString(String value) {
    return MedicineForm.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => MedicineForm.other,
    );
  }
}

/// Enum for alert types
enum AlertType {
  expiry,
  lowStock,
  doseReminder,
}

/// Extension to get display name for alert type
extension AlertTypeExtension on AlertType {
  String get displayName {
    switch (this) {
      case AlertType.expiry:
        return 'Expiry Alert';
      case AlertType.lowStock:
        return 'Low Stock Alert';
      case AlertType.doseReminder:
        return 'Dose Reminder';
    }
  }

  static AlertType fromString(String value) {
    return AlertType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => AlertType.expiry,
    );
  }
}

/// Enum for recurrence patterns
enum RecurrencePattern {
  none,
  daily,
  weekly,
  custom,
}

/// Extension to get display name for recurrence pattern
extension RecurrencePatternExtension on RecurrencePattern {
  String get displayName {
    switch (this) {
      case RecurrencePattern.none:
        return 'One-time';
      case RecurrencePattern.daily:
        return 'Daily';
      case RecurrencePattern.weekly:
        return 'Weekly';
      case RecurrencePattern.custom:
        return 'Custom';
    }
  }

  static RecurrencePattern fromString(String value) {
    return RecurrencePattern.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => RecurrencePattern.none,
    );
  }
}
