/// A role used to classify [TeamMember] records (e.g. "DJ", "Sonoplasta").
///
/// Immutable domain entity. Persistence, providers and UI are intentionally
/// out of scope for the domain foundation checkpoint.
class TeamRole {
  const TeamRole({
    required this.id,
    required this.name,
    this.description,
    this.active = true,
  });

  final String id;
  final String name;
  final String? description;
  final bool active;

  TeamRole copyWith({
    String? id,
    String? name,
    String? description,
    bool? active,
    bool clearDescription = false,
  }) {
    return TeamRole(
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
        other is TeamRole &&
            other.id == id &&
            other.name == name &&
            other.description == description &&
            other.active == active;
  }

  @override
  int get hashCode => Object.hash(id, name, description, active);
}
