import '../domain/workflow/assistant_workflow_result.dart';

/// NL + structured presentation of a workflow turn.
class AssistantWorkflowPresentation {
  const AssistantWorkflowPresentation({
    required this.naturalLanguage,
    required this.structured,
    this.warnings = const [],
  });

  final String naturalLanguage;
  final Map<String, Object?> structured;
  final List<String> warnings;

  factory AssistantWorkflowPresentation.fromResult(
    AssistantWorkflowResult result, {
    required String naturalLanguage,
  }) {
    return AssistantWorkflowPresentation(
      naturalLanguage: naturalLanguage,
      structured: result.toDeterministicMap(),
      warnings: result.warnings.map((w) => w.message).toList(growable: false),
    );
  }
}
