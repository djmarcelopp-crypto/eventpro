/// Conversational continuity wrapper around a turn response.
class AssistantConversationPresentation {
  const AssistantConversationPresentation({
    required this.naturalLanguage,
    this.isFollowUp = false,
    this.missingContext = false,
    this.sessionId,
    this.contextVersion = 0,
  });

  final String naturalLanguage;
  final bool isFollowUp;
  final bool missingContext;
  final String? sessionId;
  final int contextVersion;

  Map<String, Object?> toDeterministicMap() => {
        'naturalLanguage': naturalLanguage,
        'isFollowUp': isFollowUp,
        'missingContext': missingContext,
        'sessionId': sessionId,
        'contextVersion': contextVersion,
      };
}
