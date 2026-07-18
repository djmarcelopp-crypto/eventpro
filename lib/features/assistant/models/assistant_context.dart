/// Optional conversation / session context for an [AssistantRequest].
///
/// AI-001 does not persist context; the type reserves the contract.
class AssistantContext {
  const AssistantContext({
    this.sessionId,
    this.activeClientId,
    this.activeQuoteId,
    this.activeEventDate,
    this.hints = const [],
  });

  final String? sessionId;
  final String? activeClientId;
  final String? activeQuoteId;
  final DateTime? activeEventDate;
  final List<String> hints;

  AssistantContext copyWith({
    String? sessionId,
    String? activeClientId,
    String? activeQuoteId,
    DateTime? activeEventDate,
    List<String>? hints,
    bool clearSessionId = false,
    bool clearActiveClientId = false,
    bool clearActiveQuoteId = false,
    bool clearActiveEventDate = false,
  }) {
    return AssistantContext(
      sessionId: clearSessionId ? null : (sessionId ?? this.sessionId),
      activeClientId:
          clearActiveClientId ? null : (activeClientId ?? this.activeClientId),
      activeQuoteId:
          clearActiveQuoteId ? null : (activeQuoteId ?? this.activeQuoteId),
      activeEventDate: clearActiveEventDate
          ? null
          : (activeEventDate ?? this.activeEventDate),
      hints: hints ?? this.hints,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantContext &&
            other.sessionId == sessionId &&
            other.activeClientId == activeClientId &&
            other.activeQuoteId == activeQuoteId &&
            other.activeEventDate == activeEventDate &&
            _sameHints(other.hints, hints);
  }

  @override
  int get hashCode => Object.hash(
        sessionId,
        activeClientId,
        activeQuoteId,
        activeEventDate,
        Object.hashAll(hints),
      );

  static bool _sameHints(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
