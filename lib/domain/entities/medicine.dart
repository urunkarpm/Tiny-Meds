import '../../data/models/enums.dart';

/// Domain entity representing a medicine in the home inventory
class Medicine {
  final int? id;
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
  final bool isDisposed;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Medicine({
    this.id,
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
    if (isExpired) {
      return 'Expired';
    } else if (daysUntilExpiry == 0) {
      return 'Expires Today';
    } else if (isExpiringSoon) {
      return 'Expiring Soon';
    } else if (daysUntilExpiry <= 30) {
      return 'Expiring Within 30 Days';
    } else {
      return 'Active';
    }
  }

  /// Create a copy with updated fields
  Medicine copyWith({
    int? id,
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
    bool? isDisposed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medicine(
      id: id ?? this.id,
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
          isDisposed == other.isDisposed &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode {
    return id.hashCode ^
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
