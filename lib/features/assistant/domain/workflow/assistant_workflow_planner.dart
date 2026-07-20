import '../../models/assistant_request.dart';
import '../../models/assistant_workflow_intent.dart';
import 'assistant_workflow.dart';

/// Plans a workflow from a resolved intent — never executes.
abstract class AssistantWorkflowPlanner {
  AssistantWorkflow? plan(
    AssistantWorkflowIntent intent, {
    required String requestId,
    required AssistantRequest request,
  });
}
