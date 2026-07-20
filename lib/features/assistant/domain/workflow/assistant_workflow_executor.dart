import '../../models/assistant_request.dart';
import 'assistant_workflow.dart';
import 'assistant_workflow_context.dart';
import 'assistant_workflow_result.dart';

/// Runs workflow steps in order via the step registry.
abstract class AssistantWorkflowExecutor {
  Future<AssistantWorkflowResult> execute({
    required AssistantWorkflow workflow,
    required AssistantRequest request,
    AssistantWorkflowContext initialContext,
  });
}
