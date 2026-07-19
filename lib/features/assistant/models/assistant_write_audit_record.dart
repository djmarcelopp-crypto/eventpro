import 'assistant_confirmation_status.dart';
import 'assistant_execution_mode.dart';
import 'assistant_execution_token.dart';
import 'assistant_write_authorization_status.dart';
import 'assistant_write_failure.dart';
import 'assistant_write_idempotency_status.dart';
import 'assistant_write_operation.dart';
import 'assistant_write_target.dart';
import 'assistant_write_transaction_status.dart';

/// Audit record for a controlled write attempt (no sensitive payload).
class AssistantWriteAuditRecord {
  const AssistantWriteAuditRecord({
    required this.startedAt,
    required this.finishedAt,
    required this.executionToken,
    required this.idempotencyFingerprint,
    required this.operation,
    required this.target,
    required this.mode,
    required this.confirmationStatus,
    required this.authorizationStatus,
    required this.adapterName,
    required this.transactionStatus,
    required this.idempotencyStatus,
    required this.executed,
    required this.mutatedErp,
    this.createdDraftId,
    this.rollbackAttempted = false,
    this.rollbackSucceeded = false,
    this.failure,
    this.warnings = const [],
  });

  final DateTime startedAt;
  final DateTime finishedAt;
  final AssistantExecutionToken executionToken;
  final String idempotencyFingerprint;
  final AssistantWriteOperation operation;
  final AssistantWriteTarget target;
  final AssistantExecutionMode mode;
  final AssistantConfirmationStatus confirmationStatus;
  final AssistantWriteAuthorizationStatus authorizationStatus;
  final String adapterName;
  final AssistantWriteTransactionStatus transactionStatus;
  final AssistantWriteIdempotencyStatus idempotencyStatus;
  final bool executed;
  final bool mutatedErp;
  final String? createdDraftId;
  final bool rollbackAttempted;
  final bool rollbackSucceeded;
  final AssistantWriteFailure? failure;
  final List<String> warnings;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantWriteAuditRecord &&
            other.startedAt == startedAt &&
            other.finishedAt == finishedAt &&
            other.executionToken == executionToken &&
            other.idempotencyFingerprint == idempotencyFingerprint &&
            other.operation == operation &&
            other.target == target &&
            other.mode == mode &&
            other.confirmationStatus == confirmationStatus &&
            other.authorizationStatus == authorizationStatus &&
            other.adapterName == adapterName &&
            other.transactionStatus == transactionStatus &&
            other.idempotencyStatus == idempotencyStatus &&
            other.executed == executed &&
            other.mutatedErp == mutatedErp &&
            other.createdDraftId == createdDraftId &&
            other.rollbackAttempted == rollbackAttempted &&
            other.rollbackSucceeded == rollbackSucceeded &&
            other.failure == failure;
  }

  @override
  int get hashCode => Object.hash(
        startedAt,
        finishedAt,
        executionToken,
        idempotencyFingerprint,
        operation,
        target,
        mode,
        confirmationStatus,
        authorizationStatus,
        adapterName,
        transactionStatus,
        idempotencyStatus,
        executed,
        mutatedErp,
        createdDraftId,
        Object.hash(rollbackAttempted, rollbackSucceeded, failure),
      );
}
