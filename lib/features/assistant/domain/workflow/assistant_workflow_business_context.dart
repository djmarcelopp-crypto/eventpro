import '../business/assistant_business_reference.dart';
import '../business/assistant_business_result.dart';
import '../business/capabilities/assistant_business_capability_resolution.dart';
import '../business/capabilities/capability_execution_node.dart';
import '../business/commands/assistant_business_command_resolution.dart';
import '../business/commands/command_execution_node.dart';
import 'assistant_workflow_context.dart';

/// Stable context keys for business references (AI-017), capabilities (AI-018)
/// and commands (AI-019).
abstract final class AssistantWorkflowBusinessKeys {
  static const clientReference = 'clientReference';
  static const quoteReference = 'quoteReference';
  static const eventReference = 'eventReference';
  static const contractReference = 'contractReference';
  static const businessResult = 'businessResult';

  static const resolvedCapabilities = 'resolvedCapabilities';
  static const producedEntities = 'producedEntities';
  static const satisfiedDependencies = 'satisfiedDependencies';
  static const sharedOutputs = 'sharedOutputs';

  static const resolvedCommands = 'resolvedCommands';
  static const commandExecutionNodes = 'commandExecutionNodes';
  static const capabilityExecutionNodes = 'capabilityExecutionNodes';
}

/// Typed accessors for business references on [AssistantWorkflowContext].
extension AssistantWorkflowBusinessContext on AssistantWorkflowContext {
  ClientReference? get clientReference {
    final v = this[AssistantWorkflowBusinessKeys.clientReference];
    return v is ClientReference ? v : null;
  }

  QuoteReference? get quoteReference {
    final v = this[AssistantWorkflowBusinessKeys.quoteReference];
    return v is QuoteReference ? v : null;
  }

  EventReference? get eventReference {
    final v = this[AssistantWorkflowBusinessKeys.eventReference];
    return v is EventReference ? v : null;
  }

  ContractReference? get contractReference {
    final v = this[AssistantWorkflowBusinessKeys.contractReference];
    return v is ContractReference ? v : null;
  }

  AssistantBusinessResult? get businessResult {
    final v = this[AssistantWorkflowBusinessKeys.businessResult];
    return v is AssistantBusinessResult ? v : null;
  }

  List<AssistantBusinessCapabilityResolution> get resolvedCapabilities {
    final v = this[AssistantWorkflowBusinessKeys.resolvedCapabilities];
    if (v is List<AssistantBusinessCapabilityResolution>) return v;
    if (v is List) {
      return v.whereType<AssistantBusinessCapabilityResolution>().toList();
    }
    return const [];
  }

  List<AssistantBusinessReference> get producedEntities {
    final v = this[AssistantWorkflowBusinessKeys.producedEntities];
    if (v is List<AssistantBusinessReference>) return v;
    if (v is List) return v.whereType<AssistantBusinessReference>().toList();
    return const [];
  }

  Set<String> get satisfiedDependencies {
    final v = this[AssistantWorkflowBusinessKeys.satisfiedDependencies];
    if (v is Set<String>) return v;
    if (v is List) return v.whereType<String>().toSet();
    return const {};
  }

  Map<String, Object?> get sharedOutputs {
    final v = this[AssistantWorkflowBusinessKeys.sharedOutputs];
    if (v is Map<String, Object?>) return v;
    if (v is Map) return Map<String, Object?>.from(v);
    return const {};
  }

  List<AssistantBusinessCommandResolution> get resolvedCommands {
    final v = this[AssistantWorkflowBusinessKeys.resolvedCommands];
    if (v is List<AssistantBusinessCommandResolution>) return v;
    if (v is List) {
      return v.whereType<AssistantBusinessCommandResolution>().toList();
    }
    return const [];
  }

  List<CommandExecutionNode> get commandExecutionNodes {
    final v = this[AssistantWorkflowBusinessKeys.commandExecutionNodes];
    if (v is List<CommandExecutionNode>) return v;
    if (v is List) return v.whereType<CommandExecutionNode>().toList();
    return const [];
  }

  List<CapabilityExecutionNode> get capabilityExecutionNodes {
    final v = this[AssistantWorkflowBusinessKeys.capabilityExecutionNodes];
    if (v is List<CapabilityExecutionNode>) return v;
    if (v is List) return v.whereType<CapabilityExecutionNode>().toList();
    return const [];
  }

  AssistantWorkflowContext withClientReference(ClientReference reference) =>
      put(AssistantWorkflowBusinessKeys.clientReference, reference);

  AssistantWorkflowContext withQuoteReference(QuoteReference reference) =>
      put(AssistantWorkflowBusinessKeys.quoteReference, reference);

  AssistantWorkflowContext withEventReference(EventReference reference) =>
      put(AssistantWorkflowBusinessKeys.eventReference, reference);

  AssistantWorkflowContext withContractReference(
    ContractReference reference,
  ) =>
      put(AssistantWorkflowBusinessKeys.contractReference, reference);

  AssistantWorkflowContext withResolvedCapabilities(
    List<AssistantBusinessCapabilityResolution> resolutions,
  ) =>
      put(
        AssistantWorkflowBusinessKeys.resolvedCapabilities,
        List<AssistantBusinessCapabilityResolution>.unmodifiable(resolutions),
      );

  AssistantWorkflowContext withProducedEntities(
    List<AssistantBusinessReference> entities,
  ) =>
      put(
        AssistantWorkflowBusinessKeys.producedEntities,
        List<AssistantBusinessReference>.unmodifiable(entities),
      );

  AssistantWorkflowContext withSatisfiedDependencies(Set<String> keys) =>
      put(
        AssistantWorkflowBusinessKeys.satisfiedDependencies,
        Set<String>.unmodifiable(keys),
      );

  AssistantWorkflowContext withSharedOutputs(Map<String, Object?> outputs) =>
      put(
        AssistantWorkflowBusinessKeys.sharedOutputs,
        Map<String, Object?>.unmodifiable(outputs),
      );

  AssistantWorkflowContext withResolvedCommands(
    List<AssistantBusinessCommandResolution> resolutions,
  ) =>
      put(
        AssistantWorkflowBusinessKeys.resolvedCommands,
        List<AssistantBusinessCommandResolution>.unmodifiable(resolutions),
      );

  AssistantWorkflowContext withCommandExecutionNodes(
    List<CommandExecutionNode> nodes,
  ) =>
      put(
        AssistantWorkflowBusinessKeys.commandExecutionNodes,
        List<CommandExecutionNode>.unmodifiable(nodes),
      );

  AssistantWorkflowContext withCapabilityExecutionNodes(
    List<CapabilityExecutionNode> nodes,
  ) =>
      put(
        AssistantWorkflowBusinessKeys.capabilityExecutionNodes,
        List<CapabilityExecutionNode>.unmodifiable(nodes),
      );
}
