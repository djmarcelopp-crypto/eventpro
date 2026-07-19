/// Execution metadata for a smart action (no Flutter).
class AssistantActionMetadata {
  const AssistantActionMetadata({
    required this.timestamp,
    required this.kind,
    this.executionTimeMs = 0,
    this.idempotentReplay = false,
    this.sessionId,
  });

  final DateTime timestamp;
  final String kind;
  final int executionTimeMs;
  final bool idempotentReplay;
  final String? sessionId;

  Map<String, Object?> toDeterministicMap() => {
        'timestamp': timestamp.toUtc().toIso8601String(),
        'kind': kind,
        'executionTimeMs': executionTimeMs,
        'idempotentReplay': idempotentReplay,
        'sessionId': sessionId,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantActionMetadata &&
            other.timestamp == timestamp &&
            other.kind == kind &&
            other.executionTimeMs == executionTimeMs &&
            other.idempotentReplay == idempotentReplay &&
            other.sessionId == sessionId;
  }

  @override
  int get hashCode => Object.hash(
        timestamp,
        kind,
        executionTimeMs,
        idempotentReplay,
        sessionId,
      );
}
