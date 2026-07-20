import 'assistant_workflow_step.dart';
import 'assistant_workflow_warning.dart';

/// Result of a single workflow step execution.
class AssistantWorkflowStepResult {
  const AssistantWorkflowStepResult({
    required this.step,
    required this.success,
    this.interrupt = false,
    this.outputs = const {},
    this.message,
    this.warnings = const [],
  });

  final AssistantWorkflowStep step;
  final bool success;
  final bool interrupt;
  final Map<String, Object?> outputs;
  final String? message;
  final List<AssistantWorkflowWarning> warnings;

  Map<String, Object?> toDeterministicMap() => {
        'step': step.toDeterministicMap(),
        'success': success,
        'interrupt': interrupt,
        'outputs': outputs,
        'message': message,
        'warnings': warnings.map((w) => w.toDeterministicMap()).toList(),
      };
}

/// Backward-compatible alias used by existing handlers/tests.
typedef AssistantWorkflowStepOutcome = AssistantWorkflowStepResult;
