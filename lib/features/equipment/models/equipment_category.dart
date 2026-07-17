/// A category used to classify [Equipment] records (e.g. "Som", "Iluminação").
class EquipmentCategory {
  const EquipmentCategory({
    required this.id,
    required this.name,
    this.description,
    this.active = true,
  });

  final String id;
  final String name;
  final String? description;
  final bool active;

  EquipmentCategory copyWith({
    String? id,
    String? name,
    String? description,
    bool? active,
    bool clearDescription = false,
  }) {
    return EquipmentCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description:
          clearDescription ? null : (description ?? this.description),
      active: active ?? this.active,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EquipmentCategory &&
            other.id == id &&
            other.name == name &&
            other.description == description &&
            other.active == active;
  }

  @override
  int get hashCode => Object.hash(id, name, description, active);
}
