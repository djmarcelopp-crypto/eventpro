import 'assistant_idempotency_status.dart';
import 'assistant_write_failure_code.dart';
import 'assistant_write_idempotency_key.dart';

/// Durable-enough snapshot of an idempotent operation (no raw key).
class AssistantIdempotencyRecord {
  const AssistantIdempotencyRecord({
    required this.fingerprint,
    required this.derivedResourceId,
    required this.status,
    required this.updatedAt,
    this.createdAt,
    this.resultDraftId,
    this.resultDraftNumber,
    this.failureCode,
    this.failureMessage,
    this.executed = false,
    this.mutatedErp = false,
  });

  final String fingerprint;
  final String derivedResourceId;
  final AssistantIdempotencyStatus status;
  final DateTime updatedAt;
  final DateTime? createdAt;
  final String? resultDraftId;
  final String? resultDraftNumber;
  final AssistantWriteFailureCode? failureCode;
  final String? failureMessage;
  final bool executed;
  final bool mutatedErp;

  /// Factory from key — stores only fingerprint, never raw value.
  factory AssistantIdempotencyRecord.fromKey({
    required AssistantWriteIdempotencyKey key,
    required AssistantIdempotencyStatus status,
    required DateTime updatedAt,
    DateTime? createdAt,
    String? resultDraftId,
    String? resultDraftNumber,
    AssistantWriteFailureCode? failureCode,
    String? failureMessage,
    bool executed = false,
    bool mutatedErp = false,
  }) {
    return AssistantIdempotencyRecord(
      fingerprint: key.auditFingerprint,
      derivedResourceId: key.derivedDraftId,
      status: status,
      updatedAt: updatedAt,
      createdAt: createdAt ?? updatedAt,
      resultDraftId: resultDraftId,
      resultDraftNumber: resultDraftNumber,
      failureCode: failureCode,
      failureMessage: failureMessage,
      executed: executed,
      mutatedErp: mutatedErp,
    );
  }

  AssistantIdempotencyRecord copyWith({
    AssistantIdempotencyStatus? status,
    DateTime? updatedAt,
    String? resultDraftId,
    String? resultDraftNumber,
    AssistantWriteFailureCode? failureCode,
    String? failureMessage,
    bool? executed,
    bool? mutatedErp,
    bool clearFailure = false,
  }) {
    return AssistantIdempotencyRecord(
      fingerprint: fingerprint,
      derivedResourceId: derivedResourceId,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt,
      resultDraftId: resultDraftId ?? this.resultDraftId,
      resultDraftNumber: resultDraftNumber ?? this.resultDraftNumber,
      failureCode: clearFailure ? null : (failureCode ?? this.failureCode),
      failureMessage:
          clearFailure ? null : (failureMessage ?? this.failureMessage),
      executed: executed ?? this.executed,
      mutatedErp: mutatedErp ?? this.mutatedErp,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantIdempotencyRecord &&
            other.fingerprint == fingerprint &&
            other.derivedResourceId == derivedResourceId &&
            other.status == status &&
            other.updatedAt == updatedAt &&
            other.resultDraftId == resultDraftId &&
            other.resultDraftNumber == resultDraftNumber &&
            other.failureCode == failureCode &&
            other.executed == executed &&
            other.mutatedErp == mutatedErp;
  }

  @override
  int get hashCode => Object.hash(
        fingerprint,
        derivedResourceId,
        status,
        updatedAt,
        resultDraftId,
        resultDraftNumber,
        failureCode,
        executed,
        mutatedErp,
      );
}
