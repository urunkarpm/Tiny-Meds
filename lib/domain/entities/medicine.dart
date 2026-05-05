import '../../data/models/enums.dart';

/// Domain entity representing a medicine in the home inventory
class Medicine {
  final int? id;
  final int? profileId;
  final String name;
  final String? brand;
  final MedicineForm form;
  final String? strength;
  final int quantity;
  final String unit;
  final DateTime expiryDate;
  final DateTime? openedDate;
  final String? location;
  final int? lowStockThreshold;
  final int? frequency;
  final double? doseAmount;
  final bool needsRefill;
  final bool isDisposed;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Medicine({
    this.id,
    this.profileId,
    required this.name,
    this.brand,
    required this.form,
    this.strength,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    this.openedDate,
    this.location,
    this.lowStockThreshold,
    this.frequency,
    this.doseAmount,
    this.needsRefill = false,
    this.isDisposed = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate days until expiry
  int get daysUntilExpiry {
    final now = DateTime.now();
    final difference = expiryDate.difference(now);
    return difference.inDays;
  }

  /// Check if medicine is expired
  bool get isExpired => daysUntilExpiry < 0;

  /// Check if medicine is expiring soon (within 7 days)
  bool get isExpiringSoon => daysUntilExpiry >= 0 && daysUntilExpiry <= 7;

  /// Check if medicine is low stock
  bool get isLowStock {
    if (lowStockThreshold == null) return false;
    return quantity <= lowStockThreshold!;
  }

  /// Get expiry status label
  String get expiryStatusLabel {
    if (isExpired) return 'Expired';
    if (daysUntilExpiry == 0) return 'Expires Today';
    if (isExpiringSoon) return 'Expiring Soon';
    if (daysUntilExpiry <= 30) return 'Expiring Within 30 Days';
    return 'Active';
  }

  /// Get status pill kind for StatusPill widget
  String get statusPillKind {
    if (isExpired) return 'expired';
    if (daysUntilExpiry == 0) return 'today';
    if (isExpiringSoon) return 'soon';
    if (isLowStock) return 'low';
    if (daysUntilExpiry <= 30) return 'month';
    return 'active';
  }

  /// Get status pill label for StatusPill widget
  String get statusPillLabel {
    if (isExpired) {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return 'Expired ${months[expiryDate.month - 1]} ${expiryDate.day}';
    }
    if (daysUntilExpiry == 0) return 'Expires today';
    if (isExpiringSoon) return 'Expires in $daysUntilExpiry days';
    if (isLowStock) return 'Low stock';
    if (daysUntilExpiry <= 30) return 'Expires in $daysUntilExpiry days';
    return 'Active';
  }

  /// Get a consistent hue for this medicine (form-based with name variation)
  double get medHue {
    int hash = 0;
    for (final char in name.runes) {
      hash = ((hash * 31) + char) & 0xFFFFFF;
    }
    double base;
    switch (form) {
      case MedicineForm.capsule:
        base = 200;
        break;
      case MedicineForm.tablet:
        base = 35;
        break;
      case MedicineForm.liquid:
        base = 320;
        break;
      case MedicineForm.cream:
        base = 15;
        break;
      case MedicineForm.inhaler:
        base = 180;
        break;
      default:
        base = 260;
        break;
    }
    return ((base + (hash % 60) - 30) % 360 + 360) % 360;
  }

  /// Create a copy with updated fields
  Medicine copyWith({
    int? id,
    int? profileId,
    String? name,
    String? brand,
    MedicineForm? form,
    String? strength,
    int? quantity,
    String? unit,
    DateTime? expiryDate,
    DateTime? openedDate,
    String? location,
    int? lowStockThreshold,
    int? frequency,
    double? doseAmount,
    bool? needsRefill,
    bool? isDisposed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medicine(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      form: form ?? this.form,
      strength: strength ?? this.strength,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      openedDate: openedDate ?? this.openedDate,
      location: location ?? this.location,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      frequency: frequency ?? this.frequency,
      doseAmount: doseAmount ?? this.doseAmount,
      needsRefill: needsRefill ?? this.needsRefill,
      isDisposed: isDisposed ?? this.isDisposed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Medicine &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          profileId == other.profileId &&
          name == other.name &&
          brand == other.brand &&
          form == other.form &&
          strength == other.strength &&
          quantity == other.quantity &&
          unit == other.unit &&
          expiryDate == other.expiryDate &&
          openedDate == other.openedDate &&
          location == other.location &&
          lowStockThreshold == other.lowStockThreshold &&
          frequency == other.frequency &&
          doseAmount == other.doseAmount &&
          needsRefill == other.needsRefill &&
          isDisposed == other.isDisposed &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode {
    return id.hashCode ^
        profileId.hashCode ^
        name.hashCode ^
        brand.hashCode ^
        form.hashCode ^
        strength.hashCode ^
        quantity.hashCode ^
        unit.hashCode ^
        expiryDate.hashCode ^
        openedDate.hashCode ^
        location.hashCode ^
        lowStockThreshold.hashCode ^
        frequency.hashCode ^
        doseAmount.hashCode ^
        needsRefill.hashCode ^
        isDisposed.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'Medicine(id: $id, name: $name, brand: $brand, form: $form, '
        'quantity: $quantity $unit, expires: ${expiryDate.toIso8601String().split('T')[0]})';
  }
}
