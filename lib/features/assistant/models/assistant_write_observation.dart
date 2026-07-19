import 'assistant_confirmation_status.dart';
import 'assistant_execution_mode.dart';
import 'assistant_write_authorization_status.dart';
import 'assistant_write_failure_code.dart';
import 'assistant_write_idempotency_status.dart';
import 'assistant_write_operation.dart';
import 'assistant_write_outcome_category.dart';
import 'assistant_write_target.dart';

/// Local, non-authoritative observation of a write attempt.
class AssistantWriteObservation {
  const AssistantWriteObservation({
    required this.operation,
    required this.target,
    required this.executionMode,
    required this.policyName,
    required this.adapterName,
    required this.idempotencyStatus,
    required this.startedAt,
    required this.finishedAt,
    required this.durationMs,
    required this.confirmationStatus,
    required this.authorizationStatus,
    required this.outcome,
    required this.executed,
    required this.mutatedErp,
    this.timeout = false,
    this.rollbackAttempted = false,
    this.rollbackSucceeded = false,
    this.warningCount = 0,
    this.failureCode,
  });

  final AssistantWriteOperation operation;
  final AssistantWriteTarget target;
  final AssistantExecutionMode executionMode;
  final String policyName;
  final String adapterName;
  final AssistantWriteIdempotencyStatus idempotencyStatus;
  final DateTime startedAt;
  final DateTime finishedAt;
  final int durationMs;
  final AssistantConfirmationStatus confirmationStatus;
  final AssistantWriteAuthorizationStatus authorizationStatus;
  final AssistantWriteOutcomeCategory outcome;
  final bool executed;
  final bool mutatedErp;
  final bool timeout;
  final bool rollbackAttempted;
  final bool rollbackSucceeded;
  final int warningCount;
  final AssistantWriteFailureCode? failureCode;

  Map<String, Object?> toMetricMap() {
    return {
      'operation': operation.name,
      'target': target.name,
      'executionMode': executionMode.name,
      'policy': policyName,
      'adapter': adapterName,
      'idempotencyStatus': idempotencyStatus.name,
      'startedAt': startedAt.toIso8601String(),
      'finishedAt': finishedAt.toIso8601String(),
      'durationMs': durationMs < 0 ? 0 : durationMs,
      'confirmation': confirmationStatus.name,
      'authorization': authorizationStatus.name,
      'outcome': outcome.name,
      'executed': executed,
      'mutatedErp': mutatedErp,
      'timeout': timeout,
      'rollbackAttempted': rollbackAttempted,
      'rollbackSucceeded': rollbackSucceeded,
      'warningCount': warningCount,
      'failureCode': failureCode?.name,
    };
  }
}
