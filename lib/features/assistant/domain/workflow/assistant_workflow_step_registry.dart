import 'assistant_workflow_step_handler.dart';
import 'assistant_workflow_step_kind.dart';

/// Extensible registry of step handlers (no giant switch).
abstract class AssistantWorkflowStepRegistry {
  AssistantWorkflowStepHandler? handlerFor(AssistantWorkflowStepKind kind);
}
