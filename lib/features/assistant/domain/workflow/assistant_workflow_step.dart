import 'assistant_workflow_step_kind.dart';

/// One planned step in a workflow (immutable).
class AssistantWorkflowStep {
  const AssistantWorkflowStep({
    required this.id,
    required this.kind,
    this.label,
    this.params = const {},
    this.required = true,
  });

  final String id;
  final AssistantWorkflowStepKind kind;
  final String? label;

  /// Opaque string params for the step handler (no ERP entities).
  final Map<String, String> params;

  /// When true, failure interrupts the workflow.
  final bool required;

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'kind': kind.name,
        'label': label,
        'params': params,
        'required': required,
      };
}
