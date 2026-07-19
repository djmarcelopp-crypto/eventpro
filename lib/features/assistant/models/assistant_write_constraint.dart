/// A precondition that must hold before a write intent could ever be authorized.
class AssistantWriteConstraint {
  const AssistantWriteConstraint({
    required this.id,
    required this.description,
    required this.satisfied,
  });

  final String id;
  final String description;
  final bool satisfied;

  AssistantWriteConstraint copyWith({
    String? id,
    String? description,
    bool? satisfied,
  }) {
    return AssistantWriteConstraint(
      id: id ?? this.id,
      description: description ?? this.description,
      satisfied: satisfied ?? this.satisfied,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantWriteConstraint &&
            other.id == id &&
            other.description == description &&
            other.satisfied == satisfied;
  }

  @override
  int get hashCode => Object.hash(id, description, satisfied);
}
