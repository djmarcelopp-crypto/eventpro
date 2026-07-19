import 'package:eventpro/features/assistant/models/assistant_confirmation_status.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_token.dart';
import 'package:eventpro/features/assistant/models/assistant_idempotency_status.dart';
import 'package:eventpro/features/assistant/models/assistant_write_audit_record.dart';
import 'package:eventpro/features/assistant/models/assistant_write_authorization_status.dart';
import 'package:eventpro/features/assistant/models/assistant_write_entity_state.dart';
import 'package:eventpro/features/assistant/models/assistant_write_failure_code.dart';
import 'package:eventpro/features/assistant/models/assistant_write_idempotency_key.dart';
import 'package:eventpro/features/assistant/models/assistant_write_idempotency_status.dart';
import 'package:eventpro/features/assistant/models/assistant_write_operation.dart';
import 'package:eventpro/features/assistant/models/assistant_write_outcome_category.dart';
import 'package:eventpro/features/assistant/models/assistant_write_target.dart';
import 'package:eventpro/features/assistant/models/assistant_write_transaction_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-007 CP-D write audit hardening', () {
    final started = DateTime.utc(2026, 7, 19, 10);
    final finished = DateTime.utc(2026, 7, 19, 10, 0, 0, 35);
    const key = AssistantWriteIdempotencyKey('raw-secret-key');

    AssistantWriteAuditRecord build({
      AssistantWriteOutcomeCategory outcome =
          AssistantWriteOutcomeCategory.success,
      AssistantIdempotencyStatus? lifecycle = AssistantIdempotencyStatus.completed,
      bool rollbackAttempted = false,
      bool rollbackSucceeded = false,
      String? draftId = 'asst-quote-abc',
      AssistantWriteFailureCode? failureCode,
      List<String> warnings = const ['z-warn', 'a-warn'],
    }) {
      return AssistantWriteAuditRecord(
        correlationId: 'corr-1',
        requestId: 'req-1',
        executionId: 'tok-1',
        executionToken: const AssistantExecutionToken('tok-1'),
        idempotencyFingerprint: key.auditFingerprint,
        lifecycleIdempotencyStatus: lifecycle,
        writeIdempotencyStatus: AssistantWriteIdempotencyStatus.firstExecution,
        operation: AssistantWriteOperation.create,
        target: AssistantWriteTarget.quote,
        requestedState: AssistantWriteEntityState.draft,
        resultingState: draftId == null ? null : AssistantWriteEntityState.draft,
        executionMode: AssistantExecutionMode.production,
        policyName: 'QuoteDraftProductionPolicy',
        adapterName: 'QuoteAssistantWriteAdapter',
        authorizationStatus: AssistantWriteAuthorizationStatus.authorized,
        confirmationStatus: AssistantConfirmationStatus.providedValid,
        startedAt: started,
        finishedAt: finished,
        durationMs: 35,
        outcome: outcome,
        transactionStatus: AssistantWriteTransactionStatus.committed,
        failureCode: failureCode,
        createdDraftId: draftId,
        executed: outcome == AssistantWriteOutcomeCategory.success ||
            outcome == AssistantWriteOutcomeCategory.idempotentReplay,
        mutatedErp: outcome == AssistantWriteOutcomeCategory.success,
        rollbackAttempted: rollbackAttempted,
        rollbackSucceeded: rollbackSucceeded,
        warnings: warnings,
      );
    }

    test('serialização determinística e ordem estável de warnings', () {
      final a = build().toDeterministicMap();
      final b = build().toDeterministicMap();
      expect(a, b);
      expect(a['warnings'], ['a-warn', 'z-warn']);
      expect(a.keys.toList(), build().toDeterministicMap().keys.toList());
    });

    test('correlation/request/execution IDs preservados', () {
      final map = build().toDeterministicMap();
      expect(map['correlationId'], 'corr-1');
      expect(map['requestId'], 'req-1');
      expect(map['executionId'], 'tok-1');
      expect(map['executionToken'], 'tok-1');
    });

    test('sucesso / bloqueio / duplicidade / timeout incerto / rollback', () {
      expect(
        build(outcome: AssistantWriteOutcomeCategory.success)
            .toDeterministicMap()['outcome'],
        'success',
      );
      expect(
        build(
          outcome: AssistantWriteOutcomeCategory.blocked,
          draftId: null,
          lifecycle: null,
          failureCode: AssistantWriteFailureCode.productionNotAllowed,
        ).toDeterministicMap()['outcome'],
        'blocked',
      );
      expect(
        build(
          outcome: AssistantWriteOutcomeCategory.idempotentReplay,
          lifecycle: AssistantIdempotencyStatus.completed,
        ).toDeterministicMap()['outcome'],
        'idempotentReplay',
      );
      final uncertain = build(
        outcome: AssistantWriteOutcomeCategory.uncertain,
        lifecycle: AssistantIdempotencyStatus.uncertain,
        draftId: null,
        failureCode: AssistantWriteFailureCode.uncertainOutcome,
      ).toDeterministicMap();
      expect(uncertain['outcome'], 'uncertain');
      expect(uncertain['lifecycleIdempotencyStatus'], 'uncertain');
      expect(uncertain['outcome'], isNot('failed'));

      final rollbackOk = build(
        outcome: AssistantWriteOutcomeCategory.rollback,
        rollbackAttempted: true,
        rollbackSucceeded: true,
        draftId: null,
        failureCode: AssistantWriteFailureCode.rollbackFailure,
      ).toDeterministicMap();
      expect(rollbackOk['rollbackAttempted'], isTrue);
      expect(rollbackOk['rollbackSucceeded'], isTrue);

      final rollbackFail = build(
        outcome: AssistantWriteOutcomeCategory.rollback,
        rollbackAttempted: true,
        rollbackSucceeded: false,
        draftId: null,
      ).toDeterministicMap();
      expect(rollbackFail['rollbackSucceeded'], isFalse);
    });

    test('sem chave bruta nem payload sensível; draft id só quando conhecido', () {
      final map = build().toDeterministicMap().toString();
      expect(map, isNot(contains('raw-secret-key')));
      expect(map, isNot(contains('clientDisplayName')));
      expect(build(draftId: null).toDeterministicMap()['createdDraftId'], isNull);
      expect(
        build(draftId: 'asst-quote-1').toDeterministicMap()['createdDraftId'],
        'asst-quote-1',
      );
    });

    test('rollbackSucceeded exige rollbackAttempted', () {
      final map = build(
        rollbackAttempted: false,
        rollbackSucceeded: true,
      ).toDeterministicMap();
      expect(map['rollbackSucceeded'], isFalse);
    });
  });
}
