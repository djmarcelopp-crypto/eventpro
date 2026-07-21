/// Metadata attached to a memory entry (immutable).
class AssistantMemoryMetadata {
  const AssistantMemoryMetadata({
    this.origin,
    this.reason,
    this.correlationId,
    this.sessionId,
    this.confidence = 1.0,
    this.priority = 0,
    this.tags = const [],
    this.expiresAt,
    this.sourcePipeline,
  });

  final String? origin;
  final String? reason;
  final String? correlationId;
  final String? sessionId;
  final double confidence;
  final int priority;
  final List<String> tags;
  final DateTime? expiresAt;
  final String? sourcePipeline;

  Map<String, Object?> toDeterministicMap() => {
        'origin': origin,
        'reason': reason,
        'correlationId': correlationId,
        'sessionId': sessionId,
        'confidence': confidence,
        'priority': priority,
        'tags': tags,
        'expiresAt': expiresAt?.toUtc().toIso8601String(),
        'sourcePipeline': sourcePipeline,
      };
}
