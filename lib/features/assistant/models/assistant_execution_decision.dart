/// Explicit planning decision recorded for auditability.
class AssistantExecutionDecision {
  const AssistantExecutionDecision({
    required this.id,
    required this.description,
    this.rationale = '',
  });

  final String id;
  final String description;
  final String rationale;

  AssistantExecutionDecision copyWith({
    String? id,
    String? description,
    String? rationale,
  }) {
    return AssistantExecutionDecision(
      id: id ?? this.id,
      description: description ?? this.description,
      rationale: rationale ?? this.rationale,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionDecision &&
            other.id == id &&
            other.description == description &&
            other.rationale == rationale;
  }

  @override
  int get hashCode => Object.hash(id, description, rationale);
}
