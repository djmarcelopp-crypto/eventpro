import '../business/capabilities/assistant_business_capability_resolution.dart';
import '../business/capabilities/capability_execution_node.dart';
import '../business/commands/assistant_business_command_resolution.dart';
import '../business/commands/command_execution_node.dart';
import 'assistant_workflow_id.dart';
import 'assistant_workflow_metadata.dart';
import 'assistant_workflow_step.dart';

/// Immutable ordered plan of reusable pipeline steps.
///
/// AR-002: may carry planner metadata (commands/capabilities) without executing
/// those nodes — prevents information loss from ExecutionPlan → Workflow.
class AssistantWorkflow {
  const AssistantWorkflow({
    required this.id,
    required this.requestId,
    required this.steps,
    required this.metadata,
    this.recipe,
    this.resolvedCapabilities = const [],
    this.capabilityExecutionNodes = const [],
    this.resolvedCommands = const [],
    this.commandExecutionNodes = const [],
  });

  final AssistantWorkflowId id;
  final String requestId;
  final List<AssistantWorkflowStep> steps;
  final AssistantWorkflowMetadata metadata;
  final String? recipe;

  /// Planner metadata (AI-018) — available during execution, not executed here.
  final List<AssistantBusinessCapabilityResolution> resolvedCapabilities;
  final List<CapabilityExecutionNode> capabilityExecutionNodes;

  /// Planner metadata (AI-019) — available during execution, not executed here.
  final List<AssistantBusinessCommandResolution> resolvedCommands;
  final List<CommandExecutionNode> commandExecutionNodes;

  Map<String, Object?> toDeterministicMap() => {
        'id': id.value,
        'requestId': requestId,
        'recipe': recipe,
        'steps': steps.map((s) => s.toDeterministicMap()).toList(),
        'metadata': metadata.toDeterministicMap(),
        'resolvedCapabilities':
            resolvedCapabilities.map((r) => r.toDeterministicMap()).toList(),
        'capabilityExecutionNodes': capabilityExecutionNodes
            .map((n) => n.toDeterministicMap())
            .toList(),
        'resolvedCommands':
            resolvedCommands.map((r) => r.toDeterministicMap()).toList(),
        'commandExecutionNodes':
            commandExecutionNodes.map((n) => n.toDeterministicMap()).toList(),
      };
}
