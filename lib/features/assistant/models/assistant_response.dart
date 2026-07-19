import 'assistant_action.dart';
import 'assistant_confidence.dart';
import 'assistant_entity.dart';
import 'assistant_event_draft.dart';
import 'assistant_execution_audit.dart';
import 'assistant_execution_mode.dart';
import 'assistant_execution_plan.dart';
import 'assistant_execution_report.dart';
import 'assistant_execution_step.dart';
import 'assistant_execution_warning.dart';
import 'assistant_integration_warning.dart';
import 'assistant_intent.dart';
import 'assistant_module_capability.dart';
import 'assistant_module_data_source.dart';
import 'assistant_module_response.dart';
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
    this.moduleResults = const [],
    this.consultedModules = const [],
    this.unavailableModules = const [],
    this.integrationWarnings = const [],
    this.executionReport,
    this.executionMode,
    this.executionAudit,
    this.executableSteps = const [],
    this.simulatedSteps = const [],
    this.skippedSteps = const [],
    this.executionWarnings = const [],
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

  final AssistantExecutionPlan? executionPlan;
  final List<AssistantExecutionStep> requiredConfirmations;
  final List<AssistantExecutionStep> blockedSteps;
  final List<AssistantExecutionStep> readySteps;
  final List<AssistantExecutionWarning> warnings;
  final AssistantAction? nextRecommendedAction;

  final List<AssistantModuleResponse> moduleResults;
  final List<AssistantModuleCapability> consultedModules;
  final List<AssistantModuleCapability> unavailableModules;
  final List<AssistantIntegrationWarning> integrationWarnings;

  /// AI-004 controlled execution dry-run/simulation report.
  final AssistantExecutionReport? executionReport;
  final AssistantExecutionMode? executionMode;
  final AssistantExecutionAudit? executionAudit;
  final List<AssistantExecutionStep> executableSteps;
  final List<AssistantExecutionStep> simulatedSteps;
  final List<AssistantExecutionStep> skippedSteps;
  final List<String> executionWarnings;

  List<AssistantModuleDataSource> get moduleDataSources =>
      moduleResults.map((r) => r.dataSource).toSet().toList(growable: false);

  bool get hasOnlySimulatedModuleData =>
      moduleResults.isEmpty || moduleResults.every((r) => r.isSimulated);

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
    List<AssistantModuleResponse>? moduleResults,
    List<AssistantModuleCapability>? consultedModules,
    List<AssistantModuleCapability>? unavailableModules,
    List<AssistantIntegrationWarning>? integrationWarnings,
    AssistantExecutionReport? executionReport,
    AssistantExecutionMode? executionMode,
    AssistantExecutionAudit? executionAudit,
    List<AssistantExecutionStep>? executableSteps,
    List<AssistantExecutionStep>? simulatedSteps,
    List<AssistantExecutionStep>? skippedSteps,
    List<String>? executionWarnings,
    bool clearEventDraft = false,
    bool clearQuoteDraft = false,
    bool clearExecutionPlan = false,
    bool clearNextRecommendedAction = false,
    bool clearExecutionReport = false,
    bool clearExecutionMode = false,
    bool clearExecutionAudit = false,
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
      moduleResults: moduleResults ?? this.moduleResults,
      consultedModules: consultedModules ?? this.consultedModules,
      unavailableModules: unavailableModules ?? this.unavailableModules,
      integrationWarnings: integrationWarnings ?? this.integrationWarnings,
      executionReport: clearExecutionReport
          ? null
          : (executionReport ?? this.executionReport),
      executionMode:
          clearExecutionMode ? null : (executionMode ?? this.executionMode),
      executionAudit:
          clearExecutionAudit ? null : (executionAudit ?? this.executionAudit),
      executableSteps: executableSteps ?? this.executableSteps,
      simulatedSteps: simulatedSteps ?? this.simulatedSteps,
      skippedSteps: skippedSteps ?? this.skippedSteps,
      executionWarnings: executionWarnings ?? this.executionWarnings,
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
            other.nextRecommendedAction == nextRecommendedAction &&
            _listEquals(other.moduleResults, moduleResults) &&
            _listEquals(other.consultedModules, consultedModules) &&
            _listEquals(other.unavailableModules, unavailableModules) &&
            _listEquals(other.integrationWarnings, integrationWarnings) &&
            other.executionReport == executionReport &&
            other.executionMode == executionMode &&
            other.executionAudit == executionAudit &&
            _listEquals(other.executableSteps, executableSteps) &&
            _listEquals(other.simulatedSteps, simulatedSteps) &&
            _listEquals(other.skippedSteps, skippedSteps) &&
            _listEquals(other.executionWarnings, executionWarnings);
  }

  @override
  int get hashCode => Object.hash(
        requestId,
        rawText,
        primaryIntent,
        Object.hash(
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
        ),
        Object.hash(
          executionPlan,
          Object.hashAll(requiredConfirmations),
          Object.hashAll(blockedSteps),
          Object.hashAll(readySteps),
          Object.hashAll(warnings),
          nextRecommendedAction,
          Object.hashAll(moduleResults),
          Object.hashAll(consultedModules),
          Object.hashAll(unavailableModules),
          Object.hashAll(integrationWarnings),
        ),
        Object.hash(
          executionReport,
          executionMode,
          executionAudit,
          Object.hashAll(executableSteps),
          Object.hashAll(simulatedSteps),
          Object.hashAll(skippedSteps),
          Object.hashAll(executionWarnings),
        ),
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
