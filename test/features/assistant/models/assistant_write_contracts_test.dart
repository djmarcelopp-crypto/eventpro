import 'package:eventpro/features/assistant/domain/write/assistant_write_adapter.dart';
import 'package:eventpro/features/assistant/domain/write/assistant_write_gateway.dart';
import 'package:eventpro/features/assistant/domain/write/assistant_write_transaction.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_context.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_token.dart';
import 'package:eventpro/features/assistant/models/assistant_integration_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_write_adapter_result.dart';
import 'package:eventpro/features/assistant/models/assistant_write_capability.dart';
import 'package:eventpro/features/assistant/models/assistant_write_entity_state.dart';
import 'package:eventpro/features/assistant/models/assistant_write_failure_code.dart';
import 'package:eventpro/features/assistant/models/assistant_write_idempotency_key.dart';
import 'package:eventpro/features/assistant/models/assistant_write_operation.dart';
import 'package:eventpro/features/assistant/models/assistant_write_payload.dart';
import 'package:eventpro/features/assistant/models/assistant_write_request.dart';
import 'package:eventpro/features/assistant/models/assistant_write_result.dart';
import 'package:eventpro/features/assistant/models/assistant_write_target.dart';
import 'package:eventpro/features/assistant/models/assistant_write_transaction_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-006 CP-A write contracts', () {
    final context = AssistantExecutionContext(
      requestId: 'req-1',
      token: const AssistantExecutionToken('tok-1'),
      mode: AssistantExecutionMode.dryRun,
      integrationMode: AssistantIntegrationMode.none,
      timestamp: DateTime(2026, 7, 19),
    );

    AssistantWritePayload quoteDraftPayload() => const AssistantWritePayload(
          operation: AssistantWriteOperation.create,
          target: AssistantWriteTarget.quote,
          requestedState: AssistantWriteEntityState.draft,
          clientDisplayName: 'Cliente Demo',
          lineItemName: 'Som',
          lineItemUnitPriceCents: '10000',
        );

    test('contratos e invariantes AI-006 quote draft', () {
      final payload = quoteDraftPayload();
      expect(payload.isSupportedAi006QuoteDraft, isTrue);
      expect(
        AssistantWriteEntityState.values,
        contains(AssistantWriteEntityState.draft),
      );
      expect(
        AssistantWriteEntityState.values,
        containsAll([
          AssistantWriteEntityState.sent,
          AssistantWriteEntityState.approved,
          AssistantWriteEntityState.cancelled,
        ]),
      );
      expect(
        AssistantWriteFailureCode.values,
        containsAll([
          AssistantWriteFailureCode.validationDenied,
          AssistantWriteFailureCode.duplicateOperation,
          AssistantWriteFailureCode.uncertainOutcome,
        ]),
      );
      expect(AssistantWriteGateway, isNotNull);
      expect(AssistantWriteAdapter, isNotNull);
    });

    test('imutabilidade de transaction e key', () {
      const key = AssistantWriteIdempotencyKey('idem-1');
      final request = AssistantWriteRequest(
        id: 'wr-1',
        requestId: 'req-1',
        operation: AssistantWriteOperation.create,
        target: AssistantWriteTarget.quote,
        capability: AssistantWriteCapability.createQuote,
        idempotencyKey: key,
        requestedState: AssistantWriteEntityState.draft,
      );
      final tx = AssistantWriteTransaction(
        id: 'tx-1',
        request: request,
        payload: quoteDraftPayload(),
        context: context,
        idempotencyKey: key,
      );
      final mutated = tx.copyWith(status: AssistantWriteTransactionStatus.prepared);
      expect(identical(tx, mutated), isFalse);
      expect(tx.status, AssistantWriteTransactionStatus.pending);
      expect(key.derivedDraftId, startsWith('asst-quote-'));
      expect(key.auditFingerprint.length, 8);
    });

    test('operação não suportada / target inválido / estado', () {
      expect(
        const AssistantWritePayload(
          operation: AssistantWriteOperation.update,
          target: AssistantWriteTarget.quote,
          requestedState: AssistantWriteEntityState.draft,
        ).isSupportedAi006QuoteDraft,
        isFalse,
      );
      expect(
        const AssistantWritePayload(
          operation: AssistantWriteOperation.create,
          target: AssistantWriteTarget.event,
          requestedState: AssistantWriteEntityState.draft,
        ).isSupportedAi006QuoteDraft,
        isFalse,
      );
      expect(AssistantWriteOperation.delete, isNotNull);
      expect(AssistantWriteOperation.cancel, isNotNull);
    });

    test('ausência de idempotency key é inválida', () {
      const empty = AssistantWriteIdempotencyKey('   ');
      expect(empty.isValid, isFalse);
      const ok = AssistantWriteIdempotencyKey('k-1');
      expect(ok.isValid, isTrue);
      expect(ok.derivedDraftId, ok.derivedDraftId);
    });

    test('executed permanece false até gateway (resultado padrão)', () {
      const result = AssistantWriteResult(
        id: 'wres-1',
        requestId: 'req-1',
        operation: AssistantWriteOperation.create,
        target: AssistantWriteTarget.quote,
        capability: AssistantWriteCapability.createQuote,
        accepted: true,
        summary: 'prepared',
      );
      expect(result.executed, isFalse);
      expect(
        AssistantWriteAdapterResult.skipped(summary: 'dry-run').executed,
        isFalse,
      );
      expect(
        AssistantWriteAdapterResult.skipped(summary: 'dry-run').mutatedErp,
        isFalse,
      );
    });
  });
}
