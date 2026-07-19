import '../domain/assistant_execution_dispatcher.dart';
import '../domain/assistant_execution_planner.dart';
import '../domain/assistant_intent_classifier.dart';
import '../domain/assistant_orchestrator.dart';
import '../domain/assistant_parser.dart';
import '../domain/assistant_response_builder.dart';
import '../domain/assistant_write_coordinator.dart';
import '../domain/gateway/assistant_gateway.dart';
import '../domain/write/assistant_write_gateway.dart';
import '../models/assistant_action.dart';
import '../models/assistant_action_type.dart';
import '../models/assistant_execution_context.dart';
import '../models/assistant_execution_mode.dart';
import '../models/assistant_execution_policy.dart';
import '../models/assistant_execution_request.dart';
import '../models/assistant_execution_token.dart';
import '../models/assistant_intent.dart';
import '../models/assistant_module_response.dart';
import '../models/assistant_request.dart';
import '../models/assistant_response.dart';
import '../models/assistant_write_preparation.dart';
import '../parsers/local_assistant_parser.dart';
import 'assistant_capabilities.dart';
import 'assistant_draft_builder.dart';
import 'assistant_module_consultant.dart';
import 'local_assistant_execution_dispatcher.dart';
import 'local_assistant_execution_planner.dart';
import 'local_assistant_intent_classifier.dart';
import 'local_assistant_response_builder.dart';
import 'local_assistant_write_coordinator.dart';
import 'local_assistant_write_intent_factory.dart';

/// Local orchestration pipeline with controlled optional ERP quote-draft write.
class LocalAssistantOrchestrator implements AssistantOrchestrator {
  LocalAssistantOrchestrator({
    AssistantParser? parser,
    AssistantIntentClassifier? intentClassifier,
    AssistantResponseBuilder? responseBuilder,
    AssistantExecutionPlanner? executionPlanner,
    AssistantCapabilities? capabilities,
    AssistantGateway? gateway,
    AssistantModuleConsultant? moduleConsultant,
    AssistantExecutionDispatcher? executionDispatcher,
    AssistantWriteCoordinator? writeCoordinator,
    LocalAssistantWriteIntentFactory? writeIntentFactory,
    AssistantWriteGateway? writeGateway,
    this._executionMode = AssistantExecutionMode.dryRun,
    Set<String> confirmedStepIds = const {},
    DateTime Function()? clock,
  })  : _writeGateway = writeGateway,
        _capabilities = capabilities ?? AssistantCapabilities.localDefaults(),
        _confirmedStepIds = Set.unmodifiable(confirmedStepIds),
        _clock = clock ?? DateTime.now,
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
            ),
        _executionDispatcher = executionDispatcher ??
            LocalAssistantExecutionDispatcher(
              capabilities:
                  capabilities ?? AssistantCapabilities.localDefaults(),
            ),
        _writeCoordinator =
            writeCoordinator ?? LocalAssistantWriteCoordinator(),
        _writeIntentFactory =
            writeIntentFactory ?? const LocalAssistantWriteIntentFactory();

  final AssistantCapabilities _capabilities;
  final AssistantExecutionMode _executionMode;
  final Set<String> _confirmedStepIds;
  final DateTime Function() _clock;
  final AssistantWriteGateway? _writeGateway;
  final AssistantParser _parser;
  final AssistantIntentClassifier _intentClassifier;
  final AssistantResponseBuilder _responseBuilder;
  final AssistantExecutionPlanner _executionPlanner;
  final AssistantModuleConsultant _moduleConsultant;
  final AssistantExecutionDispatcher _executionDispatcher;
  final AssistantWriteCoordinator _writeCoordinator;
  final LocalAssistantWriteIntentFactory _writeIntentFactory;

  @override
  Future<AssistantResponse> handle(AssistantRequest request) async {
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

    final policy = _executionMode == AssistantExecutionMode.production
        ? AssistantExecutionPolicy.ai006QuoteDraftProduction
        : AssistantExecutionPolicy.ai004Defaults;

    final executionRequest = AssistantExecutionRequest(
      id: 'exec-${request.id}',
      context: AssistantExecutionContext(
        requestId: request.id,
        token: AssistantExecutionToken(
          'tok-${request.id}-${_clock().millisecondsSinceEpoch}',
        ),
        mode: _executionMode,
        integrationMode: _capabilities.integrationMode,
        timestamp: _clock(),
        confirmedStepIds: _confirmedStepIds,
        policy: policy,
      ),
      plan: enrichedPlan,
      consultedDataSources: consultation.results
          .map((r) => r.dataSource)
          .toSet()
          .toList(growable: false),
    );

    final report = _executionDispatcher.dispatch(executionRequest);

    final writeRequest = _writeIntentFactory.fromPipeline(
      response: interpreted,
      plan: enrichedPlan,
    );

    AssistantWritePreparation? writePreparation;
    if (writeRequest != null) {
      final confirmationSatisfied = writeRequest.relatedStepId != null &&
          _confirmedStepIds.contains(writeRequest.relatedStepId);
      writePreparation = await _writeCoordinator.prepareAndMaybeExecute(
        request: writeRequest,
        context: executionRequest.context,
        confirmationSatisfied: confirmationSatisfied,
        writeGateway: _writeGateway,
      );
    }

    final mutated = writePreparation?.writeResult.mutatedErp ?? false;
    final enrichedReport = report.copyWith(
      mutatedErp: mutated,
      warnings: [
        ...report.warnings,
        if (writePreparation != null) ...writePreparation.writeWarnings,
      ],
      summary: mutated
          ? '${report.summary} Escrita real: quote draft criado.'
          : report.summary,
    );

    final nextAction = _nextRecommendedAction(interpreted);
    final friendlyMessage = _enrichFriendlyMessage(
      base: interpreted.friendlyMessage,
      moduleResults: consultation.results,
      reportSummary: enrichedReport.summary,
      writePreparation: writePreparation,
      mode: _executionMode,
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
      executionReport: enrichedReport,
      executionMode: enrichedReport.mode,
      executionAudit: enrichedReport.audit,
      executableSteps: enrichedReport.eligibleSteps,
      simulatedSteps: enrichedReport.simulatedSteps,
      skippedSteps: enrichedReport.skippedSteps,
      executionWarnings: enrichedReport.warnings,
      writeResult: writePreparation?.writeResult,
      writeValidation: writePreparation?.writeValidation,
      writeAuthorization: writePreparation?.writeAuthorization,
      writeWarnings: writePreparation?.writeWarnings ?? const [],
      friendlyMessage: friendlyMessage,
    );
  }

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
    required String reportSummary,
    AssistantWritePreparation? writePreparation,
    required AssistantExecutionMode mode,
  }) {
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
    parts.add(reportSummary);

    final write = writePreparation?.writeResult;
    if (write?.executed == true && write?.draftId != null) {
      parts.add(
        'O orçamento ${write!.draftNumber ?? write.draftId} foi criado '
        'em estado Draft. Nenhuma aprovação, envio ou faturamento ocorreu.',
      );
    } else if (mode == AssistantExecutionMode.dryRun ||
        mode == AssistantExecutionMode.simulation) {
      parts.add(
        'O assistente simulou a execução. Nenhuma alteração foi realizada no EventPRO.',
      );
      if (writePreparation != null) {
        parts.add(
          'A operação foi apenas preparada. '
          'Nenhuma alteração foi realizada no EventPRO.',
        );
      }
    } else {
      parts.add(
        writePreparation?.writeResult.summary ??
            'Nenhuma alteração foi realizada no EventPRO.',
      );
    }
    return parts.join(' ');
  }
}
