/// A role used to classify [TeamMember] records (e.g. "DJ", "Sonoplasta").
///
/// Immutable domain entity.
class TeamRole {
  const TeamRole({
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

  TeamRole copyWith({
    String? id,
    String? name,
    String? description,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearDescription = false,
  }) {
    return TeamRole(
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
        other is TeamRole &&
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
