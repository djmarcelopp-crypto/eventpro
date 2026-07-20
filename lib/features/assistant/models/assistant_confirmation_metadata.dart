/// Metadata for a safe confirmation turn.
class AssistantConfirmationMetadata {
  const AssistantConfirmationMetadata({
    required this.timestamp,
    required this.outcome,
    this.sessionId,
    this.token,
    this.expiresAt,
  });

  final DateTime timestamp;
  final String outcome;
  final String? sessionId;
  final String? token;
  final DateTime? expiresAt;

  Map<String, Object?> toDeterministicMap() => {
        'timestamp': timestamp.toUtc().toIso8601String(),
        'outcome': outcome,
        'sessionId': sessionId,
        'token': token,
        'expiresAt': expiresAt?.toUtc().toIso8601String(),
      };
}
