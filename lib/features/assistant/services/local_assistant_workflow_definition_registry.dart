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
