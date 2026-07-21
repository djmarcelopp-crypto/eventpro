/// Channel / session metadata for a conversation (no persistence).
class AssistantConversationMetadata {
  const AssistantConversationMetadata({
    this.sessionId,
    this.locale,
    this.timezone,
    this.origin,
    this.correlationId,
    this.tags = const [],
  });

  final String? sessionId;
  final String? locale;
  final String? timezone;
  final String? origin;
  final String? correlationId;
  final List<String> tags;

  Map<String, Object?> toDeterministicMap() => {
        'sessionId': sessionId,
        'locale': locale,
        'timezone': timezone,
        'origin': origin,
        'correlationId': correlationId,
        'tags': tags,
      };
}
