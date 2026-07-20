import '../../models/assistant_request.dart';
import 'assistant_workflow_context.dart';
import 'assistant_workflow_step.dart';
import 'assistant_workflow_step_result.dart';

/// Executes a single workflow step by delegating to an existing pipeline.
abstract class AssistantWorkflowStepHandler {
  Future<AssistantWorkflowStepResult> execute({
    required AssistantWorkflowStep step,
    required AssistantWorkflowContext context,
    required AssistantRequest request,
  });
}
