import '../../data/models/enums.dart';

/// Domain entity representing an alert for a medicine
class Alert {
  final int? id;
  final int medicineId;
  final AlertType type;
  final DateTime triggerDate;
  final RecurrencePattern? recurrence;
  final bool isActive;
  final DateTime? lastNotified;
  final DateTime createdAt;

  const Alert({
    this.id,
    required this.medicineId,
    required this.type,
    required this.triggerDate,
    this.recurrence,
    this.isActive = true,
    this.lastNotified,
    required this.createdAt,
  });

  /// Check if alert is overdue
  bool get isOverdue {
    return isActive && DateTime.now().isAfter(triggerDate);
  }

  /// Get formatted trigger date for display
  String get formattedTriggerDate {
    return _formatDateTime(triggerDate);
  }

  /// Create a copy with updated fields
  Alert copyWith({
    int? id,
    int? medicineId,
    AlertType? type,
    DateTime? triggerDate,
    RecurrencePattern? recurrence,
    bool? isActive,
    DateTime? lastNotified,
    DateTime? createdAt,
  }) {
    return Alert(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      type: type ?? this.type,
      triggerDate: triggerDate ?? this.triggerDate,
      recurrence: recurrence ?? this.recurrence,
      isActive: isActive ?? this.isActive,
      lastNotified: lastNotified ?? this.lastNotified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Alert &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          medicineId == other.medicineId &&
          type == other.type &&
          triggerDate == other.triggerDate &&
          recurrence == other.recurrence &&
          isActive == other.isActive &&
          lastNotified == other.lastNotified &&
          createdAt == other.createdAt;

  @override
  int get hashCode {
    return id.hashCode ^
        medicineId.hashCode ^
        type.hashCode ^
        triggerDate.hashCode ^
        recurrence.hashCode ^
        isActive.hashCode ^
        lastNotified.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return 'Alert(id: $id, medicineId: $medicineId, type: $type, '
        'triggerDate: ${triggerDate.toIso8601String()}, isActive: $isActive)';
  }
}

/// Format DateTime for display
String _formatDateTime(DateTime dateTime) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final monthName = months[dateTime.month - 1];
  final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
  final period = dateTime.hour >= 12 ? 'PM' : 'AM';
  final minute = dateTime.minute.toString().padLeft(2, '0');

  return '$monthName ${dateTime.day}, ${dateTime.year} at $hour:$minute $period';
}
