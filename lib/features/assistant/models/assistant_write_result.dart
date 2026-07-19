import 'assistant_write_capability.dart';
import 'assistant_write_operation.dart';
import 'assistant_write_target.dart';

/// Outcome of evaluating a write intent — never an ERP mutation in AI-005.
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
    this.rejectionReason,
  });

  final String id;
  final String requestId;
  final AssistantWriteOperation operation;
  final AssistantWriteTarget target;
  final AssistantWriteCapability capability;

  /// Whether the intent is structurally acceptable for a *future* pipeline.
  final bool accepted;

  /// Always `false` in AI-005 — no real write is performed at this layer.
  final bool executed;

  final String summary;
  final String? rejectionReason;

  AssistantWriteResult copyWith({
    String? id,
    String? requestId,
    AssistantWriteOperation? operation,
    AssistantWriteTarget? target,
    AssistantWriteCapability? capability,
    bool? accepted,
    bool? executed,
    String? summary,
    String? rejectionReason,
    bool clearRejectionReason = false,
  }) {
    return AssistantWriteResult(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      operation: operation ?? this.operation,
      target: target ?? this.target,
      capability: capability ?? this.capability,
      accepted: accepted ?? this.accepted,
      executed: executed ?? this.executed,
      summary: summary ?? this.summary,
      rejectionReason: clearRejectionReason
          ? null
          : (rejectionReason ?? this.rejectionReason),
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
            other.summary == summary &&
            other.rejectionReason == rejectionReason;
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
        summary,
        rejectionReason,
      );
}
