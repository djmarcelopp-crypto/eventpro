import '../domain/workflow/assistant_workflow.dart';
import '../domain/workflow/assistant_workflow_definition_registry.dart';
import '../domain/workflow/assistant_workflow_execution_plan.dart';
import '../domain/workflow/assistant_workflow_planner.dart';
import '../models/assistant_request.dart';
import '../models/assistant_workflow_intent.dart';
import 'local_assistant_workflow_definition_registry.dart';

/// Deterministic planner — resolves intent → definition → execution plan.
///
/// Concrete recipes live in [AssistantWorkflowDefinitionRegistry], not here.
class LocalAssistantWorkflowPlanner implements AssistantWorkflowPlanner {
  LocalAssistantWorkflowPlanner({
    DateTime Function()? clock,
    AssistantWorkflowDefinitionRegistry? definitionRegistry,
  })  : _clock = clock ?? DateTime.now,
        _definitions = definitionRegistry ??
            LocalAssistantWorkflowDefinitionRegistry.defaults();

  final DateTime Function() _clock;
  final AssistantWorkflowDefinitionRegistry _definitions;

  AssistantWorkflowDefinitionRegistry get definitionRegistry => _definitions;

  @override
  AssistantWorkflow? plan(
    AssistantWorkflowIntent intent, {
    required String requestId,
    required AssistantRequest request,
  }) {
    final plan = planExecution(
      intent,
      requestId: requestId,
      request: request,
    );
    return plan?.toWorkflow();
  }

  /// Preferred API — returns the formal execution plan.
  AssistantWorkflowExecutionPlan? planExecution(
    AssistantWorkflowIntent intent, {
    required String requestId,
    required AssistantRequest request,
  }) {
    if (intent is! RunWorkflowIntent) return null;

    final definition = _definitions.find(intent.recipe.name);
    if (definition == null || definition.steps.isEmpty) return null;

    return AssistantWorkflowExecutionPlan.fromDefinition(
      definition: definition,
      requestId: requestId,
      generatedAt: _clock().toUtc(),
    );
  }
}
