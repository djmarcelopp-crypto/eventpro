/// Documented risk of a planned step (explainability only).
class AssistantExecutionRisk {
  const AssistantExecutionRisk({
    required this.id,
    required this.description,
    this.severity = 'medium',
  });

  final String id;
  final String description;

  /// Free-form severity label (`low`, `medium`, `high`).
  final String severity;

  AssistantExecutionRisk copyWith({
    String? id,
    String? description,
    String? severity,
  }) {
    return AssistantExecutionRisk(
      id: id ?? this.id,
      description: description ?? this.description,
      severity: severity ?? this.severity,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionRisk &&
            other.id == id &&
            other.description == description &&
            other.severity == severity;
  }

  @override
  int get hashCode => Object.hash(id, description, severity);
}
