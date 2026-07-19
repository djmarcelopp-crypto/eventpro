import 'assistant_write_capability.dart';
import 'assistant_write_entity_state.dart';
import 'assistant_write_failure.dart';
import 'assistant_write_idempotency_status.dart';
import 'assistant_write_operation.dart';
import 'assistant_write_target.dart';

/// Outcome of a write intent preparation and optional gateway execution.
class AssistantWriteResult {
  const AssistantWriteResult({
    required this.id,
    required this.requestId,
    required this.operation,
    required this.target,
    required this.capability,
    required this.accepted,
    required this.summary,
    this.executed = false,
    this.mutatedErp = false,
    this.rejectionReason,
    this.draftId,
    this.draftNumber,
    this.resultingState,
    this.idempotencyStatus = AssistantWriteIdempotencyStatus.notApplicable,
    this.failure,
    this.rollbackAttempted = false,
    this.rollbackSucceeded = false,
  });

  final String id;
  final String requestId;
  final AssistantWriteOperation operation;
  final AssistantWriteTarget target;
  final AssistantWriteCapability capability;
  final bool accepted;
  final bool executed;
  final bool mutatedErp;
  final String summary;
  final String? rejectionReason;
  final String? draftId;
  final String? draftNumber;
  final AssistantWriteEntityState? resultingState;
  final AssistantWriteIdempotencyStatus idempotencyStatus;
  final AssistantWriteFailure? failure;
  final bool rollbackAttempted;
  final bool rollbackSucceeded;

  AssistantWriteResult copyWith({
    String? id,
    String? requestId,
    AssistantWriteOperation? operation,
    AssistantWriteTarget? target,
    AssistantWriteCapability? capability,
    bool? accepted,
    bool? executed,
    bool? mutatedErp,
    String? summary,
    String? rejectionReason,
    String? draftId,
    String? draftNumber,
    AssistantWriteEntityState? resultingState,
    AssistantWriteIdempotencyStatus? idempotencyStatus,
    AssistantWriteFailure? failure,
    bool? rollbackAttempted,
    bool? rollbackSucceeded,
    bool clearRejectionReason = false,
    bool clearDraftId = false,
    bool clearFailure = false,
  }) {
    return AssistantWriteResult(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      operation: operation ?? this.operation,
      target: target ?? this.target,
      capability: capability ?? this.capability,
      accepted: accepted ?? this.accepted,
      executed: executed ?? this.executed,
      mutatedErp: mutatedErp ?? this.mutatedErp,
      summary: summary ?? this.summary,
      rejectionReason: clearRejectionReason
          ? null
          : (rejectionReason ?? this.rejectionReason),
      draftId: clearDraftId ? null : (draftId ?? this.draftId),
      draftNumber: draftNumber ?? this.draftNumber,
      resultingState: resultingState ?? this.resultingState,
      idempotencyStatus: idempotencyStatus ?? this.idempotencyStatus,
      failure: clearFailure ? null : (failure ?? this.failure),
      rollbackAttempted: rollbackAttempted ?? this.rollbackAttempted,
      rollbackSucceeded: rollbackSucceeded ?? this.rollbackSucceeded,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantWriteResult &&
            other.id == id &&
            other.requestId == requestId &&
            other.operation == operation &&
            other.target == target &&
            other.capability == capability &&
            other.accepted == accepted &&
            other.executed == executed &&
            other.mutatedErp == mutatedErp &&
            other.summary == summary &&
            other.rejectionReason == rejectionReason &&
            other.draftId == draftId &&
            other.draftNumber == draftNumber &&
            other.resultingState == resultingState &&
            other.idempotencyStatus == idempotencyStatus &&
            other.failure == failure &&
            other.rollbackAttempted == rollbackAttempted &&
            other.rollbackSucceeded == rollbackSucceeded;
  }

  @override
  int get hashCode => Object.hash(
        id,
        requestId,
        operation,
        target,
        capability,
        accepted,
        executed,
        mutatedErp,
        summary,
        rejectionReason,
        draftId,
        draftNumber,
        resultingState,
        idempotencyStatus,
        failure,
        Object.hash(rollbackAttempted, rollbackSucceeded),
      );
}
