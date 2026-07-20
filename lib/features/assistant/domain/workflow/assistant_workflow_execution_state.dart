import 'assistant_workflow_context.dart';
import 'assistant_workflow_step_result.dart';
import 'assistant_workflow_warning.dart';

/// Immutable snapshot of in-flight workflow execution.
class AssistantWorkflowExecutionState {
  const AssistantWorkflowExecutionState({
    this.context = const AssistantWorkflowContext(),
    this.stepResults = const [],
    this.warnings = const [],
    this.interrupted = false,
  });

  final AssistantWorkflowContext context;
  final List<AssistantWorkflowStepResult> stepResults;
  final List<AssistantWorkflowWarning> warnings;
  final bool interrupted;

  int get completedStepCount =>
      stepResults.where((r) => r.success).length;

  AssistantWorkflowExecutionState appendResult(
    AssistantWorkflowStepResult result,
  ) {
    return AssistantWorkflowExecutionState(
      context: result.outputs.isEmpty
          ? context
          : context.putAll(result.outputs),
      stepResults: List.unmodifiable([...stepResults, result]),
      warnings: result.warnings.isEmpty
          ? warnings
          : List.unmodifiable([...warnings, ...result.warnings]),
      interrupted: interrupted,
    );
  }

  AssistantWorkflowExecutionState withWarning(AssistantWorkflowWarning warning) {
    return AssistantWorkflowExecutionState(
      context: context,
      stepResults: stepResults,
      warnings: List.unmodifiable([...warnings, warning]),
      interrupted: interrupted,
    );
  }

  AssistantWorkflowExecutionState markInterrupted() {
    return AssistantWorkflowExecutionState(
      context: context,
      stepResults: stepResults,
      warnings: warnings,
      interrupted: true,
    );
  }

  Map<String, Object?> toDeterministicMap() => {
        'interrupted': interrupted,
        'completedStepCount': completedStepCount,
        'context': context.toDeterministicMap(),
        'stepResults':
            stepResults.map((r) => r.toDeterministicMap()).toList(),
        'warnings': warnings.map((w) => w.toDeterministicMap()).toList(),
      };
}
