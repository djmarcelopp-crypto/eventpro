import 'assistant_conversation_summary.dart';

/// Active conversational state bag (immutable snapshot fields).
class AssistantConversationState {
  const AssistantConversationState({
    this.lastIntentLabel,
    this.lastWorkflowId,
    this.lastCommandIds = const [],
    this.lastCapabilityIds = const [],
    this.lastEntityRefs = const [],
    this.activeClientId,
    this.activeQuoteId,
    this.activeEventDate,
    this.hints = const [],
    this.summary = AssistantConversationSummary.empty,
  });

  static const empty = AssistantConversationState();

  final String? lastIntentLabel;
  final String? lastWorkflowId;
  final List<String> lastCommandIds;
  final List<String> lastCapabilityIds;
  final List<String> lastEntityRefs;
  final String? activeClientId;
  final String? activeQuoteId;
  final String? activeEventDate;
  final List<String> hints;
  final AssistantConversationSummary summary;

  AssistantConversationState copyWith({
    String? lastIntentLabel,
    String? lastWorkflowId,
    List<String>? lastCommandIds,
    List<String>? lastCapabilityIds,
    List<String>? lastEntityRefs,
    String? activeClientId,
    String? activeQuoteId,
    String? activeEventDate,
    List<String>? hints,
    AssistantConversationSummary? summary,
    bool clearLastIntent = false,
    bool clearLastWorkflow = false,
  }) {
    return AssistantConversationState(
      lastIntentLabel:
          clearLastIntent ? null : (lastIntentLabel ?? this.lastIntentLabel),
      lastWorkflowId:
          clearLastWorkflow ? null : (lastWorkflowId ?? this.lastWorkflowId),
      lastCommandIds: lastCommandIds ?? this.lastCommandIds,
      lastCapabilityIds: lastCapabilityIds ?? this.lastCapabilityIds,
      lastEntityRefs: lastEntityRefs ?? this.lastEntityRefs,
      activeClientId: activeClientId ?? this.activeClientId,
      activeQuoteId: activeQuoteId ?? this.activeQuoteId,
      activeEventDate: activeEventDate ?? this.activeEventDate,
      hints: hints ?? this.hints,
      summary: summary ?? this.summary,
    );
  }

  Map<String, Object?> toDeterministicMap() => {
        'lastIntentLabel': lastIntentLabel,
        'lastWorkflowId': lastWorkflowId,
        'lastCommandIds': lastCommandIds,
        'lastCapabilityIds': lastCapabilityIds,
        'lastEntityRefs': lastEntityRefs,
        'activeClientId': activeClientId,
        'activeQuoteId': activeQuoteId,
        'activeEventDate': activeEventDate,
        'hints': hints,
        'summary': summary.toDeterministicMap(),
      };
}
