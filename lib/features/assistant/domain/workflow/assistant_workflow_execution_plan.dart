import 'assistant_workflow.dart';
import 'assistant_workflow_definition.dart';
import 'assistant_workflow_id.dart';
import 'assistant_workflow_metadata.dart';
import 'assistant_workflow_step.dart';
import '../business/capabilities/assistant_business_capability_resolution.dart';
import '../business/capabilities/capability_execution_node.dart';
import '../business/commands/assistant_business_command_resolution.dart';
import '../business/commands/command_execution_node.dart';

/// Request-scoped plan produced by the planner from a [AssistantWorkflowDefinition].
class AssistantWorkflowExecutionPlan {
  const AssistantWorkflowExecutionPlan({
    required this.id,
    required this.requestId,
    required this.definitionId,
    required this.steps,
    required this.metadata,
    this.label,
    this.resolvedCapabilities = const [],
    this.executionNodes = const [],
    this.resolvedCommands = const [],
    this.commandExecutionNodes = const [],
  });

  final AssistantWorkflowId id;
  final String requestId;
  final String definitionId;
  final String? label;
  final List<AssistantWorkflowStep> steps;
  final AssistantWorkflowMetadata metadata;

  /// Capabilities validated for business steps (AI-018) — empty for non-business recipes.
  final List<AssistantBusinessCapabilityResolution> resolvedCapabilities;

  /// Ordered capability execution graph for business steps (AI-018).
  final List<CapabilityExecutionNode> executionNodes;

  /// Commands validated for business steps (AI-019) — empty for non-business recipes.
  final List<AssistantBusinessCommandResolution> resolvedCommands;

  /// Ordered command execution graph for business steps (AI-019).
  final List<CommandExecutionNode> commandExecutionNodes;

  bool get capabilitiesReady =>
      executionNodes.isEmpty || executionNodes.every((n) => n.ready);

  bool get commandsReady =>
      commandExecutionNodes.isEmpty ||
      commandExecutionNodes.every((n) => n.ready);

  factory AssistantWorkflowExecutionPlan.fromDefinition({
    required AssistantWorkflowDefinition definition,
    required String requestId,
    required DateTime generatedAt,
    List<AssistantBusinessCapabilityResolution> resolvedCapabilities =
        const [],
    List<CapabilityExecutionNode> executionNodes = const [],
    List<AssistantBusinessCommandResolution> resolvedCommands = const [],
    List<CommandExecutionNode> commandExecutionNodes = const [],
  }) {
    final id = AssistantWorkflowId('wf-${definition.id}-$requestId');
    return AssistantWorkflowExecutionPlan(
      id: id,
      requestId: requestId,
      definitionId: definition.id,
      label: definition.label,
      steps: List.unmodifiable(definition.steps),
      resolvedCapabilities: List.unmodifiable(resolvedCapabilities),
      executionNodes: List.unmodifiable(executionNodes),
      resolvedCommands: List.unmodifiable(resolvedCommands),
      commandExecutionNodes: List.unmodifiable(commandExecutionNodes),
      metadata: AssistantWorkflowMetadata(
        workflowId: id.value,
        generatedAt: generatedAt,
        recipe: definition.id,
        stepCount: definition.steps.length,
      ),
    );
  }

  /// Compatibility bridge to the existing orchestrator/executor type.
  ///
  /// AR-002: preserves Command/Capability planner metadata on the workflow so
  /// execution can observe them without running the nodes.
  AssistantWorkflow toWorkflow() {
    return AssistantWorkflow(
      id: id,
      requestId: requestId,
      recipe: definitionId,
      steps: steps,
      metadata: metadata,
      resolvedCapabilities: resolvedCapabilities,
      capabilityExecutionNodes: executionNodes,
      resolvedCommands: resolvedCommands,
      commandExecutionNodes: commandExecutionNodes,
    );
  }

  Map<String, Object?> toDeterministicMap() => {
        'id': id.value,
        'requestId': requestId,
        'definitionId': definitionId,
        'label': label,
        'steps': steps.map((s) => s.toDeterministicMap()).toList(),
        'metadata': metadata.toDeterministicMap(),
        'resolvedCapabilities':
            resolvedCapabilities.map((r) => r.toDeterministicMap()).toList(),
        'executionNodes':
            executionNodes.map((n) => n.toDeterministicMap()).toList(),
        'resolvedCommands':
            resolvedCommands.map((r) => r.toDeterministicMap()).toList(),
        'commandExecutionNodes':
            commandExecutionNodes.map((n) => n.toDeterministicMap()).toList(),
      };
}
