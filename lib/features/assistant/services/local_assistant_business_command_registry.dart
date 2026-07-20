import '../domain/business/assistant_business_operation.dart';
import '../domain/business/commands/assistant_business_command.dart';
import '../domain/business/commands/assistant_business_command_category.dart';
import '../domain/business/commands/assistant_business_command_id.dart';
import '../domain/business/commands/assistant_business_command_metadata.dart';
import '../domain/business/commands/assistant_business_command_parameter.dart';
import '../domain/business/commands/assistant_business_command_registry.dart';
import '../domain/business/commands/assistant_business_command_result.dart';
import '../domain/business/commands/assistant_business_command_version.dart';
import '../domain/workflow/assistant_workflow_business_context.dart';

/// In-memory command catalog — declarative only, no ERP handlers.
///
/// Commands declare [operationCode] only; Capability resolve is done by the
/// CommandResolver.
class LocalAssistantBusinessCommandRegistry
    implements AssistantBusinessCommandRegistry {
  LocalAssistantBusinessCommandRegistry([
    Map<String, AssistantBusinessCommand>? byId,
  ]) : _byId = Map.unmodifiable(byId ?? const {});

  final Map<String, AssistantBusinessCommand> _byId;

  factory LocalAssistantBusinessCommandRegistry.defaults() {
    return LocalAssistantBusinessCommandRegistry({
      AssistantBusinessCommandIds.findClient.value:
          const AssistantBusinessCommand(
        id: AssistantBusinessCommandIds.findClient,
        version: AssistantBusinessCommandVersion.v1,
        category: AssistantBusinessCommandCategory.lookup,
        metadata: AssistantBusinessCommandMetadata(
          label: 'Comando: buscar cliente',
          description: 'Ordem declarativa FIND_CLIENT.',
          operationCode: AssistantBusinessOperationCodes.findClient,
          tags: ['client', 'lookup', 'command'],
        ),
        parameters: [
          AssistantBusinessCommandParameter(
            key: 'query',
            required: false,
            description: 'Texto de busca do cliente',
          ),
        ],
        results: [
          AssistantBusinessCommandResult(
            key: AssistantWorkflowBusinessKeys.clientReference,
            description: 'Referência opaca do cliente',
          ),
        ],
      ),
      AssistantBusinessCommandIds.createQuote.value:
          const AssistantBusinessCommand(
        id: AssistantBusinessCommandIds.createQuote,
        version: AssistantBusinessCommandVersion.v1,
        category: AssistantBusinessCommandCategory.create,
        metadata: AssistantBusinessCommandMetadata(
          label: 'Comando: criar orçamento',
          operationCode: AssistantBusinessOperationCodes.createQuote,
          tags: ['quote', 'create', 'command'],
        ),
        results: [
          AssistantBusinessCommandResult(
            key: AssistantWorkflowBusinessKeys.quoteReference,
          ),
        ],
      ),
      AssistantBusinessCommandIds.findEvent.value:
          const AssistantBusinessCommand(
        id: AssistantBusinessCommandIds.findEvent,
        version: AssistantBusinessCommandVersion.v1,
        category: AssistantBusinessCommandCategory.lookup,
        metadata: AssistantBusinessCommandMetadata(
          label: 'Comando: buscar evento',
          operationCode: AssistantBusinessOperationCodes.findEvent,
          tags: ['event', 'lookup', 'command'],
        ),
        parameters: [
          AssistantBusinessCommandParameter(key: 'query', required: false),
        ],
        results: [
          AssistantBusinessCommandResult(
            key: AssistantWorkflowBusinessKeys.eventReference,
          ),
        ],
      ),
      AssistantBusinessCommandIds.openEvent.value:
          const AssistantBusinessCommand(
        id: AssistantBusinessCommandIds.openEvent,
        version: AssistantBusinessCommandVersion.v1,
        category: AssistantBusinessCommandCategory.open,
        metadata: AssistantBusinessCommandMetadata(
          label: 'Comando: abrir evento',
          operationCode: AssistantBusinessOperationCodes.openEvent,
          tags: ['event', 'open', 'command'],
        ),
        results: [
          AssistantBusinessCommandResult(key: 'opened'),
        ],
      ),
      AssistantBusinessCommandIds.findQuote.value:
          const AssistantBusinessCommand(
        id: AssistantBusinessCommandIds.findQuote,
        version: AssistantBusinessCommandVersion.v1,
        category: AssistantBusinessCommandCategory.lookup,
        metadata: AssistantBusinessCommandMetadata(
          label: 'Comando: buscar orçamento',
          operationCode: AssistantBusinessOperationCodes.findQuote,
          tags: ['quote', 'lookup', 'command'],
        ),
        parameters: [
          AssistantBusinessCommandParameter(key: 'query', required: false),
        ],
        results: [
          AssistantBusinessCommandResult(
            key: AssistantWorkflowBusinessKeys.quoteReference,
          ),
        ],
      ),
      AssistantBusinessCommandIds.findContract.value:
          const AssistantBusinessCommand(
        id: AssistantBusinessCommandIds.findContract,
        version: AssistantBusinessCommandVersion.v1,
        category: AssistantBusinessCommandCategory.lookup,
        metadata: AssistantBusinessCommandMetadata(
          label: 'Comando: buscar contrato',
          operationCode: AssistantBusinessOperationCodes.findContract,
          tags: ['contract', 'lookup', 'command'],
        ),
        results: [
          AssistantBusinessCommandResult(
            key: AssistantWorkflowBusinessKeys.contractReference,
          ),
        ],
      ),
    });
  }

  LocalAssistantBusinessCommandRegistry register(
    AssistantBusinessCommand command,
  ) {
    return LocalAssistantBusinessCommandRegistry({
      ..._byId,
      command.id.value: command,
    });
  }

  @override
  AssistantBusinessCommand? find(AssistantBusinessCommandId id) =>
      _byId[id.value];

  @override
  AssistantBusinessCommand? findByOperationCode(String operationCode) {
    for (final c in _byId.values) {
      if (c.metadata.operationCode == operationCode) return c;
    }
    return null;
  }

  @override
  Iterable<AssistantBusinessCommand> findByCategory(
    AssistantBusinessCommandCategory category,
  ) =>
      _byId.values.where((c) => c.category == category);

  @override
  bool contains(AssistantBusinessCommandId id) => _byId.containsKey(id.value);

  @override
  Iterable<AssistantBusinessCommand> get commands => _byId.values;
}
