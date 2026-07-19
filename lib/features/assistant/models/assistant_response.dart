import 'assistant_action.dart';
import 'assistant_confidence.dart';
import 'assistant_entity.dart';
import 'assistant_event_draft.dart';
import 'assistant_execution_plan.dart';
import 'assistant_execution_step.dart';
import 'assistant_execution_warning.dart';
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
    this.executionPlan,
    this.requiredConfirmations = const [],
    this.blockedSteps = const [],
    this.readySteps = const [],
    this.warnings = const [],
    this.nextRecommendedAction,
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

  /// Explicit plan produced by AI-002 — never executed here.
  final AssistantExecutionPlan? executionPlan;

  /// Steps that would require user confirmation before any future execution.
  final List<AssistantExecutionStep> requiredConfirmations;

  final List<AssistantExecutionStep> blockedSteps;
  final List<AssistantExecutionStep> readySteps;
  final List<AssistantExecutionWarning> warnings;

  /// Suggested next human action (review / answer questions) — not ERP write.
  final AssistantAction? nextRecommendedAction;

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
    AssistantExecutionPlan? executionPlan,
    List<AssistantExecutionStep>? requiredConfirmations,
    List<AssistantExecutionStep>? blockedSteps,
    List<AssistantExecutionStep>? readySteps,
    List<AssistantExecutionWarning>? warnings,
    AssistantAction? nextRecommendedAction,
    bool clearEventDraft = false,
    bool clearQuoteDraft = false,
    bool clearExecutionPlan = false,
    bool clearNextRecommendedAction = false,
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
      executionPlan:
          clearExecutionPlan ? null : (executionPlan ?? this.executionPlan),
      requiredConfirmations:
          requiredConfirmations ?? this.requiredConfirmations,
      blockedSteps: blockedSteps ?? this.blockedSteps,
      readySteps: readySteps ?? this.readySteps,
      warnings: warnings ?? this.warnings,
      nextRecommendedAction: clearNextRecommendedAction
          ? null
          : (nextRecommendedAction ?? this.nextRecommendedAction),
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
            other.friendlyMessage == friendlyMessage &&
            other.executionPlan == executionPlan &&
            _listEquals(other.requiredConfirmations, requiredConfirmations) &&
            _listEquals(other.blockedSteps, blockedSteps) &&
            _listEquals(other.readySteps, readySteps) &&
            _listEquals(other.warnings, warnings) &&
            other.nextRecommendedAction == nextRecommendedAction;
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
        executionPlan,
        Object.hashAll(requiredConfirmations),
        Object.hashAll(blockedSteps),
        Object.hashAll(readySteps),
        Object.hashAll(warnings),
        nextRecommendedAction,
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
