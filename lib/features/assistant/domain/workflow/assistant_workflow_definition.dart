import 'assistant_workflow_step.dart';

/// Declarative, reusable workflow recipe (no request-specific ids).
class AssistantWorkflowDefinition {
  const AssistantWorkflowDefinition({
    required this.id,
    required this.steps,
    this.label,
  });

  /// Stable definition id (typically matches recipe name).
  final String id;
  final String? label;
  final List<AssistantWorkflowStep> steps;

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'label': label,
        'steps': steps.map((s) => s.toDeterministicMap()).toList(),
      };
}
