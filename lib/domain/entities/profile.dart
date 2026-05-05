/// Domain entity representing a person's profile for organizing medicine and alerts
class Profile {
  final int? id;
  final String name;
  final int colorValue; // ARGB color value for the profile's avatar/theme
  final DateTime createdAt;

  const Profile({
    this.id,
    required this.name,
    required this.colorValue,
    required this.createdAt,
  });

  /// Create a copy with updated fields
  Profile copyWith({
    int? id,
    String? name,
    int? colorValue,
    DateTime? createdAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          colorValue == other.colorValue &&
          createdAt == other.createdAt;

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        colorValue.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return 'Profile(id: $id, name: $name)';
  }
}
