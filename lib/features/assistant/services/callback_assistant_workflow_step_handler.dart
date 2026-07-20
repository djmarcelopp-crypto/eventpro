import '../domain/workflow/assistant_workflow_context.dart';
import '../domain/workflow/assistant_workflow_step.dart';
import '../domain/workflow/assistant_workflow_step_handler.dart';
import '../domain/workflow/assistant_workflow_step_result.dart';
import '../models/assistant_request.dart';

/// Thin adapter — delegates to an injected pipeline callback (no business rules).
class CallbackAssistantWorkflowStepHandler
    implements AssistantWorkflowStepHandler {
  CallbackAssistantWorkflowStepHandler(this._callback);

  final Future<AssistantWorkflowStepResult> Function({
    required AssistantWorkflowStep step,
    required AssistantWorkflowContext context,
    required AssistantRequest request,
  }) _callback;

  @override
  Future<AssistantWorkflowStepResult> execute({
    required AssistantWorkflowStep step,
    required AssistantWorkflowContext context,
    required AssistantRequest request,
  }) =>
      _callback(step: step, context: context, request: request);
}
