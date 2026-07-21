/// Metadata for a reasoning evaluation turn.
class BusinessReasoningMetadata {
  const BusinessReasoningMetadata({
    this.correlationId,
    this.sessionId,
    this.engineVersion = 'AI-023',
    this.evaluatedAt,
    this.tags = const [],
  });

  final String? correlationId;
  final String? sessionId;
  final String engineVersion;
  final DateTime? evaluatedAt;
  final List<String> tags;

  Map<String, Object?> toDeterministicMap() => {
        'correlationId': correlationId,
        'sessionId': sessionId,
        'engineVersion': engineVersion,
        'evaluatedAt': evaluatedAt?.toUtc().toIso8601String(),
        'tags': tags,
      };
}
