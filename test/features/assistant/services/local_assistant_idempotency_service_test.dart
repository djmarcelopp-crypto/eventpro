import 'package:eventpro/features/assistant/models/assistant_idempotency_record.dart';
import 'package:eventpro/features/assistant/models/assistant_idempotency_result.dart';
import 'package:eventpro/features/assistant/models/assistant_idempotency_status.dart';
import 'package:eventpro/features/assistant/models/assistant_write_failure_code.dart';
import 'package:eventpro/features/assistant/models/assistant_write_idempotency_key.dart';
import 'package:eventpro/features/assistant/services/local_assistant_idempotency_service.dart';
import 'package:eventpro/features/assistant/services/local_assistant_idempotency_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-007 CP-A idempotency service', () {
    final now = DateTime(2026, 7, 19, 16);
    late LocalAssistantIdempotencyStore store;
    late LocalAssistantIdempotencyService service;

    setUp(() {
      store = LocalAssistantIdempotencyStore();
      service = LocalAssistantIdempotencyService(
        store: store,
        clock: () => now,
      );
    });

    const key = AssistantWriteIdempotencyKey('idem-a');
    const other = AssistantWriteIdempotencyKey('idem-b');

    test('begin cria pending e complete armazena resultado', () async {
      final began = await service.begin(key);
      expect(began.decision, AssistantIdempotencyBeginDecision.proceed);
      expect(began.record.status, AssistantIdempotencyStatus.pending);
      expect(began.record.fingerprint, key.auditFingerprint);
      expect(began.record.toString(), isNot(contains('idem-a')));

      final completed = await service.complete(
        key,
        draftId: key.derivedDraftId,
        draftNumber: 'ORC-2026-0001',
        mutatedErp: true,
      );
      expect(completed.status, AssistantIdempotencyStatus.completed);
      expect(completed.resultDraftId, key.derivedDraftId);
    });

    test('fail e uncertain', () async {
      await service.begin(key);
      final failed = await service.fail(
        key,
        code: AssistantWriteFailureCode.serviceFailure,
        message: 'boom',
      );
      expect(failed.status, AssistantIdempotencyStatus.failed);

      await service.begin(other);
      final uncertain = await service.markUncertain(
        other,
        message: 'timeout',
      );
      expect(uncertain.status, AssistantIdempotencyStatus.uncertain);
      expect(uncertain.failureCode, AssistantWriteFailureCode.uncertainOutcome);
    });

    test('repetição após completed recupera resultado', () async {
      await service.begin(key);
      await service.complete(
        key,
        draftId: 'draft-1',
        draftNumber: 'ORC-1',
        mutatedErp: true,
      );
      final again = await service.begin(key);
      expect(again.decision, AssistantIdempotencyBeginDecision.replayCompleted);
      expect(again.record.resultDraftId, 'draft-1');
      expect(again.mayMutate, isFalse);
    });

    test('duas chamadas concorrentes não geram duas mutações', () async {
      final firstFuture = service.begin(key);
      final first = await firstFuture;
      expect(first.decision, AssistantIdempotencyBeginDecision.proceed);

      final secondFuture = service.begin(key);
      await service.complete(
        key,
        draftId: 'd-1',
        mutatedErp: true,
      );
      final second = await secondFuture;
      expect(second.mayMutate, isFalse);
      expect(
        second.decision,
        anyOf(
          AssistantIdempotencyBeginDecision.replayCompleted,
          AssistantIdempotencyBeginDecision.blockedPending,
        ),
      );

      final after = await service.begin(key);
      expect(after.decision, AssistantIdempotencyBeginDecision.replayCompleted);
    });

    test('chave diferente permanece independente', () async {
      await service.begin(key);
      await service.begin(other);
      await service.complete(key, draftId: 'a', mutatedErp: true);
      final stillPending = await service.findByKey(other);
      expect(stillPending?.status, AssistantIdempotencyStatus.pending);
    });

    test('chave bruta não aparece no record', () async {
      final began = await service.begin(key);
      final jsonish =
          '${began.record.fingerprint}|${began.record.derivedResourceId}|${began.record.status}';
      expect(jsonish, isNot(contains(key.value)));
      expect(key.toString(), 'AssistantWriteIdempotencyKey(*)');
    });

    test('completedLookup recupera Draft AI-006', () async {
      final lookupService = LocalAssistantIdempotencyService(
        store: LocalAssistantIdempotencyStore(),
        clock: () => now,
        completedLookup: (k) async {
          if (k.auditFingerprint == key.auditFingerprint) {
            return AssistantIdempotencyRecord.fromKey(
              key: k,
              status: AssistantIdempotencyStatus.completed,
              updatedAt: now,
              resultDraftId: k.derivedDraftId,
              resultDraftNumber: 'ORC-LEGACY',
              executed: true,
              mutatedErp: false,
            );
          }
          return null;
        },
      );
      final result = await lookupService.begin(key);
      expect(result.decision, AssistantIdempotencyBeginDecision.replayCompleted);
      expect(result.record.resultDraftNumber, 'ORC-LEGACY');
    });

    test('uncertain bloqueia nova mutação até recovery', () async {
      await service.begin(key);
      await service.markUncertain(key, message: 'timeout');
      final again = await service.begin(key);
      expect(again.decision, AssistantIdempotencyBeginDecision.blockedUncertain);
      expect(again.mayMutate, isFalse);
    });

    test('repetição após pending não executa novamente', () async {
      // Simula claim órfão / outro isolado: store compartilhada, sem inflight local.
      final shared = LocalAssistantIdempotencyStore();
      final holder = LocalAssistantIdempotencyService(
        store: shared,
        clock: () => now,
      );
      final other = LocalAssistantIdempotencyService(
        store: shared,
        clock: () => now,
      );
      final first = await holder.begin(key);
      expect(first.mayMutate, isTrue);
      final second = await other.begin(key);
      expect(second.mayMutate, isFalse);
      expect(
        second.decision,
        AssistantIdempotencyBeginDecision.blockedPending,
      );
    });

    test('falha permite retry explícito', () async {
      await service.begin(key);
      await service.fail(
        key,
        code: AssistantWriteFailureCode.serviceFailure,
        message: 'boom',
      );
      final retry = await service.begin(key);
      expect(retry.decision, AssistantIdempotencyBeginDecision.proceed);
      expect(retry.mayMutate, isTrue);
    });
  });
}
