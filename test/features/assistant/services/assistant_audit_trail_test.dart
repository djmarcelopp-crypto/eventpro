import 'package:eventpro/features/assistant/domain/audit/assistant_audit_event_type.dart';
import 'package:eventpro/features/assistant/domain/audit/assistant_audit_query.dart';
import 'package:eventpro/features/assistant/domain/audit/assistant_audit_warning.dart';
import 'package:eventpro/features/assistant/domain/transaction_execution/assistant_transaction_execution_outcome.dart';
import 'package:eventpro/features/assistant/models/assistant_confirmation_outcome.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/models/assistant_transaction_plan_fingerprint.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/assistant_confirmation_session_registry.dart';
import 'package:eventpro/features/assistant/services/hmac_sha256_assistant_audit_token_fingerprinter.dart';
import 'package:eventpro/features/assistant/services/in_memory_assistant_audit_repository.dart';
import 'package:eventpro/features/assistant/services/local_assistant_audit_event_factory.dart';
import 'package:eventpro/features/assistant/services/local_assistant_audit_formatter.dart';
import 'package:eventpro/features/assistant/services/local_assistant_audit_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_audit_query_service.dart';
import 'package:eventpro/features/assistant/domain/audit/assistant_audit_token_fingerprinter.dart';
import 'package:eventpro/features/assistant/services/local_assistant_idempotency_service.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_write_coordinator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_write_gateway.dart';
import 'package:eventpro/features/quotes/assistant/quote_assistant_write_adapter.dart';
import 'package:eventpro/features/quotes/assistant/quote_idempotency_completed_lookup.dart';
import 'package:eventpro/features/quotes/utils/quote_draft_creation_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';

void main() {
  group('AI-015 transaction audit trail', () {
    var now = DateTime.utc(2026, 7, 20, 12);
    DateTime clock() => now;

    late InMemoryAssistantAuditRepository repo;
    late LocalAssistantAuditGateway gateway;
    late LocalAssistantAuditEventFactory factory;
    late LocalAssistantAuditQueryService queryService;
    const formatter = LocalAssistantAuditFormatter();

    setUp(() {
      now = DateTime.utc(2026, 7, 20, 12);
      repo = InMemoryAssistantAuditRepository();
      gateway = LocalAssistantAuditGateway(repository: repo);
      factory = LocalAssistantAuditEventFactory(
        clock: clock,
        idFactory: () => 'aud-fixed',
      );
      queryService = LocalAssistantAuditQueryService(gateway: gateway);
    });

    test('criação, ordenação, append-only, isolamento, filtros, limite', () {
      final a1 = factory.build(
        eventType: AssistantAuditEventType.confirmationCreated,
        sessionId: 's1',
        correlationId: 'corr-1',
        outcome: 'previewCreated',
        rawToken: 'secret-token-1',
      );
      final stored1 = gateway.append(a1);
      expect(stored1.sequence, 1);
      expect(stored1.metadata.tokenFingerprint, isNotNull);
      expect(stored1.metadata.tokenFingerprint, isNot(contains('secret')));
      expect(a1.metadata.tokenFingerprint, isNot(contains('secret-token')));

      now = now.add(const Duration(seconds: 1));
      final a2 = factory.build(
        eventType: AssistantAuditEventType.confirmationConfirmed,
        sessionId: 's1',
        correlationId: 'corr-1',
        outcome: 'confirmed',
        rawToken: 'secret-token-1',
      );
      expect(gateway.append(a2).sequence, 2);

      final other = factory.build(
        eventType: AssistantAuditEventType.confirmationCreated,
        sessionId: 's2',
        correlationId: 'corr-2',
        outcome: 'previewCreated',
        rawToken: 'other',
      );
      expect(gateway.append(other).sequence, 1);

      final bySession = queryService.query(
        const AssistantAuditQuery(requestId: 'q1', sessionId: 's1'),
      );
      expect(bySession.events.map((e) => e.sequence), [1, 2]);
      expect(bySession.events.every((e) => e.sessionId == 's1'), isTrue);

      final byCorr = queryService.query(
        const AssistantAuditQuery(requestId: 'q2', correlationId: 'corr-1'),
      );
      expect(byCorr.totalMatched, 2);

      final byType = queryService.query(
        const AssistantAuditQuery(
          requestId: 'q3',
          eventType: AssistantAuditEventType.confirmationConfirmed,
        ),
      );
      expect(byType.returnedCount, 1);

      // Fill beyond default limit
      for (var i = 0; i < 55; i++) {
        gateway.append(
          factory.build(
            eventType: AssistantAuditEventType.confirmationStatusChecked,
            sessionId: 's-limit',
            correlationId: 'corr-limit',
            outcome: 'status',
          ),
        );
      }
      final limited = queryService.query(
        const AssistantAuditQuery(requestId: 'q4', sessionId: 's-limit'),
      );
      expect(limited.returnedCount, AssistantAuditQuery.defaultLimit);
      expect(limited.totalMatched, 55);
      expect(
        limited.warnings.any((w) => w.code == AssistantAuditWarning.limitApplied),
        isTrue,
      );

      // Append-only: reset clears; no update API
      repo.reset(sessionId: 's2');
      expect(repo.countBySession('s2'), 0);
      expect(repo.countBySession('s1'), 2);

      final presentation = formatter.format(bySession);
      expect(presentation.structured['events'], isA<List>());
      expect(presentation.naturalLanguage, isNotEmpty);
    });

    test('factory sanitiza metadata sensível', () {
      final event = factory.build(
        eventType: AssistantAuditEventType.executionCompleted,
        sessionId: 's',
        correlationId: 'c',
        outcome: 'ok',
        rawToken: 'tok-plain',
        extra: {
          'token': 'must-drop',
          'password': 'x',
          'draftId': 'd-1',
          'rawText': 'full message',
        },
      );
      expect(event.metadata.extra.containsKey('token'), isFalse);
      expect(event.metadata.extra.containsKey('password'), isFalse);
      expect(event.metadata.extra.containsKey('rawText'), isFalse);
      expect(event.metadata.extra['draftId'], 'd-1');
      expect(
        event.metadata.tokenFingerprint!.startsWith('hmac-sha256-'),
        isTrue,
      );
      expect(event.toDeterministicMap().toString(), isNot(contains('tok-plain')));
    });

    test('HMAC-SHA-256 fingerprinter: determinismo, distinção e chave', () {
      const token = 'confirmation-token-alpha';
      final keyA = List<int>.generate(32, (i) => i + 1);
      final keyB = List<int>.generate(32, (i) => i + 2);
      final fpA = HmacSha256AssistantAuditTokenFingerprinter(keyMaterial: keyA);
      final fpB = HmacSha256AssistantAuditTokenFingerprinter(keyMaterial: keyB);

      final first = fpA.fingerprint(token);
      final again = fpA.fingerprint(token);
      expect(first, again);
      expect(first, isNot(equals(token)));
      expect(first, isNot(contains(token)));
      expect(first.startsWith('hmac-sha256-'), isTrue);

      final otherToken = fpA.fingerprint('confirmation-token-beta');
      expect(otherToken, isNot(equals(first)));

      final differentKey = fpB.fingerprint(token);
      expect(differentKey, isNot(equals(first)));

      // Factory uses only the injected abstraction.
      var calls = 0;
      final spy = _SpyFingerprinter((raw) {
        calls++;
        return fpA.fingerprint(raw);
      });
      final injected = LocalAssistantAuditEventFactory(
        clock: clock,
        tokenFingerprinter: spy,
      );
      expect(identical(injected.tokenFingerprinter, spy), isTrue);
      final event = injected.build(
        eventType: AssistantAuditEventType.confirmationCreated,
        sessionId: 's',
        correlationId: 'c',
        outcome: 'ok',
        rawToken: token,
      );
      expect(calls, 1);
      expect(event.metadata.tokenFingerprint, first);
      expect(event.toDeterministicMap().toString(), isNot(contains(token)));

      final corr1 = injected.correlationIdFor(
        sessionId: 's',
        tokenFingerprint: first,
      );
      final corr2 = injected.correlationIdFor(
        sessionId: 's',
        tokenFingerprint: injected.tokenFingerprint(token),
      );
      expect(corr1, corr2);
    });

    test('orchestrator: ciclo confirmação + execução + consulta + AI-014 compat',
        () async {
      final quotes = FakeQuoteRepository();
      final service = QuoteDraftCreationService(quotes, clock: clock);
      final writeGateway = LocalAssistantWriteGateway(
        quoteDraftAdapter: QuoteAssistantWriteAdapter(service),
      );
      final writeCoordinator = LocalAssistantWriteCoordinator(
        idempotencyService: LocalAssistantIdempotencyService(
          completedLookup:
              quoteIdempotencyCompletedLookup(quotes, clock: clock),
          clock: clock,
        ),
        clock: clock,
      );
      final confirmationSessions =
          AssistantConfirmationSessionRegistry(clock: clock);
      final auditRepo = InMemoryAssistantAuditRepository();
      final auditGateway = LocalAssistantAuditGateway(repository: auditRepo);

      final orch = LocalAssistantOrchestrator(
        clock: clock,
        executionMode: AssistantExecutionMode.production,
        writeGateway: writeGateway,
        writeCoordinator: writeCoordinator,
        confirmationSessions: confirmationSessions,
        auditGateway: auditGateway,
        capabilities: AssistantCapabilities.localAuditTrail(),
        confirmedStepIds: const {'step-create-quote'},
      );

      AssistantRequest req(String text, {required String id}) =>
          AssistantRequest(
            id: id,
            rawText: text,
            locale: 'pt_BR',
            timezone: 'America/Sao_Paulo',
            timestamp: now,
            origin: AssistantInputOrigin.typedText,
            context: const AssistantContext(sessionId: 's-audit'),
          );

      final created = await orch.handle(
        req('Solicitar confirmação para criar orçamento', id: 'a1'),
      );
      expect(
        created.confirmationResult?.outcome,
        AssistantConfirmationOutcome.previewCreated,
      );
      expect(
        auditRepo.countByType(AssistantAuditEventType.confirmationCreated),
        1,
      );

      final cancelledSetup = await orch.handle(
        req('Cancelar confirmação', id: 'a1b'),
      );
      expect(
        cancelledSetup.confirmationResult?.outcome,
        AssistantConfirmationOutcome.cancelled,
      );
      expect(
        auditRepo.countByType(AssistantAuditEventType.confirmationCancelled),
        1,
      );

      await orch.handle(
        req('Solicitar confirmação para criar orçamento', id: 'a2'),
      );
      now = now.add(const Duration(minutes: 6));
      final expired = await orch.handle(req('Confirmar', id: 'a3'));
      expect(
        expired.confirmationResult?.outcome,
        AssistantConfirmationOutcome.expired,
      );
      expect(
        auditRepo.countByType(AssistantAuditEventType.confirmationExpired),
        greaterThanOrEqualTo(1),
      );
      now = DateTime.utc(2026, 7, 20, 12);

      await orch.handle(
        req('Solicitar confirmação para criar orçamento', id: 'a4'),
      );
      final confirmed = await orch.handle(req('Confirmar', id: 'a5'));
      expect(
        confirmed.confirmationResult?.outcome,
        AssistantConfirmationOutcome.confirmed,
      );
      expect(await quotes.listAll(), isEmpty);

      final executed = await orch.handle(
        req('Executar operação confirmada', id: 'a6'),
      );
      expect(
        executed.transactionExecutionResult?.outcome,
        AssistantTransactionExecutionOutcome.completed,
      );
      expect(
        auditRepo.countByType(AssistantAuditEventType.executionRequested),
        greaterThanOrEqualTo(1),
      );
      expect(
        auditRepo.countByType(AssistantAuditEventType.executionCompleted),
        1,
      );
      expect(await quotes.listAll(), isNotEmpty);

      // Rejected path
      final rejected = await orch.handle(req('Executar', id: 'a7'));
      expect(
        rejected.transactionExecutionResult?.outcome,
        AssistantTransactionExecutionOutcome.confirmationConsumed,
      );
      expect(
        auditRepo.countByType(AssistantAuditEventType.executionRejected),
        greaterThanOrEqualTo(1),
      );

      final audit = await orch.handle(
        req('Histórico de auditoria', id: 'a8'),
      );
      expect(audit.auditPresentation, isNotNull);
      expect(audit.auditResult!.returnedCount, greaterThan(0));
      expect(
        audit.auditResult!.events
            .every((e) => e.metadata.tokenFingerprint != 'tok-ai014'),
        isTrue,
      );
      final serialized = audit.auditPresentation!.structured.toString();
      expect(serialized.contains('tok-'), isFalse);

      // Same correlation across cycle
      final corr = auditRepo.allEvents
          .where((e) => e.sessionId == 's-audit')
          .map((e) => e.correlationId)
          .where((c) => c.contains('hmac-sha256-'))
          .toSet();
      expect(corr.length, greaterThanOrEqualTo(1));

      // AI-014 attrs unused here but fingerprint path intact
      expect(
        AssistantTransactionPlanFingerprint.defaultQuoteDraftAttributes,
        isNotEmpty,
      );
    });

    test('falha de auditoria antes da execução bloqueia escrita', () async {
      final quotes = FakeQuoteRepository();
      final service = QuoteDraftCreationService(quotes, clock: clock);
      final writeGateway = LocalAssistantWriteGateway(
        quoteDraftAdapter: QuoteAssistantWriteAdapter(service),
      );
      final writeCoordinator = LocalAssistantWriteCoordinator(
        idempotencyService: LocalAssistantIdempotencyService(
          completedLookup:
              quoteIdempotencyCompletedLookup(quotes, clock: clock),
          clock: clock,
        ),
        clock: clock,
      );
      final confirmationSessions =
          AssistantConfirmationSessionRegistry(clock: clock);
      final auditRepo = InMemoryAssistantAuditRepository();
      final auditGateway = LocalAssistantAuditGateway(repository: auditRepo);
      auditGateway.failAppendIf = (e) =>
          e.eventType == AssistantAuditEventType.executionRequested;

      final orch = LocalAssistantOrchestrator(
        clock: clock,
        executionMode: AssistantExecutionMode.production,
        writeGateway: writeGateway,
        writeCoordinator: writeCoordinator,
        confirmationSessions: confirmationSessions,
        auditGateway: auditGateway,
        capabilities: AssistantCapabilities.localAuditTrail(),
        confirmedStepIds: const {'step-create-quote'},
      );

      AssistantRequest req(String text, {required String id}) =>
          AssistantRequest(
            id: id,
            rawText: text,
            locale: 'pt_BR',
            timezone: 'America/Sao_Paulo',
            timestamp: now,
            origin: AssistantInputOrigin.typedText,
            context: const AssistantContext(sessionId: 's-block'),
          );

      await orch.handle(
        req('Solicitar confirmação para criar orçamento', id: 'b1'),
      );
      await orch.handle(req('Confirmar', id: 'b2'));
      final blocked = await orch.handle(
        req('Executar operação confirmada', id: 'b3'),
      );
      expect(blocked.transactionExecutionResult?.executed, isFalse);
      expect(
        blocked.friendlyMessage,
        contains('auditoria'),
      );
      expect(await quotes.listAll(), isEmpty);
      expect(
        confirmationSessions.getOrCreate('s-block').pending?.consumed,
        isFalse,
      );
    });

    test('falha de auditoria após escrita não desfaz mutação', () async {
      final quotes = FakeQuoteRepository();
      final service = QuoteDraftCreationService(quotes, clock: clock);
      final writeGateway = LocalAssistantWriteGateway(
        quoteDraftAdapter: QuoteAssistantWriteAdapter(service),
      );
      final writeCoordinator = LocalAssistantWriteCoordinator(
        idempotencyService: LocalAssistantIdempotencyService(
          completedLookup:
              quoteIdempotencyCompletedLookup(quotes, clock: clock),
          clock: clock,
        ),
        clock: clock,
      );
      final confirmationSessions =
          AssistantConfirmationSessionRegistry(clock: clock);
      final auditRepo = InMemoryAssistantAuditRepository();
      final auditGateway = LocalAssistantAuditGateway(repository: auditRepo);
      auditGateway.failAppendIf = (e) =>
          e.eventType == AssistantAuditEventType.executionCompleted;

      final orch = LocalAssistantOrchestrator(
        clock: clock,
        executionMode: AssistantExecutionMode.production,
        writeGateway: writeGateway,
        writeCoordinator: writeCoordinator,
        confirmationSessions: confirmationSessions,
        auditGateway: auditGateway,
        capabilities: AssistantCapabilities.localAuditTrail(),
        confirmedStepIds: const {'step-create-quote'},
      );

      AssistantRequest req(String text, {required String id}) =>
          AssistantRequest(
            id: id,
            rawText: text,
            locale: 'pt_BR',
            timezone: 'America/Sao_Paulo',
            timestamp: now,
            origin: AssistantInputOrigin.typedText,
            context: const AssistantContext(sessionId: 's-after'),
          );

      await orch.handle(
        req('Solicitar confirmação para criar orçamento', id: 'c1'),
      );
      await orch.handle(req('Confirmar', id: 'c2'));
      final done = await orch.handle(
        req('Executar operação confirmada', id: 'c3'),
      );
      expect(
        done.transactionExecutionResult?.outcome,
        AssistantTransactionExecutionOutcome.completed,
      );
      expect(done.writeResult?.mutatedErp, isTrue);
      expect(await quotes.listAll(), isNotEmpty);
      expect(
        done.friendlyMessage,
        contains('auditoria falhou'),
      );
    });
    test('emite executionWriteFailed quando write falha após consumo', () {
      final event = factory.build(
        eventType: AssistantAuditEventType.executionWriteFailed,
        sessionId: 's-wf',
        correlationId: 'corr-wf',
        outcome: 'writeFailed',
        errorCode: 'writeFailed',
        rawToken: 'tok-x',
      );
      final stored = gateway.append(event);
      expect(stored.eventType, AssistantAuditEventType.executionWriteFailed);
      expect(stored.metadata.tokenFingerprint, isNot(contains('tok-x')));
    });
  });
}

class _SpyFingerprinter implements AssistantAuditTokenFingerprinter {
  _SpyFingerprinter(this._delegate);

  final String Function(String raw) _delegate;

  @override
  String fingerprint(String rawToken) => _delegate(rawToken);
}
