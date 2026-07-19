import 'assistant_write_authorization.dart';
import 'assistant_write_capability.dart';
import 'assistant_write_constraint.dart';
import 'assistant_write_operation.dart';
import 'assistant_write_target.dart';

/// Immutable write *intent* — never dispatched to the ERP in AI-005.
///
/// Carries only abstract attributes; no repository/DAO/SQLite knowledge.
class AssistantWriteRequest {
  const AssistantWriteRequest({
    required this.id,
    required this.requestId,
    required this.operation,
    required this.target,
    required this.capability,
    this.constraints = const [],
    this.authorization,
    this.attributes = const {},
    this.relatedStepId,
  });

  final String id;
  final String requestId;
  final AssistantWriteOperation operation;
  final AssistantWriteTarget target;
  final AssistantWriteCapability capability;
  final List<AssistantWriteConstraint> constraints;
  final AssistantWriteAuthorization? authorization;

  /// Opaque string attributes (e.g. draft field names) — not ERP entities.
  final Map<String, String> attributes;

  /// Optional link to an [AssistantExecutionStep.id] from the plan.
  final String? relatedStepId;

  bool get allConstraintsSatisfied =>
      constraints.every((c) => c.satisfied);

  bool get isReservedOperation =>
      operation == AssistantWriteOperation.delete ||
      operation == AssistantWriteOperation.cancel;

  AssistantWriteRequest copyWith({
    String? id,
    String? requestId,
    AssistantWriteOperation? operation,
    AssistantWriteTarget? target,
    AssistantWriteCapability? capability,
    List<AssistantWriteConstraint>? constraints,
    AssistantWriteAuthorization? authorization,
    Map<String, String>? attributes,
    String? relatedStepId,
    bool clearAuthorization = false,
    bool clearRelatedStepId = false,
  }) {
    return AssistantWriteRequest(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      operation: operation ?? this.operation,
      target: target ?? this.target,
      capability: capability ?? this.capability,
      constraints: constraints ?? this.constraints,
      authorization: clearAuthorization
          ? null
          : (authorization ?? this.authorization),
      attributes: attributes ?? this.attributes,
      relatedStepId: clearRelatedStepId
          ? null
          : (relatedStepId ?? this.relatedStepId),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantWriteRequest &&
            other.id == id &&
            other.requestId == requestId &&
            other.operation == operation &&
            other.target == target &&
            other.capability == capability &&
            _listEquals(other.constraints, constraints) &&
            other.authorization == authorization &&
            _mapEquals(other.attributes, attributes) &&
            other.relatedStepId == relatedStepId;
  }

  @override
  int get hashCode => Object.hash(
        id,
        requestId,
        operation,
        target,
        capability,
        Object.hashAll(constraints),
        authorization,
        Object.hashAll(attributes.entries),
        relatedStepId,
      );

  static bool _listEquals(
    List<AssistantWriteConstraint> a,
    List<AssistantWriteConstraint> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }
}
