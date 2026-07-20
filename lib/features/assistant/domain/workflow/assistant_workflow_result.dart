import 'assistant_workflow_context.dart';
import 'assistant_workflow_metadata.dart';
import 'assistant_workflow_step_result.dart';
import 'assistant_workflow_warning.dart';

export 'assistant_workflow_step_result.dart'
    show AssistantWorkflowStepResult, AssistantWorkflowStepOutcome;

/// Aggregate result of a workflow run.
class AssistantWorkflowResult {
  const AssistantWorkflowResult({
    required this.requestId,
    required this.workflowId,
    required this.context,
    required this.stepOutcomes,
    required this.metadata,
    this.warnings = const [],
    this.summary,
    this.valid = true,
    this.completed = false,
    this.interrupted = false,
  });

  final String requestId;
  final String workflowId;
  final AssistantWorkflowContext context;

  /// Step results (alias: stepResults).
  final List<AssistantWorkflowStepResult> stepOutcomes;
  final AssistantWorkflowMetadata metadata;
  final List<AssistantWorkflowWarning> warnings;
  final String? summary;
  final bool valid;
  final bool completed;
  final bool interrupted;

  List<AssistantWorkflowStepResult> get stepResults => stepOutcomes;

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'workflowId': workflowId,
        'valid': valid,
        'completed': completed,
        'interrupted': interrupted,
        'summary': summary,
        'context': context.toDeterministicMap(),
        'stepOutcomes':
            stepOutcomes.map((o) => o.toDeterministicMap()).toList(),
        'metadata': metadata.toDeterministicMap(),
        'warnings': warnings.map((w) => w.toDeterministicMap()).toList(),
      };
}
