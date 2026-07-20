import 'assistant_workflow_definition.dart';

/// Lookup of workflow definitions by id — keeps recipes out of the planner.
abstract class AssistantWorkflowDefinitionRegistry {
  AssistantWorkflowDefinition? find(String id);

  Iterable<AssistantWorkflowDefinition> get definitions;

  bool contains(String id) => find(id) != null;
}
