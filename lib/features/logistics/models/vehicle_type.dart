/// A vehicle type used to classify [Vehicle] records (e.g. "Van", "Truck").
///
/// Immutable domain entity. Persistence, providers and UI are intentionally
/// out of scope for the domain foundation checkpoint.
class VehicleType {
  const VehicleType({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.active = true,
  });

  final String id;
  final String name;
  final String? description;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  VehicleType copyWith({
    String? id,
    String? name,
    String? description,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearDescription = false,
  }) {
    return VehicleType(
      id: id ?? this.id,
      name: name ?? this.name,
      description:
          clearDescription ? null : (description ?? this.description),
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is VehicleType &&
            other.id == id &&
            other.name == name &&
            other.description == description &&
            other.active == active &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, active, createdAt, updatedAt);
}
