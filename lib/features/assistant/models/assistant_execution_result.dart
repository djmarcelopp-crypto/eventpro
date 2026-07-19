import 'assistant_execution_outcome.dart';

/// Per-step dry-run/simulation result — never a persisted ERP mutation.
class AssistantExecutionResult {
  const AssistantExecutionResult({
    required this.stepId,
    required this.outcome,
    required this.message,
  });

  final String stepId;
  final AssistantExecutionOutcome outcome;
  final String message;

  AssistantExecutionResult copyWith({
    String? stepId,
    AssistantExecutionOutcome? outcome,
    String? message,
  }) {
    return AssistantExecutionResult(
      stepId: stepId ?? this.stepId,
      outcome: outcome ?? this.outcome,
      message: message ?? this.message,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionResult &&
            other.stepId == stepId &&
            other.outcome == outcome &&
            other.message == message;
  }

  @override
  int get hashCode => Object.hash(stepId, outcome, message);
}
