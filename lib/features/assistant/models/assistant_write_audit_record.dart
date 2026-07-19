import 'assistant_confirmation_status.dart';
import 'assistant_execution_mode.dart';
import 'assistant_execution_token.dart';
import 'assistant_idempotency_status.dart';
import 'assistant_write_authorization_status.dart';
import 'assistant_write_entity_state.dart';
import 'assistant_write_failure_code.dart';
import 'assistant_write_idempotency_status.dart';
import 'assistant_write_operation.dart';
import 'assistant_write_outcome_category.dart';
import 'assistant_write_target.dart';
import 'assistant_write_transaction_status.dart';

/// Authoritative, deterministic audit record for a controlled write attempt.
///
/// Distinct from [AssistantWriteObservation] (metrics) and from raw execution
/// plan audit ([AssistantExecutionAudit]).
class AssistantWriteAuditRecord {
  const AssistantWriteAuditRecord({
    required this.correlationId,
    required this.requestId,
    required this.executionId,
    required this.executionToken,
    required this.idempotencyFingerprint,
    required this.lifecycleIdempotencyStatus,
    required this.writeIdempotencyStatus,
    required this.operation,
    required this.target,
    required this.requestedState,
    required this.executionMode,
    required this.policyName,
    required this.adapterName,
    required this.authorizationStatus,
    required this.confirmationStatus,
    required this.startedAt,
    required this.finishedAt,
    required this.durationMs,
    required this.outcome,
    required this.transactionStatus,
    required this.executed,
    required this.mutatedErp,
    this.resultingState,
    this.failureCode,
    this.createdDraftId,
    this.rollbackAttempted = false,
    this.rollbackSucceeded = false,
    this.warnings = const [],
  });

  final String correlationId;
  final String requestId;
  final String executionId;
  final AssistantExecutionToken executionToken;
  final String idempotencyFingerprint;
  final AssistantIdempotencyStatus? lifecycleIdempotencyStatus;
  final AssistantWriteIdempotencyStatus writeIdempotencyStatus;
  final AssistantWriteOperation operation;
  final AssistantWriteTarget target;
  final AssistantWriteEntityState requestedState;
  final AssistantWriteEntityState? resultingState;
  final AssistantExecutionMode executionMode;
  final String policyName;
  final String adapterName;
  final AssistantWriteAuthorizationStatus authorizationStatus;
  final AssistantConfirmationStatus confirmationStatus;
  final DateTime startedAt;
  final DateTime finishedAt;
  final int durationMs;
  final AssistantWriteOutcomeCategory outcome;
  final AssistantWriteTransactionStatus transactionStatus;
  final AssistantWriteFailureCode? failureCode;
  final String? createdDraftId;
  final bool executed;
  final bool mutatedErp;
  final bool rollbackAttempted;
  final bool rollbackSucceeded;
  final List<String> warnings;

  /// Deterministic serialization map (stable key order via fixed insertion).
  Map<String, Object?> toDeterministicMap() {
    final sortedWarnings = [...warnings]..sort();
    final duration = durationMs < 0 ? 0 : durationMs;
    return {
      'correlationId': correlationId,
      'requestId': requestId,
      'executionId': executionId,
      'executionToken': executionToken.value,
      'idempotencyFingerprint': idempotencyFingerprint,
      'lifecycleIdempotencyStatus': lifecycleIdempotencyStatus?.name,
      'writeIdempotencyStatus': writeIdempotencyStatus.name,
      'operation': operation.name,
      'target': target.name,
      'requestedState': requestedState.name,
      'resultingState': resultingState?.name,
      'executionMode': executionMode.name,
      'policy': policyName,
      'adapter': adapterName,
      'authorizationStatus': authorizationStatus.name,
      'confirmationStatus': confirmationStatus.name,
      'startedAt': startedAt.toUtc().toIso8601String(),
      'finishedAt': finishedAt.toUtc().toIso8601String(),
      'durationMs': duration,
      'outcome': outcome.name,
      'transactionStatus': transactionStatus.name,
      'failureCode': failureCode?.name,
      'createdDraftId': createdDraftId,
      'executed': executed,
      'mutatedErp': mutatedErp,
      'rollbackAttempted': rollbackAttempted,
      'rollbackSucceeded': rollbackSucceeded && rollbackAttempted,
      'warnings': sortedWarnings,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantWriteAuditRecord &&
            other.correlationId == correlationId &&
            other.requestId == requestId &&
            other.executionId == executionId &&
            other.executionToken == executionToken &&
            other.idempotencyFingerprint == idempotencyFingerprint &&
            other.lifecycleIdempotencyStatus == lifecycleIdempotencyStatus &&
            other.writeIdempotencyStatus == writeIdempotencyStatus &&
            other.operation == operation &&
            other.target == target &&
            other.requestedState == requestedState &&
            other.resultingState == resultingState &&
            other.executionMode == executionMode &&
            other.policyName == policyName &&
            other.adapterName == adapterName &&
            other.authorizationStatus == authorizationStatus &&
            other.confirmationStatus == confirmationStatus &&
            other.startedAt == startedAt &&
            other.finishedAt == finishedAt &&
            other.durationMs == durationMs &&
            other.outcome == outcome &&
            other.transactionStatus == transactionStatus &&
            other.failureCode == failureCode &&
            other.createdDraftId == createdDraftId &&
            other.executed == executed &&
            other.mutatedErp == mutatedErp &&
            other.rollbackAttempted == rollbackAttempted &&
            other.rollbackSucceeded == rollbackSucceeded;
  }

  @override
  int get hashCode => Object.hash(
        correlationId,
        requestId,
        executionId,
        executionToken,
        idempotencyFingerprint,
        lifecycleIdempotencyStatus,
        writeIdempotencyStatus,
        operation,
        target,
        requestedState,
        Object.hash(
          resultingState,
          executionMode,
          policyName,
          adapterName,
          authorizationStatus,
          confirmationStatus,
          startedAt,
          finishedAt,
          durationMs,
          outcome,
        ),
        Object.hash(
          transactionStatus,
          failureCode,
          createdDraftId,
          executed,
          mutatedErp,
          rollbackAttempted,
          rollbackSucceeded,
        ),
      );
}
