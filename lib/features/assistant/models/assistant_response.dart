import 'assistant_action.dart';
import 'assistant_confidence.dart';
import 'assistant_entity.dart';
import 'assistant_event_draft.dart';
import 'assistant_intent.dart';
import 'assistant_parse_issue.dart';
import 'assistant_question.dart';
import 'assistant_quote_draft.dart';
import 'assistant_suggestion.dart';

/// Structured, explainable assistant output. Never mutates the ERP.
class AssistantResponse {
  const AssistantResponse({
    required this.requestId,
    required this.rawText,
    required this.primaryIntent,
    required this.overallConfidence,
    required this.friendlyMessage,
    this.alternativeIntents = const [],
    this.entities = const [],
    this.eventDraft,
    this.quoteDraft,
    this.questions = const [],
    this.suggestions = const [],
    this.issues = const [],
    this.actions = const [],
  });

  final String requestId;
  final String rawText;
  final AssistantIntent primaryIntent;
  final List<AssistantIntent> alternativeIntents;
  final List<AssistantEntity> entities;
  final AssistantEventDraft? eventDraft;
  final AssistantQuoteDraft? quoteDraft;
  final List<AssistantQuestion> questions;
  final List<AssistantSuggestion> suggestions;
  final List<AssistantParseIssue> issues;
  final AssistantConfidence overallConfidence;
  final List<AssistantAction> actions;
  final String friendlyMessage;

  AssistantResponse copyWith({
    String? requestId,
    String? rawText,
    AssistantIntent? primaryIntent,
    List<AssistantIntent>? alternativeIntents,
    List<AssistantEntity>? entities,
    AssistantEventDraft? eventDraft,
    AssistantQuoteDraft? quoteDraft,
    List<AssistantQuestion>? questions,
    List<AssistantSuggestion>? suggestions,
    List<AssistantParseIssue>? issues,
    AssistantConfidence? overallConfidence,
    List<AssistantAction>? actions,
    String? friendlyMessage,
    bool clearEventDraft = false,
    bool clearQuoteDraft = false,
  }) {
    return AssistantResponse(
      requestId: requestId ?? this.requestId,
      rawText: rawText ?? this.rawText,
      primaryIntent: primaryIntent ?? this.primaryIntent,
      alternativeIntents: alternativeIntents ?? this.alternativeIntents,
      entities: entities ?? this.entities,
      eventDraft: clearEventDraft ? null : (eventDraft ?? this.eventDraft),
      quoteDraft: clearQuoteDraft ? null : (quoteDraft ?? this.quoteDraft),
      questions: questions ?? this.questions,
      suggestions: suggestions ?? this.suggestions,
      issues: issues ?? this.issues,
      overallConfidence: overallConfidence ?? this.overallConfidence,
      actions: actions ?? this.actions,
      friendlyMessage: friendlyMessage ?? this.friendlyMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantResponse &&
            other.requestId == requestId &&
            other.rawText == rawText &&
            other.primaryIntent == primaryIntent &&
            _listEquals(other.alternativeIntents, alternativeIntents) &&
            _listEquals(other.entities, entities) &&
            other.eventDraft == eventDraft &&
            other.quoteDraft == quoteDraft &&
            _listEquals(other.questions, questions) &&
            _listEquals(other.suggestions, suggestions) &&
            _listEquals(other.issues, issues) &&
            other.overallConfidence == overallConfidence &&
            _listEquals(other.actions, actions) &&
            other.friendlyMessage == friendlyMessage;
  }

  @override
  int get hashCode => Object.hash(
        requestId,
        rawText,
        primaryIntent,
        Object.hashAll(alternativeIntents),
        Object.hashAll(entities),
        eventDraft,
        quoteDraft,
        Object.hashAll(questions),
        Object.hashAll(suggestions),
        Object.hashAll(issues),
        overallConfidence,
        Object.hashAll(actions),
        friendlyMessage,
      );

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
