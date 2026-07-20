import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_context.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_definition.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_execution_state.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_result.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_step.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_step_kind.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_step_result.dart';
import 'package:eventpro/features/assistant/models/assistant_confirmation_outcome.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/models/assistant_workflow_intent.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/assistant_confirmation_session_registry.dart';
import 'package:eventpro/features/assistant/services/callback_assistant_workflow_step_handler.dart';
import 'package:eventpro/features/assistant/services/in_memory_assistant_audit_repository.dart';
import 'package:eventpro/features/assistant/services/local_assistant_audit_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_audit_query_service.dart';
import 'package:eventpro/features/assistant/services/local_assistant_confirmation_planner.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_workflow_bridge.dart';
import 'package:eventpro/features/assistant/services/local_assistant_workflow_definition_registry.dart';
import 'package:eventpro/features/assistant/services/local_assistant_workflow_executor.dart';
import 'package:eventpro/features/assistant/services/local_assistant_workflow_formatter.dart';
import 'package:eventpro/features/assistant/services/local_assistant_workflow_intent_resolver.dart';
import 'package:eventpro/features/assistant/services/local_assistant_workflow_planner.dart';
import 'package:eventpro/features/assistant/services/local_assistant_workflow_step_registry.dart';
import 'package:eventpro/features/assistant/services/local_assistant_action_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-016 assistant workflow engine', () {
    final now = DateTime.utc(2026, 7, 20, 15);
    DateTime clock() => now;

    AssistantRequest req(String text, {String id = 'req-wf', String? sessionId}) {
      return AssistantRequest(
        id: id,
        rawText: text,
        locale: 'pt_BR',
        timezone: 'America/Sao_Paulo',
        timestamp: now,
        origin: AssistantInputOrigin.typedText,
        context: sessionId == null
            ? null
            : AssistantContext(sessionId: sessionId),
      );
    }

    test('planner: recipes ordenadas e sem execução', () {
      final planner = LocalAssistantWorkflowPlanner(clock: clock);
      final workflow = planner.plan(
        const RunWorkflowIntent(
          AssistantWorkflowRecipe.confirmationCreateThenAudit,
        ),
        requestId: 'r1',
        request: req('x'),
      );
      expect(workflow, isNotNull);
      expect(workflow!.steps.map((s) => s.kind), [
        AssistantWorkflowStepKind.confirmation,
        AssistantWorkflowStepKind.audit,
      ]);
      expect(workflow.recipe, 'confirmationCreateThenAudit');
    });

    test('definition registry: planner não embute receitas', () {
      final defs = LocalAssistantWorkflowDefinitionRegistry.defaults();
      expect(defs.find('confirmationCreateThenAudit'), isNotNull);
      expect(defs.definitions, hasLength(6));

      final planner = LocalAssistantWorkflowPlanner(
        clock: clock,
        definitionRegistry: defs,
      );
      final plan = planner.planExecution(
        const RunWorkflowIntent(
          AssistantWorkflowRecipe.confirmationStatusThenAudit,
        ),
        requestId: 'r-plan',
        request: req('x'),
      );
      expect(plan, isNotNull);
      expect(plan!.definitionId, 'confirmationStatusThenAudit');
      expect(plan.steps.map((s) => s.kind), [
        AssistantWorkflowStepKind.confirmation,
        AssistantWorkflowStepKind.audit,
      ]);
      expect(plan.toWorkflow().recipe, plan.definitionId);

      final custom = defs.register(
        const AssistantWorkflowDefinition(
          id: 'customOnly',
          steps: [
            AssistantWorkflowStep(
              id: 's1',
              kind: AssistantWorkflowStepKind.read,
            ),
          ],
        ),
      );
      expect(custom.find('customOnly')?.steps, hasLength(1));
    });

    test('execution state: append imutável + interrupt', () {
      const step = AssistantWorkflowStep(
        id: 's1',
        kind: AssistantWorkflowStepKind.audit,
      );
      const base = AssistantWorkflowExecutionState();
      final next = base.appendResult(
        const AssistantWorkflowStepResult(
          step: step,
          success: true,
          outputs: {'k': 1},
        ),
      );
      expect(base.stepResults, isEmpty);
      expect(next.context['k'], 1);
      expect(next.completedStepCount, 1);
      expect(next.markInterrupted().interrupted, isTrue);
      expect(next.interrupted, isFalse);
    });

    test('registry extensível sem switch', () {
      var registry = LocalAssistantWorkflowStepRegistry();
      expect(registry.handlerFor(AssistantWorkflowStepKind.read), isNull);
      registry = registry.register(
        AssistantWorkflowStepKind.read,
        CallbackAssistantWorkflowStepHandler(({
          required step,
          required context,
          required request,
        }) async {
          return AssistantWorkflowStepOutcome(
            step: step,
            success: true,
            outputs: const {'read': true},
          );
        }),
      );
      expect(registry.handlerFor(AssistantWorkflowStepKind.read), isNotNull);
      expect(registry.registeredKinds, contains(AssistantWorkflowStepKind.read));
    });

    test('contexto imutável + put/putAll', () {
      const base = AssistantWorkflowContext();
      final next = base.put('a', 1);
      expect(base.containsKey('a'), isFalse);
      expect(next['a'], 1);
      final merged = next.putAll({'b': 'x', 'a': 2});
      expect(merged['a'], 2);
      expect(merged['b'], 'x');
      expect(next['a'], 1);
    });

    test('executor: ordem, contexto e interrupção', () async {
      final calls = <String>[];
      final registry = LocalAssistantWorkflowStepRegistry({
        AssistantWorkflowStepKind.confirmation:
            CallbackAssistantWorkflowStepHandler(({
          required step,
          required context,
          required request,
        }) async {
          calls.add('confirmation');
          return AssistantWorkflowStepOutcome(
            step: step,
            success: true,
            outputs: const {'confirmationOutcome': 'ok'},
          );
        }),
        AssistantWorkflowStepKind.audit: CallbackAssistantWorkflowStepHandler(({
          required step,
          required context,
          required request,
        }) async {
          calls.add('audit');
          expect(context['confirmationOutcome'], 'ok');
          return AssistantWorkflowStepOutcome(
            step: step,
            success: false,
            interrupt: true,
            message: 'falha audit',
          );
        }),
        AssistantWorkflowStepKind.action: CallbackAssistantWorkflowStepHandler(({
          required step,
          required context,
          required request,
        }) async {
          calls.add('action');
          return AssistantWorkflowStepOutcome(step: step, success: true);
        }),
      });

      final planner = LocalAssistantWorkflowPlanner(clock: clock);
      final workflow = planner.plan(
        const RunWorkflowIntent(
          AssistantWorkflowRecipe.confirmationCreateThenAudit,
        ),
        requestId: 'r2',
        request: req('x'),
      )!;

      final executor = LocalAssistantWorkflowExecutor(
        registry: registry,
        clock: clock,
      );
      final result = await executor.execute(
        workflow: workflow,
        request: req('x'),
      );
      expect(calls, ['confirmation', 'audit']);
      expect(result.interrupted, isTrue);
      expect(result.completed, isFalse);
      expect(result.context['confirmationOutcome'], 'ok');
      expect(result.stepOutcomes, hasLength(2));

      const formatter = LocalAssistantWorkflowFormatter();
      final presentation = formatter.format(result);
      expect(presentation.structured['interrupted'], isTrue);
    });

    test('integração orchestrator + compat AI-015', () async {
      final confirmationSessions =
          AssistantConfirmationSessionRegistry(clock: clock);
      final auditRepo = InMemoryAssistantAuditRepository();
      final auditGateway = LocalAssistantAuditGateway(repository: auditRepo);
      final auditQuery = LocalAssistantAuditQueryService(gateway: auditGateway);

      final orch = LocalAssistantOrchestrator(
        clock: clock,
        confirmationSessions: confirmationSessions,
        auditGateway: auditGateway,
        capabilities: AssistantCapabilities.localWorkflow(),
      );

      final response = await orch.handle(
        req(
          'Solicitar confirmação e mostrar auditoria',
          id: 'wf-e2e',
          sessionId: 's-wf',
        ),
      );

      expect(response.workflowPresentation, isNotNull);
      expect(response.workflowResult?.completed, isTrue);
      expect(
        response.workflowResult?.stepOutcomes.map((o) => o.step.kind),
        [
          AssistantWorkflowStepKind.confirmation,
          AssistantWorkflowStepKind.audit,
        ],
      );
      expect(
        response.confirmationResult?.outcome,
        AssistantConfirmationOutcome.previewCreated,
      );
      expect(response.auditResult, isNotNull);

      // AI-015 single-turn audit still works when not a workflow phrase.
      final auditOnly = await orch.handle(
        req('Histórico de auditoria', id: 'a15', sessionId: 's-wf'),
      );
      expect(auditOnly.workflowPresentation, isNull);
      expect(auditOnly.auditPresentation, isNotNull);

      // Bridge registry covers confirmation+audit kinds.
      final bridge = const LocalAssistantWorkflowBridge().buildRegistry(
        confirmationPlanner: LocalAssistantConfirmationPlanner(clock: clock),
        confirmationSessions: confirmationSessions,
        auditQueryService: auditQuery,
        actionGateway: LocalAssistantActionGateway(clock: clock),
      );
      expect(
        bridge.handlerFor(AssistantWorkflowStepKind.confirmation),
        isNotNull,
      );
    });

    test('intent resolver distingue recipes', () {
      const resolver = LocalAssistantWorkflowIntentResolver();
      const caps = AssistantCapabilities(
        canPlanWorkflow: true,
        canExecuteWorkflow: true,
      );
      expect(
        (resolver.resolve(
          request: req('status da confirmacao e historico de auditoria'),
          capabilities: caps,
        ) as RunWorkflowIntent?)
            ?.recipe,
        AssistantWorkflowRecipe.confirmationStatusThenAudit,
      );
      expect(
        (resolver.resolve(
          request: req('revisar orcamentos e abrir o ultimo'),
          capabilities: caps,
        ) as RunWorkflowIntent?)
            ?.recipe,
        AssistantWorkflowRecipe.reviewQuotesThenOpenLast,
      );
      expect(
        resolver.resolve(
          request: req('confirmar'),
          capabilities: caps,
        ),
        isNull,
      );
    });
  });
}
