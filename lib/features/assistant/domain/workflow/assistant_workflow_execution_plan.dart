import 'assistant_workflow.dart';
import 'assistant_workflow_definition.dart';
import 'assistant_workflow_id.dart';
import 'assistant_workflow_metadata.dart';
import 'assistant_workflow_step.dart';

/// Request-scoped plan produced by the planner from a [AssistantWorkflowDefinition].
class AssistantWorkflowExecutionPlan {
  const AssistantWorkflowExecutionPlan({
    required this.id,
    required this.requestId,
    required this.definitionId,
    required this.steps,
    required this.metadata,
    this.label,
  });

  final AssistantWorkflowId id;
  final String requestId;
  final String definitionId;
  final String? label;
  final List<AssistantWorkflowStep> steps;
  final AssistantWorkflowMetadata metadata;

  factory AssistantWorkflowExecutionPlan.fromDefinition({
    required AssistantWorkflowDefinition definition,
    required String requestId,
    required DateTime generatedAt,
  }) {
    final id = AssistantWorkflowId('wf-${definition.id}-$requestId');
    return AssistantWorkflowExecutionPlan(
      id: id,
      requestId: requestId,
      definitionId: definition.id,
      label: definition.label,
      steps: List.unmodifiable(definition.steps),
      metadata: AssistantWorkflowMetadata(
        workflowId: id.value,
        generatedAt: generatedAt,
        recipe: definition.id,
        stepCount: definition.steps.length,
      ),
    );
  }

  /// Compatibility bridge to the existing orchestrator/executor type.
  AssistantWorkflow toWorkflow() {
    return AssistantWorkflow(
      id: id,
      requestId: requestId,
      recipe: definitionId,
      steps: steps,
      metadata: metadata,
    );
  }

  Map<String, Object?> toDeterministicMap() => {
        'id': id.value,
        'requestId': requestId,
        'definitionId': definitionId,
        'label': label,
        'steps': steps.map((s) => s.toDeterministicMap()).toList(),
        'metadata': metadata.toDeterministicMap(),
      };
}
