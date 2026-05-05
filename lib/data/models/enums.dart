/// Enum representing different forms of medicine
enum MedicineForm {
  tablet,
  capsule,
  liquid,
  cream,
  inhaler,
  injection,
  drops,
  patch,
  other,
}

/// Extension methods for MedicineForm enum
extension MedicineFormExtension on MedicineForm {
  /// Get a human-readable display name
  String get displayName {
    switch (this) {
      case MedicineForm.tablet:
        return 'Tablet';
      case MedicineForm.capsule:
        return 'Capsule';
      case MedicineForm.liquid:
        return 'Liquid';
      case MedicineForm.cream:
        return 'Cream';
      case MedicineForm.inhaler:
        return 'Inhaler';
      case MedicineForm.injection:
        return 'Injection';
      case MedicineForm.drops:
        return 'Drops';
      case MedicineForm.patch:
        return 'Patch';
      case MedicineForm.other:
        return 'Other';
    }
  }

  /// Create from string (useful for database/API)
  static MedicineForm fromString(String value) {
    return MedicineForm.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => MedicineForm.other,
    );
  }
}

/// Type of alert
enum AlertType {
  expiry,
  lowStock,
  dose,
}

/// Extension for AlertType
extension AlertTypeExtension on AlertType {
  /// Get display label
  String get displayName {
    switch (this) {
      case AlertType.expiry:
        return 'Expiry';
      case AlertType.lowStock:
        return 'Low Stock';
      case AlertType.dose:
        return 'Dose';
    }
  }

  static AlertType fromString(String value) {
    return AlertType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => AlertType.expiry,
    );
  }
}

/// Recurrence pattern for dose reminders
enum RecurrencePattern {
  once,
  daily,
  weekly,
  monthly,
}

/// Extension for RecurrencePattern
extension RecurrencePatternExtension on RecurrencePattern {
  String get displayName {
    switch (this) {
      case RecurrencePattern.once:
        return 'Once';
      case RecurrencePattern.daily:
        return 'Daily';
      case RecurrencePattern.weekly:
        return 'Weekly';
      case RecurrencePattern.monthly:
        return 'Monthly';
    }
  }

  static RecurrencePattern fromString(String value) {
    return RecurrencePattern.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => RecurrencePattern.once,
    );
  }
}

/// Order for sorting medicine list
enum SortOrder {
  name,
  expiryDate,
}

/// Enum for medicine status filters
enum MedicineStatus {
  all,
  active,
  expiringSoon,
  expired,
  lowStock,
}

extension SortOrderExtension on SortOrder {
  String get displayName {
    switch (this) {
      case SortOrder.name:
        return 'NAME';
      case SortOrder.expiryDate:
        return 'EXPIRY';
    }
  }
}
