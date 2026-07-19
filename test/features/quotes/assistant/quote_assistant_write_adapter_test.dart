import 'package:eventpro/features/assistant/domain/write/assistant_write_transaction.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_context.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_token.dart';
import 'package:eventpro/features/assistant/models/assistant_integration_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_write_capability.dart';
import 'package:eventpro/features/assistant/models/assistant_write_entity_state.dart';
import 'package:eventpro/features/assistant/models/assistant_write_failure_code.dart';
import 'package:eventpro/features/assistant/models/assistant_write_idempotency_key.dart';
import 'package:eventpro/features/assistant/models/assistant_write_idempotency_status.dart';
import 'package:eventpro/features/assistant/models/assistant_write_operation.dart';
import 'package:eventpro/features/assistant/models/assistant_write_payload.dart';
import 'package:eventpro/features/assistant/models/assistant_write_request.dart';
import 'package:eventpro/features/assistant/models/assistant_write_target.dart';
import 'package:eventpro/features/quotes/assistant/quote_assistant_write_adapter.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/utils/quote_draft_creation_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_quote_repository.dart';

void main() {
  group('AI-006 CP-B QuoteAssistantWriteAdapter', () {
    final now = DateTime(2026, 7, 19, 12);
    late FakeQuoteRepository repository;
    late QuoteDraftCreationService service;
    late QuoteAssistantWriteAdapter adapter;

    setUp(() {
      repository = FakeQuoteRepository();
      service = QuoteDraftCreationService(repository, clock: () => now);
      adapter = QuoteAssistantWriteAdapter(service);
    });

    AssistantWriteTransaction tx({
      AssistantWriteOperation operation = AssistantWriteOperation.create,
      AssistantWriteTarget target = AssistantWriteTarget.quote,
      AssistantWriteEntityState state = AssistantWriteEntityState.draft,
      String key = 'idem-quote-1',
      String client = 'Maria',
      String item = 'Som',
    }) {
      const idem = AssistantWriteIdempotencyKey('idem-quote-1');
      final payload = AssistantWritePayload(
        operation: operation,
        target: target,
        requestedState: state,
        clientDisplayName: client,
        lineItemName: item,
        lineItemUnitPriceCents: '150000',
      );
      return AssistantWriteTransaction(
        id: 'tx-1',
        request: AssistantWriteRequest(
          id: 'wr-1',
          requestId: 'req-1',
          operation: operation,
          target: target,
          capability: AssistantWriteCapability.createQuote,
          idempotencyKey: AssistantWriteIdempotencyKey(key),
          requestedState: state,
        ),
        payload: payload,
        context: AssistantExecutionContext(
          requestId: 'req-1',
          token: const AssistantExecutionToken('tok-1'),
          mode: AssistantExecutionMode.production,
          integrationMode: AssistantIntegrationMode.none,
          timestamp: now,
        ),
        idempotencyKey: AssistantWriteIdempotencyKey(key),
      );
    }

    test('traduz payload e força Draft', () async {
      final result = await adapter.execute(tx());
      expect(result.executed, isTrue);
      expect(result.mutatedErp, isTrue);
      expect(result.resultingState, AssistantWriteEntityState.draft);
      expect(result.draftId, startsWith('asst-quote-'));
      expect(result.draftNumber, startsWith('ORC-'));
      final stored = await repository.findById(result.draftId!);
      expect(stored!.status, QuoteStatus.draft);
      expect(stored.clientSnapshot.displayName, 'Maria');
    });

    test('sucesso e erro do serviço', () async {
      expect((await adapter.execute(tx())).executed, isTrue);
      repository.shouldFailOnNextOperation = true;
      final failed = await adapter.execute(tx(key: 'idem-other'));
      expect(failed.executed, isFalse);
      expect(failed.failure?.code, AssistantWriteFailureCode.serviceFailure);
      expect(failed.rollbackSucceeded, isTrue);
    });

    test('nenhuma chamada quando target/operação inválidos', () async {
      final before = (await repository.listAll()).length;
      final event = await adapter.execute(tx(target: AssistantWriteTarget.event));
      final update =
          await adapter.execute(tx(operation: AssistantWriteOperation.update));
      expect(event.executed, isFalse);
      expect(update.executed, isFalse);
      expect((await repository.listAll()).length, before);
      expect(event.failure?.code, AssistantWriteFailureCode.unsupportedTarget);
    });

    test('idempotência por chave — um único Draft', () async {
      final first = await adapter.execute(tx());
      final second = await adapter.execute(tx());
      expect(first.draftId, second.draftId);
      expect(second.idempotencyStatus, AssistantWriteIdempotencyStatus.replayed);
      expect(second.mutatedErp, isFalse);
      expect((await repository.listAll()).length, 1);
    });
  });
}
