import '../domain/business/assistant_business_operation.dart';
import '../domain/workflow/assistant_workflow_definition.dart';
import '../domain/workflow/assistant_workflow_definition_registry.dart';
import '../domain/workflow/assistant_workflow_step.dart';
import '../domain/workflow/assistant_workflow_step_kind.dart';
import '../models/assistant_workflow_intent.dart';

/// In-memory definition registry — owns concrete recipes.
class LocalAssistantWorkflowDefinitionRegistry
    implements AssistantWorkflowDefinitionRegistry {
  LocalAssistantWorkflowDefinitionRegistry([
    Map<String, AssistantWorkflowDefinition>? definitions,
  ]) : _definitions = Map.unmodifiable(definitions ?? const {});

  final Map<String, AssistantWorkflowDefinition> _definitions;

  /// Built-in recipes previously embedded in the planner.
  factory LocalAssistantWorkflowDefinitionRegistry.defaults() {
    return LocalAssistantWorkflowDefinitionRegistry({
      AssistantWorkflowRecipe.confirmationStatusThenAudit.name:
          const AssistantWorkflowDefinition(
        id: 'confirmationStatusThenAudit',
        label: 'Status da confirmação + auditoria',
        steps: [
          AssistantWorkflowStep(
            id: 'step-confirmation-status',
            kind: AssistantWorkflowStepKind.confirmation,
            label: 'Status da confirmação',
            params: {'intentKind': 'status'},
          ),
          AssistantWorkflowStep(
            id: 'step-audit',
            kind: AssistantWorkflowStepKind.audit,
            label: 'Histórico de auditoria',
            params: {'intentKind': 'status'},
          ),
        ],
      ),
      AssistantWorkflowRecipe.confirmationCreateThenAudit.name:
          const AssistantWorkflowDefinition(
        id: 'confirmationCreateThenAudit',
        label: 'Criar confirmação + auditoria',
        steps: [
          AssistantWorkflowStep(
            id: 'step-confirmation-create',
            kind: AssistantWorkflowStepKind.confirmation,
            label: 'Criar confirmação',
            params: {'intentKind': 'create'},
          ),
          AssistantWorkflowStep(
            id: 'step-audit',
            kind: AssistantWorkflowStepKind.audit,
            label: 'Histórico de auditoria',
            params: {'intentKind': 'status'},
          ),
        ],
      ),
      AssistantWorkflowRecipe.reviewQuotesThenOpenLast.name:
          const AssistantWorkflowDefinition(
        id: 'reviewQuotesThenOpenLast',
        label: 'Revisar orçamentos e abrir o último',
        steps: [
          AssistantWorkflowStep(
            id: 'step-insight-last',
            kind: AssistantWorkflowStepKind.insight,
            label: 'Último orçamento',
            params: {'insight': 'lastQuote'},
          ),
          AssistantWorkflowStep(
            id: 'step-action-open-last',
            kind: AssistantWorkflowStepKind.action,
            label: 'Abrir último orçamento',
            params: {'action': 'openLastQuote'},
          ),
        ],
      ),
      AssistantWorkflowRecipe.findClientThenCreateQuote.name:
          const AssistantWorkflowDefinition(
        id: 'findClientThenCreateQuote',
        label: 'Buscar cliente e criar orçamento',
        steps: [
          AssistantWorkflowStep(
            id: 'step-find-client',
            kind: AssistantWorkflowStepKind.business,
            label: 'Buscar cliente',
            params: {
              'operation': AssistantBusinessOperationCodes.findClient,
              'query': 'cliente',
            },
          ),
          AssistantWorkflowStep(
            id: 'step-create-quote',
            kind: AssistantWorkflowStepKind.business,
            label: 'Criar orçamento',
            params: {
              'operation': AssistantBusinessOperationCodes.createQuote,
            },
          ),
        ],
      ),
      AssistantWorkflowRecipe.findEventThenOpenEvent.name:
          const AssistantWorkflowDefinition(
        id: 'findEventThenOpenEvent',
        label: 'Buscar evento e abrir',
        steps: [
          AssistantWorkflowStep(
            id: 'step-find-event',
            kind: AssistantWorkflowStepKind.business,
            label: 'Buscar evento',
            params: {
              'operation': AssistantBusinessOperationCodes.findEvent,
              'query': 'evento',
            },
          ),
          AssistantWorkflowStep(
            id: 'step-open-event',
            kind: AssistantWorkflowStepKind.business,
            label: 'Abrir evento',
            params: {
              'operation': AssistantBusinessOperationCodes.openEvent,
            },
          ),
        ],
      ),
      AssistantWorkflowRecipe.findQuoteThenFindContract.name:
          const AssistantWorkflowDefinition(
        id: 'findQuoteThenFindContract',
        label: 'Buscar orçamento e contrato',
        steps: [
          AssistantWorkflowStep(
            id: 'step-find-quote',
            kind: AssistantWorkflowStepKind.business,
            label: 'Buscar orçamento',
            params: {
              'operation': AssistantBusinessOperationCodes.findQuote,
              'query': 'orcamento',
            },
          ),
          AssistantWorkflowStep(
            id: 'step-find-contract',
            kind: AssistantWorkflowStepKind.business,
            label: 'Buscar contrato',
            params: {
              'operation': AssistantBusinessOperationCodes.findContract,
            },
          ),
        ],
      ),
    });
  }

  LocalAssistantWorkflowDefinitionRegistry register(
    AssistantWorkflowDefinition definition,
  ) {
    return LocalAssistantWorkflowDefinitionRegistry({
      ..._definitions,
      definition.id: definition,
    });
  }

  @override
  AssistantWorkflowDefinition? find(String id) => _definitions[id];

  @override
  bool contains(String id) => _definitions.containsKey(id);

  @override
  Iterable<AssistantWorkflowDefinition> get definitions => _definitions.values;
}
