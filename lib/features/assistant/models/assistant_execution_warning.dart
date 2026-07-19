/// Non-blocking warning attached to a plan or step.
class AssistantExecutionWarning {
  const AssistantExecutionWarning({
    required this.id,
    required this.message,
    this.stepId,
  });

  final String id;
  final String message;
  final String? stepId;

  AssistantExecutionWarning copyWith({
    String? id,
    String? message,
    String? stepId,
    bool clearStepId = false,
  }) {
    return AssistantExecutionWarning(
      id: id ?? this.id,
      message: message ?? this.message,
      stepId: clearStepId ? null : (stepId ?? this.stepId),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionWarning &&
            other.id == id &&
            other.message == message &&
            other.stepId == stepId;
  }

  @override
  int get hashCode => Object.hash(id, message, stepId);
}
