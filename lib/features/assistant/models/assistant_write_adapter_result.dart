import 'assistant_write_entity_state.dart';
import 'assistant_write_failure.dart';
import 'assistant_write_idempotency_status.dart';
import 'assistant_write_transaction_status.dart';

/// Typed outcome from an [AssistantWriteAdapter] — no ERP entities exposed.
class AssistantWriteAdapterResult {
  const AssistantWriteAdapterResult({
    required this.transactionStatus,
    required this.idempotencyStatus,
    required this.executed,
    required this.mutatedErp,
    this.draftId,
    this.draftNumber,
    this.resultingState,
    this.failure,
    this.rollbackAttempted = false,
    this.rollbackSucceeded = false,
    this.summary = '',
    this.warnings = const [],
  });

  final AssistantWriteTransactionStatus transactionStatus;
  final AssistantWriteIdempotencyStatus idempotencyStatus;
  final bool executed;
  final bool mutatedErp;
  final String? draftId;
  final String? draftNumber;
  final AssistantWriteEntityState? resultingState;
  final AssistantWriteFailure? failure;
  final bool rollbackAttempted;
  final bool rollbackSucceeded;
  final String summary;
  final List<String> warnings;

  factory AssistantWriteAdapterResult.skipped({
    required String summary,
    AssistantWriteFailure? failure,
    List<String> warnings = const [],
  }) {
    return AssistantWriteAdapterResult(
      transactionStatus: AssistantWriteTransactionStatus.skipped,
      idempotencyStatus: AssistantWriteIdempotencyStatus.notApplicable,
      executed: false,
      mutatedErp: false,
      failure: failure,
      summary: summary,
      warnings: warnings,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantWriteAdapterResult &&
            other.transactionStatus == transactionStatus &&
            other.idempotencyStatus == idempotencyStatus &&
            other.executed == executed &&
            other.mutatedErp == mutatedErp &&
            other.draftId == draftId &&
            other.draftNumber == draftNumber &&
            other.resultingState == resultingState &&
            other.failure == failure &&
            other.rollbackAttempted == rollbackAttempted &&
            other.rollbackSucceeded == rollbackSucceeded &&
            other.summary == summary;
  }

  @override
  int get hashCode => Object.hash(
        transactionStatus,
        idempotencyStatus,
        executed,
        mutatedErp,
        draftId,
        draftNumber,
        resultingState,
        failure,
        rollbackAttempted,
        rollbackSucceeded,
        summary,
      );
}
