import 'package:eventpro/features/assistant/domain/transaction_execution/assistant_transaction_execution_metadata.dart';
import 'package:eventpro/features/assistant/domain/transaction_execution/assistant_transaction_execution_outcome.dart';
import 'package:eventpro/features/assistant/domain/transaction_execution/assistant_transaction_execution_result.dart';
import 'package:eventpro/features/assistant/models/assistant_confirmation_operation_kind.dart';
import 'package:eventpro/features/assistant/models/assistant_confirmation_outcome.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_context.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_policy.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_token.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_integration_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/models/assistant_safe_confirmation_intent.dart';
import 'package:eventpro/features/assistant/models/assistant_transaction_execution_intent.dart';
import 'package:eventpro/features/assistant/models/assistant_transaction_plan_fingerprint.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/assistant_confirmation_session_registry.dart';
import 'package:eventpro/features/assistant/services/local_assistant_confirmation_planner.dart';
import 'package:eventpro/features/assistant/services/local_assistant_idempotency_service.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_transaction_execution_formatter.dart';
import 'package:eventpro/features/assistant/services/local_assistant_transaction_execution_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_transaction_execution_planner.dart';
import 'package:eventpro/features/assistant/services/local_assistant_write_coordinator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_write_gateway.dart';
import 'package:eventpro/features/quotes/assistant/quote_assistant_write_adapter.dart';
import 'package:eventpro/features/quotes/assistant/quote_idempotency_completed_lookup.dart';
import 'package:eventpro/features/quotes/utils/quote_draft_creation_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';

void main() {
  group('AI-014 transaction execution engine', () {
    var now = DateTime.utc(2026, 7, 19, 22);
    DateTime clock() => now;

    final attrs =
        AssistantTransactionPlanFingerprint.defaultQuoteDraftAttributes;

    late FakeQuoteRepository repository;
    late LocalAssistantWriteGateway writeGateway;
    late LocalAssistantWriteCoordinator writeCoordinator;
    late AssistantConfirmationSessionRegistry confirmationSessions;
    late LocalAssistantConfirmationPlanner confirmationPlanner;
    late LocalAssistantTransactionExecutionPlanner txPlanner;
    late LocalAssistantTransactionExecutionGateway txGateway;
    const formatter = LocalAssistantTransactionExecutionFormatter();

    setUp(() {
      now = DateTime.utc(2026, 7, 19, 22);
      repository = FakeQuoteRepository();
      final service = QuoteDraftCreationService(repository, clock: clock);
      writeGateway = LocalAssistantWriteGateway(
        quoteDraftAdapter: QuoteAssistantWriteAdapter(service),
      );
      writeCoordinator = LocalAssistantWriteCoordinator(
        idempotencyService: LocalAssistantIdempotencyService(
          completedLookup:
              quoteIdempotencyCompletedLookup(repository, clock: clock),
          clock: clock,
        ),
        clock: clock,
      );
      confirmationSessions = AssistantConfirmationSessionRegistry(clock: clock);
      confirmationPlanner = LocalAssistantConfirmationPlanner(
        clock: clock,
        ttl: const Duration(minutes: 5),
        tokenFactory: () => 'tok-ai014',
      );
      txPlanner = LocalAssistantTransactionExecutionPlanner(clock: clock);
      txGateway = LocalAssistantTransactionExecutionGateway(
        writeCoordinator: writeCoordinator,
        clock: clock,
      );
    });

    AssistantExecutionContext ctx() {
      return AssistantExecutionContext(
        requestId: 'req-ai14',
        token: const AssistantExecutionToken('tok-exec'),
        mode: AssistantExecutionMode.production,
        integrationMode: AssistantIntegrationMode.none,
        timestamp: now,
        confirmedStepIds: const {'step-create-quote'},
        policy: AssistantExecutionPolicy.ai006QuoteDraftProduction,
      );
    }

    AssistantRequest req(
      String text, {
      String id = 'req-ai14',
      String? sessionId = 's-ai14',
    }) {
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

    void createAndConfirm({String sessionId = 's-ai14'}) {
      final session = confirmationSessions.getOrCreate(sessionId);
      final created = confirmationPlanner.process(
        request: confirmationPlanner.planRequest(
          CreateConfirmationIntent(approvedAttributes: attrs),
          requestId: 'c-create-$sessionId',
          sessionId: sessionId,
        ),
        session: session,
      );
      expect(created.outcome, AssistantConfirmationOutcome.previewCreated);
      final confirmed = confirmationPlanner.process(
        request: confirmationPlanner.planRequest(
          const ConfirmPendingIntent(),
          requestId: 'c-confirm-$sessionId',
          sessionId: sessionId,
        ),
        session: session,
      );
      expect(confirmed.outcome, AssistantConfirmationOutcome.confirmed);
    }

    test('confirmação válida executa Create Quote Draft', () async {
      createAndConfirm();
      final session = confirmationSessions.getOrCreate('s-ai14');
      final planned = txPlanner.plan(
        intent: const ExecuteConfirmedTransactionIntent(),
        requestId: 'exec-1',
        sessionId: 's-ai14',
        session: session,
        proposedOperationKind:
            AssistantConfirmationOperationKind.createQuoteDraft,
        proposedAttributes: attrs,
      );
      expect(planned.rejection, isNull);
      expect(planned.request, isNotNull);
      expect(session.pending?.consumed, isTrue);

      final result = await txGateway.execute(
        request: planned.request!,
        context: ctx(),
        writeGateway: writeGateway,
      );
      expect(result.outcome, AssistantTransactionExecutionOutcome.completed);
      expect(result.executed, isTrue);
      expect(result.writeResult?.mutatedErp, isTrue);
      expect(await repository.listAll(), isNotEmpty);

      final presentation = formatter.format(result);
      expect(presentation.naturalLanguage, contains('Execução concluída'));
      expect(presentation.structured['outcome'], 'completed');
    });

    test('token reutilizado / consumido é rejeitado', () {
      createAndConfirm();
      final session = confirmationSessions.getOrCreate('s-ai14');
      txPlanner.plan(
        intent: const ExecuteConfirmedTransactionIntent(),
        requestId: 'e1',
        sessionId: 's-ai14',
        session: session,
        proposedOperationKind:
            AssistantConfirmationOperationKind.createQuoteDraft,
        proposedAttributes: attrs,
      );
      final reused = txPlanner.plan(
        intent: const ExecuteConfirmedTransactionIntent(),
        requestId: 'e2',
        sessionId: 's-ai14',
        session: session,
        proposedOperationKind:
            AssistantConfirmationOperationKind.createQuoteDraft,
        proposedAttributes: attrs,
      );
      expect(
        reused.rejection?.outcome,
        AssistantTransactionExecutionOutcome.confirmationConsumed,
      );
      expect(
        formatter.format(reused.rejection!).naturalLanguage,
        contains('consumid'),
      );
    });

    test('confirmação cancelada é rejeitada', () {
      final session = confirmationSessions.getOrCreate('s-cancel');
      confirmationPlanner.process(
        request: confirmationPlanner.planRequest(
          CreateConfirmationIntent(approvedAttributes: attrs),
          requestId: 'cc1',
          sessionId: 's-cancel',
        ),
        session: session,
      );
      confirmationPlanner.process(
        request: confirmationPlanner.planRequest(
          const CancelPendingIntent(),
          requestId: 'cc2',
          sessionId: 's-cancel',
        ),
        session: session,
      );
      expect(session.pending?.cancelled, isTrue);

      final cancelled = txPlanner.plan(
        intent: const ExecuteConfirmedTransactionIntent(),
        requestId: 'e3',
        sessionId: 's-cancel',
        session: session,
        proposedOperationKind:
            AssistantConfirmationOperationKind.createQuoteDraft,
        proposedAttributes: attrs,
      );
      expect(
        cancelled.rejection?.outcome,
        AssistantTransactionExecutionOutcome.confirmationCancelled,
      );
    });

    test('confirmação expirada é rejeitada', () {
      createAndConfirm(sessionId: 's-exp');
      now = now.add(const Duration(minutes: 6));
      final expired = txPlanner.plan(
        intent: const ExecuteConfirmedTransactionIntent(),
        requestId: 'e4',
        sessionId: 's-exp',
        session: confirmationSessions.getOrCreate('s-exp'),
        proposedOperationKind:
            AssistantConfirmationOperationKind.createQuoteDraft,
        proposedAttributes: attrs,
      );
      expect(
        expired.rejection?.outcome,
        AssistantTransactionExecutionOutcome.confirmationExpired,
      );
    });

    test('sessionId inválido é rejeitado', () {
      final bad = txPlanner.plan(
        intent: const ExecuteConfirmedTransactionIntent(),
        requestId: 'e5',
        sessionId: null,
        session: null,
        proposedOperationKind:
            AssistantConfirmationOperationKind.createQuoteDraft,
        proposedAttributes: attrs,
      );
      expect(
        bad.rejection?.outcome,
        AssistantTransactionExecutionOutcome.invalidSession,
      );

      createAndConfirm(sessionId: 's-a');
      final mismatch = txPlanner.plan(
        intent: const ExecuteConfirmedTransactionIntent(),
        requestId: 'e5b',
        sessionId: 's-b',
        session: confirmationSessions.getOrCreate('s-a'),
        proposedOperationKind:
            AssistantConfirmationOperationKind.createQuoteDraft,
        proposedAttributes: attrs,
      );
      expect(
        mismatch.rejection?.outcome,
        AssistantTransactionExecutionOutcome.invalidSession,
      );
    });

    test('plano divergente é rejeitado', () {
      createAndConfirm(sessionId: 's-div');
      final divergent = txPlanner.plan(
        intent: const ExecuteConfirmedTransactionIntent(),
        requestId: 'e6',
        sessionId: 's-div',
        session: confirmationSessions.getOrCreate('s-div'),
        proposedOperationKind:
            AssistantConfirmationOperationKind.createQuoteDraft,
        proposedAttributes: {
          ...attrs,
          'clientDisplayName': 'Outro Cliente',
        },
      );
      expect(
        divergent.rejection?.outcome,
        AssistantTransactionExecutionOutcome.planDivergence,
      );
      expect(confirmationSessions.getOrCreate('s-div').pending?.consumed, isFalse);
    });

    test('consumo atômico e idempotência do write', () async {
      createAndConfirm(sessionId: 's-idem');
      final session = confirmationSessions.getOrCreate('s-idem');
      final planned = txPlanner.plan(
        intent: const ExecuteConfirmedTransactionIntent(),
        requestId: 'w1',
        sessionId: 's-idem',
        session: session,
        proposedOperationKind:
            AssistantConfirmationOperationKind.createQuoteDraft,
        proposedAttributes: attrs,
      );
      expect(session.pending?.consumed, isTrue);

      final first = await txGateway.execute(
        request: planned.request!,
        context: ctx(),
        writeGateway: writeGateway,
      );
      expect(first.outcome, AssistantTransactionExecutionOutcome.completed);
      final count = (await repository.listAll()).length;
      expect(count, 1);

      final second = await txGateway.execute(
        request: planned.request!,
        context: ctx(),
        writeGateway: writeGateway,
      );
      expect(second.writeResult?.executed, isTrue);
      expect(second.writeResult?.mutatedErp, isFalse);
      expect((await repository.listAll()).length, count);

      final atomic = txPlanner.plan(
        intent: const ExecuteConfirmedTransactionIntent(),
        requestId: 'w2',
        sessionId: 's-idem',
        session: session,
        proposedOperationKind:
            AssistantConfirmationOperationKind.createQuoteDraft,
        proposedAttributes: attrs,
      );
      expect(
        atomic.rejection?.outcome,
        AssistantTransactionExecutionOutcome.confirmationConsumed,
      );
    });

    test('formatter cobre outcomes estruturados', () {
      for (final outcome in AssistantTransactionExecutionOutcome.values) {
        final result = AssistantTransactionExecutionResult(
          requestId: 'fmt',
          outcome: outcome,
          valid: outcome == AssistantTransactionExecutionOutcome.completed,
          executed: outcome == AssistantTransactionExecutionOutcome.completed,
          summary: 'summary-$outcome',
          warnings: const [],
          metadata: AssistantTransactionExecutionMetadata(
            requestId: 'fmt',
            generatedAt: now,
          ),
        );
        final presentation = formatter.format(result);
        expect(presentation.structured['outcome'], outcome.name);
        expect(presentation.naturalLanguage, isNotEmpty);
      }
    });

    test('integração E2E create → confirm → execute', () async {
      final orch = LocalAssistantOrchestrator(
        clock: clock,
        executionMode: AssistantExecutionMode.production,
        writeGateway: writeGateway,
        writeCoordinator: writeCoordinator,
        confirmationSessions: confirmationSessions,
        capabilities: AssistantCapabilities.localTransactionExecution(),
        confirmedStepIds: const {'step-create-quote'},
      );

      final created = await orch.handle(
        req('Solicitar confirmação para criar orçamento', id: 'e2e-1'),
      );
      expect(
        created.confirmationResult?.outcome,
        AssistantConfirmationOutcome.previewCreated,
      );

      final confirmed = await orch.handle(req('Confirmar', id: 'e2e-2'));
      expect(
        confirmed.confirmationResult?.outcome,
        AssistantConfirmationOutcome.confirmed,
      );
      expect(await repository.listAll(), isEmpty);

      final executed = await orch.handle(
        req('Executar operação confirmada', id: 'e2e-3'),
      );
      expect(
        executed.transactionExecutionResult?.outcome,
        AssistantTransactionExecutionOutcome.completed,
      );
      expect(executed.transactionExecutionPresentation?.structured, isNotEmpty);
      expect(executed.writeResult?.executed, isTrue);
      expect(await repository.listAll(), isNotEmpty);

      final reused = await orch.handle(req('Executar', id: 'e2e-4'));
      expect(
        reused.transactionExecutionResult?.outcome,
        AssistantTransactionExecutionOutcome.confirmationConsumed,
      );
    });

    test('compatibilidade AI-013: confirm ainda não escreve', () async {
      final orch = LocalAssistantOrchestrator(
        clock: clock,
        executionMode: AssistantExecutionMode.production,
        writeGateway: writeGateway,
        writeCoordinator: writeCoordinator,
        confirmationSessions: confirmationSessions,
        capabilities: AssistantCapabilities.localSafeConfirmation(),
      );
      await orch.handle(
        req('Solicitar confirmação para criar orçamento', id: 'c13-1'),
      );
      final confirmed = await orch.handle(req('Confirmar', id: 'c13-2'));
      expect(
        confirmed.confirmationResult?.outcome,
        AssistantConfirmationOutcome.confirmed,
      );
      expect(confirmed.confirmationResult?.summary, contains('Nenhuma escrita'));
      expect(await repository.listAll(), isEmpty);
      expect(confirmed.transactionExecutionResult, isNull);
    });
  });
}
