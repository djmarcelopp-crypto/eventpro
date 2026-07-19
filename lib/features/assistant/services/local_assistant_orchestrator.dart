import '../domain/assistant_execution_planner.dart';
import '../domain/assistant_intent_classifier.dart';
import '../domain/assistant_orchestrator.dart';
import '../domain/assistant_parser.dart';
import '../domain/assistant_response_builder.dart';
import '../domain/gateway/assistant_gateway.dart';
import '../models/assistant_action.dart';
import '../models/assistant_action_type.dart';
import '../models/assistant_intent.dart';
import '../models/assistant_module_response.dart';
import '../models/assistant_request.dart';
import '../models/assistant_response.dart';
import '../parsers/local_assistant_parser.dart';
import 'assistant_capabilities.dart';
import 'assistant_draft_builder.dart';
import 'assistant_module_consultant.dart';
import 'local_assistant_execution_planner.dart';
import 'local_assistant_intent_classifier.dart';
import 'local_assistant_response_builder.dart';

/// Local orchestration pipeline with no persistence and no ERP writes.
class LocalAssistantOrchestrator implements AssistantOrchestrator {
  LocalAssistantOrchestrator({
    AssistantParser? parser,
    AssistantIntentClassifier? intentClassifier,
    AssistantResponseBuilder? responseBuilder,
    AssistantExecutionPlanner? executionPlanner,
    AssistantCapabilities? capabilities,
    AssistantGateway? gateway,
    AssistantModuleConsultant? moduleConsultant,
    DateTime Function()? clock,
  })  : _capabilities = capabilities ?? AssistantCapabilities.localDefaults(),
        _parser = parser ?? LocalAssistantParser(clock: clock),
        _intentClassifier =
            intentClassifier ?? LocalAssistantIntentClassifier(),
        _responseBuilder =
            responseBuilder ?? LocalAssistantResponseBuilder(),
        _executionPlanner = executionPlanner ??
            LocalAssistantExecutionPlanner(
              capabilities:
                  capabilities ?? AssistantCapabilities.localDefaults(),
            ),
        _moduleConsultant = moduleConsultant ??
            AssistantModuleConsultant(
              capabilities:
                  capabilities ?? AssistantCapabilities.localDefaults(),
              gateway: gateway,
            );

  final AssistantCapabilities _capabilities;
  final AssistantParser _parser;
  final AssistantIntentClassifier _intentClassifier;
  final AssistantResponseBuilder _responseBuilder;
  final AssistantExecutionPlanner _executionPlanner;
  final AssistantModuleConsultant _moduleConsultant;

  @override
  AssistantResponse handle(AssistantRequest request) {
    final parseResult = _parser.parse(request);
    final intents = _intentClassifier.classify(
      request: request,
      parseResult: parseResult,
    );
    final primary = intents.first;
    final List<AssistantIntent> alternatives =
        intents.length > 1 ? intents.sublist(1) : const <AssistantIntent>[];

    final eventDraft = AssistantDraftBuilder.buildEventDraft(
      sourceText: request.rawText,
      entities: parseResult.entities,
    );
    final quoteDraft = AssistantDraftBuilder.buildQuoteDraft(
      entities: parseResult.entities,
    );

    final interpreted = _responseBuilder.build(
      request: request,
      parseResult: parseResult,
      primaryIntent: primary,
      alternativeIntents: alternatives,
      eventDraft: eventDraft,
      quoteDraft: quoteDraft,
      entities: parseResult.entities,
      issues: parseResult.issues,
    );

    final plan = _executionPlanner.plan(interpreted);
    final consultation = _moduleConsultant.consult(
      response: interpreted,
      plan: plan,
    );
    final enrichedPlan = consultation.plan;
    final nextAction = _nextRecommendedAction(interpreted);
    final friendlyMessage = _enrichFriendlyMessage(
      base: interpreted.friendlyMessage,
      moduleResults: consultation.results,
    );

    return interpreted.copyWith(
      executionPlan: enrichedPlan,
      requiredConfirmations: enrichedPlan.stepsRequiringConfirmation,
      blockedSteps: enrichedPlan.blockedSteps,
      readySteps: enrichedPlan.readySteps,
      warnings: enrichedPlan.warnings,
      nextRecommendedAction: nextAction,
      moduleResults: consultation.results,
      consultedModules: consultation.consultedModules,
      unavailableModules: consultation.unavailableModules,
      integrationWarnings: consultation.warnings,
      friendlyMessage: friendlyMessage,
    );
  }

  /// Exposed for tests — write execution must remain disabled by default.
  AssistantCapabilities get capabilities => _capabilities;

  static AssistantAction _nextRecommendedAction(AssistantResponse response) {
    if (response.questions.isNotEmpty) {
      return const AssistantAction(
        type: AssistantActionType.askQuestion,
        available: true,
        label: 'Informar dados faltantes',
      );
    }
    for (final action in response.actions) {
      if (action.type == AssistantActionType.reviewDraft && action.available) {
        return action;
      }
    }
    return const AssistantAction(
      type: AssistantActionType.none,
      available: false,
      label: 'Nenhuma ação recomendada',
    );
  }

  static String _enrichFriendlyMessage({
    required String base,
    required List<AssistantModuleResponse> moduleResults,
  }) {
    if (moduleResults.isEmpty) return base;
    final parts = <String>[base];
    for (final result in moduleResults) {
      final payload = result.result;
      if (payload == null) continue;
      if (payload.found && payload.displayName != null) {
        parts.add(
          'Consulta: ${payload.summary} '
          '(id: ${payload.identifier ?? 'n/a'}).',
        );
      } else {
        parts.add('Consulta: ${payload.summary}.');
      }
    }
    parts.add('Nenhum dado do ERP foi alterado.');
    return parts.join(' ');
  }
}
