import 'dart:async';

import '../../assistant/domain/write/assistant_write_adapter.dart';
import '../../assistant/domain/write/assistant_write_transaction.dart';
import '../../assistant/models/assistant_write_adapter_result.dart';
import '../../assistant/models/assistant_write_entity_state.dart';
import '../../assistant/models/assistant_write_failure.dart';
import '../../assistant/models/assistant_write_failure_code.dart';
import '../../assistant/models/assistant_write_idempotency_status.dart';
import '../../assistant/models/assistant_write_operation.dart';
import '../../assistant/models/assistant_write_payload.dart';
import '../../assistant/models/assistant_write_target.dart';
import '../../assistant/models/assistant_write_transaction_status.dart';
import '../models/quote.dart';
import '../models/quote_client_snapshot.dart';
import '../models/quote_client_type.dart';
import '../models/quote_event_snapshot.dart';
import '../models/quote_line_item.dart';
import '../models/quote_status.dart';
import '../utils/quote_draft_creation_service.dart';

/// ERP write adapter for AI-006: create quote draft only.
///
/// Lives in the quotes module and depends on assistant contracts (hexagonal).
/// Calls only [QuoteDraftCreationService] — never DAO/SQL directly.
class QuoteAssistantWriteAdapter implements AssistantWriteAdapter {
  QuoteAssistantWriteAdapter(
    this._service, {
    Duration timeout = const Duration(seconds: 8),
  }) : _timeout = timeout;

  final QuoteDraftCreationService _service;
  final Duration _timeout;

  @override
  String get name => 'QuoteAssistantWriteAdapter';

  @override
  bool supports(AssistantWriteTransaction transaction) {
    final payload = transaction.payload;
    return payload.operation == AssistantWriteOperation.create &&
        payload.target == AssistantWriteTarget.quote &&
        payload.requestedState == AssistantWriteEntityState.draft &&
        transaction.idempotencyKey.isValid;
  }

  @override
  Future<AssistantWriteAdapterResult> execute(
    AssistantWriteTransaction transaction,
  ) async {
    if (!supports(transaction)) {
      final failure = _unsupportedFailure(transaction.payload);
      return AssistantWriteAdapterResult.skipped(
        summary: failure.message,
        failure: failure,
      );
    }

    final draft = _toQuoteDraft(transaction);
    try {
      final outcome = await _service.createDraft(draft).timeout(_timeout);
      if (!outcome.success || outcome.quote == null) {
        return AssistantWriteAdapterResult(
          transactionStatus: AssistantWriteTransactionStatus.failed,
          idempotencyStatus: AssistantWriteIdempotencyStatus.firstExecution,
          executed: false,
          mutatedErp: false,
          rollbackAttempted: outcome.rolledBack,
          rollbackSucceeded: outcome.rolledBack,
          failure: AssistantWriteFailure(
            code: AssistantWriteFailureCode.serviceFailure,
            message: outcome.errorMessage ?? 'Falha no serviço de orçamento',
          ),
          summary: outcome.errorMessage ?? 'Falha ao criar rascunho',
        );
      }

      final quote = outcome.quote!;
      return AssistantWriteAdapterResult(
        transactionStatus: AssistantWriteTransactionStatus.committed,
        idempotencyStatus: outcome.idempotentReplay
            ? AssistantWriteIdempotencyStatus.replayed
            : AssistantWriteIdempotencyStatus.firstExecution,
        executed: true,
        mutatedErp: !outcome.idempotentReplay,
        draftId: quote.id,
        draftNumber: quote.number,
        resultingState: AssistantWriteEntityState.draft,
        summary: outcome.idempotentReplay
            ? 'Rascunho de orçamento já existia (idempotente): ${quote.number}'
            : 'Rascunho de orçamento criado: ${quote.number}',
        warnings: const [
          'Orçamento em Draft — nenhuma aprovação, envio ou faturamento ocorreu',
        ],
      );
    } on TimeoutException {
      return const AssistantWriteAdapterResult(
        transactionStatus: AssistantWriteTransactionStatus.uncertain,
        idempotencyStatus: AssistantWriteIdempotencyStatus.firstExecution,
        executed: false,
        mutatedErp: false,
        failure: AssistantWriteFailure(
          code: AssistantWriteFailureCode.timeout,
          message:
              'Timeout ao criar rascunho — consulte idempotência antes de repetir',
          retryable: false,
          uncertain: true,
        ),
        summary: 'Resultado incerto por timeout',
      );
    } on Exception catch (error) {
      return AssistantWriteAdapterResult(
        transactionStatus: AssistantWriteTransactionStatus.failed,
        idempotencyStatus: AssistantWriteIdempotencyStatus.firstExecution,
        executed: false,
        mutatedErp: false,
        failure: AssistantWriteFailure(
          code: AssistantWriteFailureCode.serviceFailure,
          message: 'Erro no adapter: $error',
        ),
        summary: 'Falha no adapter de orçamento',
      );
    }
  }

  Quote _toQuoteDraft(AssistantWriteTransaction transaction) {
    final payload = transaction.payload;
    final quantity = double.tryParse(payload.lineItemQuantity) ?? 1;
    final unitPrice = int.tryParse(payload.lineItemUnitPriceCents) ?? 0;
    final lineTotal = (quantity * unitPrice).round();
    final clientType = payload.clientType == 'company'
        ? QuoteClientType.company
        : QuoteClientType.individual;

    return Quote(
      id: transaction.idempotencyKey.derivedDraftId,
      number: 'IGNORED',
      status: QuoteStatus.draft,
      clientSnapshot: QuoteClientSnapshot(
        type: clientType,
        displayName: payload.clientDisplayName.trim().isEmpty
            ? 'Cliente (assistente)'
            : payload.clientDisplayName.trim(),
      ),
      eventSnapshot: QuoteEventSnapshot(
        name: payload.attributes['eventName'],
        type: payload.attributes['eventType'],
        guestCount: int.tryParse(payload.attributes['guestCount'] ?? ''),
      ),
      items: [
        QuoteLineItem(
          name: payload.lineItemName.trim().isEmpty
              ? 'Item (assistente)'
              : payload.lineItemName.trim(),
          unit: payload.lineItemUnit.trim().isEmpty ? 'un' : payload.lineItemUnit,
          quantity: quantity <= 0 ? 1 : quantity,
          unitPriceCents: unitPrice < 0 ? 0 : unitPrice,
          lineTotalCents: lineTotal < 0 ? 0 : lineTotal,
        ),
      ],
      subtotalCents: 0,
      discountCents: 0,
      freightCents: 0,
      totalCents: 0,
      statusHistory: const [],
      notes: payload.notes.isEmpty ? null : payload.notes,
      createdAt: transaction.context.timestamp,
      updatedAt: transaction.context.timestamp,
    );
  }

  AssistantWriteFailure _unsupportedFailure(AssistantWritePayload payload) {
    if (payload.operation != AssistantWriteOperation.create) {
      return const AssistantWriteFailure(
        code: AssistantWriteFailureCode.unsupportedOperation,
        message: 'Somente create é suportado no adapter de orçamento',
      );
    }
    if (payload.target != AssistantWriteTarget.quote) {
      return const AssistantWriteFailure(
        code: AssistantWriteFailureCode.unsupportedTarget,
        message: 'Somente target quote é suportado',
      );
    }
    if (payload.requestedState != AssistantWriteEntityState.draft) {
      return const AssistantWriteFailure(
        code: AssistantWriteFailureCode.invalidDraftState,
        message: 'Somente estado Draft é suportado',
      );
    }
    return const AssistantWriteFailure(
      code: AssistantWriteFailureCode.validationDenied,
      message: 'Payload não suportado pelo QuoteAssistantWriteAdapter',
    );
  }
}
