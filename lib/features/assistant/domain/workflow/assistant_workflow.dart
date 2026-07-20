import 'assistant_workflow_id.dart';
import 'assistant_workflow_metadata.dart';
import 'assistant_workflow_step.dart';

/// Immutable ordered plan of reusable pipeline steps.
class AssistantWorkflow {
  const AssistantWorkflow({
    required this.id,
    required this.requestId,
    required this.steps,
    required this.metadata,
    this.recipe,
  });

  final AssistantWorkflowId id;
  final String requestId;
  final List<AssistantWorkflowStep> steps;
  final AssistantWorkflowMetadata metadata;
  final String? recipe;

  Map<String, Object?> toDeterministicMap() => {
        'id': id.value,
        'requestId': requestId,
        'recipe': recipe,
        'steps': steps.map((s) => s.toDeterministicMap()).toList(),
        'metadata': metadata.toDeterministicMap(),
      };
}
