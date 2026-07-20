import 'assistant_confirmation_operation_kind.dart';
import 'assistant_confirmation_token.dart';
import 'assistant_transaction_plan_fingerprint.dart';

/// In-memory pending confirmation awaiting user decision / single-use execution.
class PendingConfirmation {
  const PendingConfirmation({
    required this.token,
    required this.sessionId,
    required this.operationKind,
    required this.preview,
    required this.createdAt,
    required this.expiresAt,
    this.approvedAttributes = const {},
    this.approvedPlanFingerprint = '',
    this.resolved = false,
    this.cancelled = false,
    this.confirmed = false,
    this.consumed = false,
  });

  final AssistantConfirmationToken token;
  final String sessionId;
  final AssistantConfirmationOperationKind operationKind;
  final String preview;
  final DateTime createdAt;
  final DateTime expiresAt;

  /// Canonical attributes approved at confirmation create time.
  final Map<String, String> approvedAttributes;

  /// Fingerprint of [operationKind] + [approvedAttributes].
  final String approvedPlanFingerprint;

  final bool resolved;
  final bool cancelled;
  final bool confirmed;

  /// True after a successful single-use consumption by the transaction engine.
  final bool consumed;

  /// Active-pending expiry (AI-013): ignored once resolved.
  bool isExpiredAt(DateTime now) =>
      !resolved && isPastExpiresAt(now);

  /// Absolute TTL check (AI-014 execution gate).
  bool isPastExpiresAt(DateTime now) =>
      now.toUtc().isAfter(expiresAt.toUtc());

  bool get isActive => !resolved && !cancelled && !confirmed && !consumed;

  /// Confirmed and not yet consumed/cancelled (may still be time-expired).
  bool get isConfirmedAwaitingExecution =>
      confirmed && resolved && !cancelled && !consumed;

  PendingConfirmation copyWith({
    Map<String, String>? approvedAttributes,
    String? approvedPlanFingerprint,
    bool? resolved,
    bool? cancelled,
    bool? confirmed,
    bool? consumed,
  }) {
    return PendingConfirmation(
      token: token,
      sessionId: sessionId,
      operationKind: operationKind,
      preview: preview,
      createdAt: createdAt,
      expiresAt: expiresAt,
      approvedAttributes: approvedAttributes ?? this.approvedAttributes,
      approvedPlanFingerprint:
          approvedPlanFingerprint ?? this.approvedPlanFingerprint,
      resolved: resolved ?? this.resolved,
      cancelled: cancelled ?? this.cancelled,
      confirmed: confirmed ?? this.confirmed,
      consumed: consumed ?? this.consumed,
    );
  }

  Map<String, Object?> toDeterministicMap() => {
        'token': token.value,
        'sessionId': sessionId,
        'operationKind': operationKind.name,
        'preview': preview,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'expiresAt': expiresAt.toUtc().toIso8601String(),
        'approvedAttributes': approvedAttributes,
        'approvedPlanFingerprint': approvedPlanFingerprint,
        'resolved': resolved,
        'cancelled': cancelled,
        'confirmed': confirmed,
        'consumed': consumed,
      };

  factory PendingConfirmation.create({
    required AssistantConfirmationToken token,
    required String sessionId,
    required AssistantConfirmationOperationKind operationKind,
    required String preview,
    required DateTime createdAt,
    required DateTime expiresAt,
    Map<String, String> approvedAttributes = const {},
  }) {
    final attrs = Map<String, String>.unmodifiable(approvedAttributes);
    return PendingConfirmation(
      token: token,
      sessionId: sessionId,
      operationKind: operationKind,
      preview: preview,
      createdAt: createdAt,
      expiresAt: expiresAt,
      approvedAttributes: attrs,
      approvedPlanFingerprint: AssistantTransactionPlanFingerprint.compute(
        operationKind: operationKind,
        attributes: attrs,
      ),
    );
  }
}
