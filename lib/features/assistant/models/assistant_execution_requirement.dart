/// A precondition that must hold before a step can become ready.
class AssistantExecutionRequirement {
  const AssistantExecutionRequirement({
    required this.id,
    required this.description,
    required this.satisfied,
  });

  final String id;
  final String description;
  final bool satisfied;

  AssistantExecutionRequirement copyWith({
    String? id,
    String? description,
    bool? satisfied,
  }) {
    return AssistantExecutionRequirement(
      id: id ?? this.id,
      description: description ?? this.description,
      satisfied: satisfied ?? this.satisfied,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionRequirement &&
            other.id == id &&
            other.description == description &&
            other.satisfied == satisfied;
  }

  @override
  int get hashCode => Object.hash(id, description, satisfied);
}
