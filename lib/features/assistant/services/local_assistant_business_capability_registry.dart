import '../domain/business/assistant_business_operation.dart';
import '../domain/business/capabilities/assistant_business_capability.dart';
import '../domain/business/capabilities/assistant_business_capability_category.dart';
import '../domain/business/capabilities/assistant_business_capability_constraint.dart';
import '../domain/business/capabilities/assistant_business_capability_id.dart';
import '../domain/business/capabilities/assistant_business_capability_input.dart';
import '../domain/business/capabilities/assistant_business_capability_metadata.dart';
import '../domain/business/capabilities/assistant_business_capability_output.dart';
import '../domain/business/capabilities/assistant_business_capability_registry.dart';
import '../domain/business/capabilities/assistant_business_capability_version.dart';
import '../domain/workflow/assistant_workflow_business_context.dart';

/// In-memory capability catalog — declarative only, no ERP handlers.
class LocalAssistantBusinessCapabilityRegistry
    implements AssistantBusinessCapabilityRegistry {
  LocalAssistantBusinessCapabilityRegistry([
    Map<String, AssistantBusinessCapability>? byId,
  ]) : _byId = Map.unmodifiable(byId ?? const {});

  final Map<String, AssistantBusinessCapability> _byId;

  factory LocalAssistantBusinessCapabilityRegistry.defaults() {
    return LocalAssistantBusinessCapabilityRegistry({
      AssistantBusinessCapabilityIds.findClient.value:
          const AssistantBusinessCapability(
        id: AssistantBusinessCapabilityIds.findClient,
        version: AssistantBusinessCapabilityVersion.v1,
        category: AssistantBusinessCapabilityCategory.lookup,
        metadata: AssistantBusinessCapabilityMetadata(
          label: 'Buscar cliente',
          description: 'Resolve ClientReference a partir de uma consulta.',
          operationCode: AssistantBusinessOperationCodes.findClient,
          tags: ['client', 'lookup'],
        ),
        inputs: [
          AssistantBusinessCapabilityInput(
            key: 'query',
            required: false,
            description: 'Texto de busca do cliente',
          ),
        ],
        outputs: [
          AssistantBusinessCapabilityOutput(
            key: AssistantWorkflowBusinessKeys.clientReference,
            description: 'Referência opaca do cliente',
          ),
        ],
      ),
      AssistantBusinessCapabilityIds.createQuote.value:
          const AssistantBusinessCapability(
        id: AssistantBusinessCapabilityIds.createQuote,
        version: AssistantBusinessCapabilityVersion.v1,
        category: AssistantBusinessCapabilityCategory.create,
        metadata: AssistantBusinessCapabilityMetadata(
          label: 'Criar orçamento',
          description: 'Produz QuoteReference a partir de um cliente.',
          operationCode: AssistantBusinessOperationCodes.createQuote,
          tags: ['quote', 'create'],
        ),
        outputs: [
          AssistantBusinessCapabilityOutput(
            key: AssistantWorkflowBusinessKeys.quoteReference,
            description: 'Referência opaca do orçamento',
          ),
        ],
        constraints: [
          AssistantBusinessCapabilityConstraint(
            kind: AssistantBusinessCapabilityConstraintKind
                .requiresSatisfiedDependency,
            key: AssistantWorkflowBusinessKeys.clientReference,
            message: 'CREATE_QUOTE exige clientReference satisfeito.',
          ),
        ],
      ),
      AssistantBusinessCapabilityIds.findEvent.value:
          const AssistantBusinessCapability(
        id: AssistantBusinessCapabilityIds.findEvent,
        version: AssistantBusinessCapabilityVersion.v1,
        category: AssistantBusinessCapabilityCategory.lookup,
        metadata: AssistantBusinessCapabilityMetadata(
          label: 'Buscar evento',
          description: 'Resolve EventReference.',
          operationCode: AssistantBusinessOperationCodes.findEvent,
          tags: ['event', 'lookup'],
        ),
        inputs: [
          AssistantBusinessCapabilityInput(
            key: 'query',
            required: false,
          ),
        ],
        outputs: [
          AssistantBusinessCapabilityOutput(
            key: AssistantWorkflowBusinessKeys.eventReference,
          ),
        ],
      ),
      AssistantBusinessCapabilityIds.openEvent.value:
          const AssistantBusinessCapability(
        id: AssistantBusinessCapabilityIds.openEvent,
        version: AssistantBusinessCapabilityVersion.v1,
        category: AssistantBusinessCapabilityCategory.open,
        metadata: AssistantBusinessCapabilityMetadata(
          label: 'Abrir evento',
          description: 'Abre um evento previamente resolvido.',
          operationCode: AssistantBusinessOperationCodes.openEvent,
          tags: ['event', 'open'],
        ),
        constraints: [
          AssistantBusinessCapabilityConstraint(
            kind: AssistantBusinessCapabilityConstraintKind
                .requiresSatisfiedDependency,
            key: AssistantWorkflowBusinessKeys.eventReference,
            message: 'OPEN_EVENT exige eventReference satisfeito.',
          ),
        ],
        outputs: [
          AssistantBusinessCapabilityOutput(key: 'opened'),
        ],
      ),
      AssistantBusinessCapabilityIds.findQuote.value:
          const AssistantBusinessCapability(
        id: AssistantBusinessCapabilityIds.findQuote,
        version: AssistantBusinessCapabilityVersion.v1,
        category: AssistantBusinessCapabilityCategory.lookup,
        metadata: AssistantBusinessCapabilityMetadata(
          label: 'Buscar orçamento',
          description: 'Resolve QuoteReference.',
          operationCode: AssistantBusinessOperationCodes.findQuote,
          tags: ['quote', 'lookup'],
        ),
        inputs: [
          AssistantBusinessCapabilityInput(
            key: 'query',
            required: false,
          ),
        ],
        outputs: [
          AssistantBusinessCapabilityOutput(
            key: AssistantWorkflowBusinessKeys.quoteReference,
          ),
        ],
      ),
      AssistantBusinessCapabilityIds.findContract.value:
          const AssistantBusinessCapability(
        id: AssistantBusinessCapabilityIds.findContract,
        version: AssistantBusinessCapabilityVersion.v1,
        category: AssistantBusinessCapabilityCategory.lookup,
        metadata: AssistantBusinessCapabilityMetadata(
          label: 'Buscar contrato',
          description: 'Resolve ContractReference a partir de um orçamento.',
          operationCode: AssistantBusinessOperationCodes.findContract,
          tags: ['contract', 'lookup'],
        ),
        outputs: [
          AssistantBusinessCapabilityOutput(
            key: AssistantWorkflowBusinessKeys.contractReference,
          ),
        ],
        constraints: [
          AssistantBusinessCapabilityConstraint(
            kind: AssistantBusinessCapabilityConstraintKind
                .requiresSatisfiedDependency,
            key: AssistantWorkflowBusinessKeys.quoteReference,
            message: 'FIND_CONTRACT exige quoteReference satisfeito.',
          ),
        ],
      ),
    });
  }

  LocalAssistantBusinessCapabilityRegistry register(
    AssistantBusinessCapability capability,
  ) {
    return LocalAssistantBusinessCapabilityRegistry({
      ..._byId,
      capability.id.value: capability,
    });
  }

  @override
  AssistantBusinessCapability? find(AssistantBusinessCapabilityId id) =>
      _byId[id.value];

  @override
  AssistantBusinessCapability? findByOperationCode(String operationCode) {
    for (final c in _byId.values) {
      if (c.metadata.operationCode == operationCode) return c;
    }
    return null;
  }

  /// Capabilities filtered by formal [category] (extensible, no switch).
  Iterable<AssistantBusinessCapability> findByCategory(
    AssistantBusinessCapabilityCategory category,
  ) =>
      _byId.values.where((c) => c.category == category);

  @override
  bool contains(AssistantBusinessCapabilityId id) =>
      _byId.containsKey(id.value);

  @override
  Iterable<AssistantBusinessCapability> get capabilities => _byId.values;
}
