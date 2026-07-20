import 'package:eventpro/features/assistant/domain/business/assistant_business_operation.dart';
import 'package:eventpro/features/assistant/domain/business/assistant_business_reference.dart';
import 'package:eventpro/features/assistant/domain/business/assistant_business_registry.dart';
import 'package:eventpro/features/assistant/domain/business/assistant_business_request.dart';
import 'package:eventpro/features/assistant/domain/business/assistant_business_result.dart';
import 'package:eventpro/features/assistant/domain/business/assistant_business_status.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_business_context.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_context.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_step.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_step_kind.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/models/assistant_workflow_intent.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/assistant_confirmation_session_registry.dart';
import 'package:eventpro/features/assistant/services/assistant_workflow_business_bridge.dart';
import 'package:eventpro/features/assistant/services/in_memory_assistant_audit_repository.dart';
import 'package:eventpro/features/assistant/services/local_assistant_action_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_audit_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_audit_query_service.dart';
import 'package:eventpro/features/assistant/services/local_assistant_business_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_business_registry.dart';
import 'package:eventpro/features/assistant/services/local_assistant_confirmation_planner.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_workflow_bridge.dart';
import 'package:eventpro/features/assistant/services/local_assistant_workflow_executor.dart';
import 'package:eventpro/features/assistant/services/local_assistant_workflow_planner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-017 business workflow integration', () {
    final now = DateTime.utc(2026, 7, 20, 16);
    DateTime clock() => now;

    AssistantRequest req(String text, {String id = 'req-biz'}) {
      return AssistantRequest(
        id: id,
        rawText: text,
        locale: 'pt_BR',
        timezone: 'America/Sao_Paulo',
        timestamp: now,
        origin: AssistantInputOrigin.typedText,
        context: const AssistantContext(sessionId: 's-biz'),
      );
    }

    test('business registry: operações extensíveis sem switch', () {
      final registry = LocalAssistantBusinessRegistry.defaults();
      expect(
        registry.contains(AssistantBusinessOperationCodes.findClient),
        isTrue,
      );
      expect(registry.operations, hasLength(6));
      expect(
        registry.handlerFor(AssistantBusinessOperationCodes.createQuote),
        isNotNull,
      );

      final extended = registry.register(
        operation: const AssistantBusinessOperation(
          code: 'CUSTOM_OP',
          label: 'Custom',
        ),
        handler: _AlwaysOkHandler(),
      );
      expect(extended.contains('CUSTOM_OP'), isTrue);
      expect(extended.find('CUSTOM_OP')?.label, 'Custom');
    });

    test('business gateway: FIND_CLIENT e CREATE_QUOTE stubs', () async {
      final gateway = LocalAssistantBusinessGateway();
      final find = await gateway.execute(
        const AssistantBusinessRequest(
          requestId: 'r1',
          operation: AssistantBusinessOperation(
            code: AssistantBusinessOperationCodes.findClient,
          ),
          params: {'query': 'Maria'},
        ),
      );
      expect(find.succeeded, isTrue);
      expect(find.clientReference, isA<ClientReference>());
      expect(find.clientReference!.id, contains('maria'));

      final create = await gateway.execute(
        AssistantBusinessRequest(
          requestId: 'r2',
          operation: const AssistantBusinessOperation(
            code: AssistantBusinessOperationCodes.createQuote,
          ),
          clientReference: find.clientReference,
        ),
      );
      expect(create.succeeded, isTrue);
      expect(create.quoteReference, isA<QuoteReference>());
      expect(create.clientReference?.id, find.clientReference!.id);
    });

    test('business gateway: operação não registrada', () async {
      final gateway = LocalAssistantBusinessGateway();
      final result = await gateway.execute(
        const AssistantBusinessRequest(
          requestId: 'r3',
          operation: AssistantBusinessOperation(code: 'UNKNOWN_OP'),
        ),
      );
      expect(result.status, AssistantBusinessStatus.unavailable);
      expect(result.valid, isFalse);
    });

    test('entity references tipadas e contexto', () {
      const client = ClientReference(id: 'c1', label: 'Cliente');
      const quote = QuoteReference(id: 'q1');
      const event = EventReference(id: 'e1');
      const contract = ContractReference(id: 'k1');

      final ctx = const AssistantWorkflowContext()
          .withClientReference(client)
          .withQuoteReference(quote)
          .withEventReference(event)
          .withContractReference(contract);

      expect(ctx.clientReference?.id, 'c1');
      expect(ctx.quoteReference?.id, 'q1');
      expect(ctx.eventReference?.id, 'e1');
      expect(ctx.contractReference?.id, 'k1');
      expect(client.kind, 'client');
      expect(quote.kind, 'quote');
      expect(event.kind, 'event');
      expect(contract.kind, 'contract');
    });

    test('business bridge: step → gateway → contexto', () async {
      final bridge = AssistantWorkflowBusinessBridge(
        gateway: LocalAssistantBusinessGateway(),
      );
      const step = AssistantWorkflowStep(
        id: 's1',
        kind: AssistantWorkflowStepKind.business,
        params: {
          'operation': AssistantBusinessOperationCodes.findClient,
          'query': 'Ana',
        },
      );
      final result = await bridge.execute(
        step: step,
        context: const AssistantWorkflowContext(),
        request: req('x'),
      );
      expect(result.success, isTrue);
      expect(
        result.outputs[AssistantWorkflowBusinessKeys.clientReference],
        isA<ClientReference>(),
      );
      expect(
        result.outputs[AssistantWorkflowBusinessKeys.businessResult],
        isA<AssistantBusinessResult>(),
      );
    });

    test('propagação: FIND_CLIENT → CREATE_QUOTE no executor', () async {
      final confirmationSessions =
          AssistantConfirmationSessionRegistry(clock: clock);
      final auditRepo = InMemoryAssistantAuditRepository();
      final auditGateway = LocalAssistantAuditGateway(repository: auditRepo);
      final auditQuery = LocalAssistantAuditQueryService(gateway: auditGateway);

      final registry = const LocalAssistantWorkflowBridge().buildRegistry(
        confirmationPlanner: LocalAssistantConfirmationPlanner(clock: clock),
        confirmationSessions: confirmationSessions,
        auditQueryService: auditQuery,
        actionGateway: LocalAssistantActionGateway(clock: clock),
        businessGateway: LocalAssistantBusinessGateway(),
        clock: clock,
      );

      final planner = LocalAssistantWorkflowPlanner(clock: clock);
      final workflow = planner.plan(
        const RunWorkflowIntent(
          AssistantWorkflowRecipe.findClientThenCreateQuote,
        ),
        requestId: 'wf-biz',
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

      expect(result.completed, isTrue);
      expect(result.context.clientReference, isNotNull);
      expect(result.context.quoteReference, isNotNull);
      expect(
        result.context.quoteReference!.id,
        contains(result.context.clientReference!.id),
      );
    });

    test('isolamento: workflow não importa modelos ERP', () {
      const ref = ClientReference(id: 'c');
      expect(ref, isA<AssistantBusinessReference>());
      expect(ref.toDeterministicMap()['kind'], 'client');
    });

    test('integração orchestrator AI-016 + AI-017', () async {
      final orch = LocalAssistantOrchestrator(
        clock: clock,
        capabilities: AssistantCapabilities.localBusinessWorkflow(),
        businessGateway: LocalAssistantBusinessGateway(),
      );

      final biz = await orch.handle(
        req('Buscar cliente e criar orçamento', id: 'orch-biz'),
      );
      expect(biz.workflowResult?.completed, isTrue);
      expect(biz.workflowResult?.context.clientReference, isNotNull);
      expect(biz.workflowResult?.context.quoteReference, isNotNull);

      final legacy = await orch.handle(
        req(
          'Solicitar confirmação e mostrar auditoria',
          id: 'orch-legacy',
        ),
      );
      expect(legacy.workflowResult?.completed, isTrue);
      expect(
        legacy.workflowResult?.stepOutcomes.map((o) => o.step.kind),
        [
          AssistantWorkflowStepKind.confirmation,
          AssistantWorkflowStepKind.audit,
        ],
      );
    });
  });
}

class _AlwaysOkHandler implements AssistantBusinessOperationHandler {
  @override
  Future<AssistantBusinessResult> handle(AssistantBusinessRequest request) async {
    return AssistantBusinessResult(
      requestId: request.requestId,
      operation: request.operation,
      status: AssistantBusinessStatus.succeeded,
      message: 'ok',
    );
  }
}
