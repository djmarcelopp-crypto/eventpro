import 'assistant_confirmation_operation_kind.dart';
import 'assistant_confirmation_token.dart';

/// In-memory pending confirmation awaiting user decision.
class PendingConfirmation {
  const PendingConfirmation({
    required this.token,
    required this.sessionId,
    required this.operationKind,
    required this.preview,
    required this.createdAt,
    required this.expiresAt,
    this.resolved = false,
    this.cancelled = false,
    this.confirmed = false,
  });

  final AssistantConfirmationToken token;
  final String sessionId;
  final AssistantConfirmationOperationKind operationKind;
  final String preview;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool resolved;
  final bool cancelled;
  final bool confirmed;

  bool isExpiredAt(DateTime now) =>
      !resolved && now.toUtc().isAfter(expiresAt.toUtc());

  bool get isActive => !resolved && !cancelled && !confirmed;

  PendingConfirmation copyWith({
    bool? resolved,
    bool? cancelled,
    bool? confirmed,
  }) {
    return PendingConfirmation(
      token: token,
      sessionId: sessionId,
      operationKind: operationKind,
      preview: preview,
      createdAt: createdAt,
      expiresAt: expiresAt,
      resolved: resolved ?? this.resolved,
      cancelled: cancelled ?? this.cancelled,
      confirmed: confirmed ?? this.confirmed,
    );
  }

  Map<String, Object?> toDeterministicMap() => {
        'token': token.value,
        'sessionId': sessionId,
        'operationKind': operationKind.name,
        'preview': preview,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'expiresAt': expiresAt.toUtc().toIso8601String(),
        'resolved': resolved,
        'cancelled': cancelled,
        'confirmed': confirmed,
      };
}
