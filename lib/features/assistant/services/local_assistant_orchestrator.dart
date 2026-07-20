import '../domain/action/assistant_action_formatter.dart';
import '../domain/action/assistant_action_gateway.dart';
import '../domain/action/assistant_action_planner.dart';
import '../domain/assistant_execution_dispatcher.dart';
import '../domain/assistant_execution_planner.dart';
import '../domain/assistant_intent_classifier.dart';
import '../domain/assistant_orchestrator.dart';
import '../domain/assistant_parser.dart';
import '../domain/assistant_response_builder.dart';
import '../domain/assistant_write_coordinator.dart';
import '../domain/confirmation/assistant_confirmation_formatter.dart';
import '../domain/confirmation/assistant_confirmation_planner.dart';
import '../domain/conversation/assistant_conversation_planner.dart';
import '../domain/gateway/assistant_gateway.dart';
import '../domain/idempotency/assistant_idempotency_service.dart';
import '../domain/insight/assistant_insight_formatter.dart';
import '../domain/insight/assistant_insight_gateway.dart';
import '../domain/insight/assistant_insight_planner.dart';
import '../domain/observability/assistant_write_observer.dart';
import '../domain/read/assistant_read_gateway.dart';
import '../domain/transaction_execution/assistant_transaction_execution_formatter.dart';
import '../domain/transaction_execution/assistant_transaction_execution_gateway.dart';
import '../domain/transaction_execution/assistant_transaction_execution_planner.dart';
import '../domain/transaction_execution/assistant_transaction_execution_result.dart';
import '../domain/write/assistant_write_gateway.dart';
import '../models/assistant_action.dart';
import '../models/assistant_action_presentation.dart';
import '../models/assistant_action_result.dart';
import '../models/assistant_action_type.dart';
import '../models/assistant_confirmation_operation_kind.dart';
import '../models/assistant_confirmation_presentation.dart';
import '../models/assistant_confirmation_result.dart';
import '../models/assistant_conversation_presentation.dart';
import '../models/assistant_execution_context.dart';
import '../models/assistant_execution_mode.dart';
import '../models/assistant_execution_policy.dart';
import '../models/assistant_execution_request.dart';
import '../models/assistant_execution_token.dart';
import '../models/assistant_insight_presentation.dart';
import '../models/assistant_insight_result.dart';
import '../models/assistant_intent.dart';
import '../models/assistant_module_response.dart';
import '../models/assistant_read_presentation.dart';
import '../models/assistant_read_result.dart';
import '../models/assistant_request.dart';
import '../models/assistant_response.dart';
import '../models/assistant_safe_confirmation_intent.dart';
import '../models/assistant_transaction_execution_presentation.dart';
import '../models/assistant_transaction_plan_fingerprint.dart';
import '../models/assistant_write_preparation.dart';
import '../models/assistant_write_result.dart';
import '../parsers/local_assistant_parser.dart';
import 'assistant_capabilities.dart';
import 'assistant_confirmation_session_registry.dart';
import 'assistant_conversation_session_registry.dart';
import 'assistant_draft_builder.dart';
import 'assistant_module_consultant.dart';
import 'local_assistant_action_formatter.dart';
import 'local_assistant_action_gateway.dart';
import 'local_assistant_action_intent_resolver.dart';
import 'local_assistant_action_planner.dart';
import 'local_assistant_confirmation_formatter.dart';
import 'local_assistant_confirmation_planner.dart';
import 'local_assistant_conversation_planner.dart';
import 'local_assistant_execution_dispatcher.dart';
import 'local_assistant_execution_planner.dart';
import 'local_assistant_idempotency_service.dart';
import 'local_assistant_insight_formatter.dart';
import 'local_assistant_insight_intent_resolver.dart';
import 'local_assistant_insight_planner.dart';
import 'local_assistant_intent_classifier.dart';
import 'local_assistant_read_coordinator.dart';
import 'local_assistant_read_formatter.dart';
import 'local_assistant_read_query_factory.dart';
import 'local_assistant_response_builder.dart';
import 'local_assistant_safe_confirmation_intent_resolver.dart';
import 'local_assistant_transaction_execution_formatter.dart';
import 'local_assistant_transaction_execution_gateway.dart';
import 'local_assistant_transaction_execution_intent_resolver.dart';
import 'local_assistant_transaction_execution_planner.dart';
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
    AssistantIdempotencyService? idempotencyService,
    AssistantWriteObserver? writeObserver,
    AssistantReadGateway? readGateway,
    LocalAssistantReadCoordinator? readCoordinator,
    LocalAssistantReadQueryFactory? readQueryFactory,
    LocalAssistantReadFormatter? readFormatter,
    AssistantConversationSessionRegistry? conversationSessions,
    AssistantConversationPlanner? conversationPlanner,
    AssistantInsightGateway? insightGateway,
    LocalAssistantInsightIntentResolver? insightIntentResolver,
    AssistantInsightPlanner? insightPlanner,
    AssistantInsightFormatter? insightFormatter,
    AssistantActionGateway? actionGateway,
    LocalAssistantActionIntentResolver? actionIntentResolver,
    AssistantActionPlanner? actionPlanner,
    AssistantActionFormatter? actionFormatter,
    AssistantConfirmationSessionRegistry? confirmationSessions,
    LocalAssistantSafeConfirmationIntentResolver? confirmationIntentResolver,
    AssistantConfirmationPlanner? confirmationPlanner,
    AssistantConfirmationFormatter? confirmationFormatter,
    LocalAssistantTransactionExecutionIntentResolver?
        transactionExecutionIntentResolver,
    AssistantTransactionExecutionPlanner? transactionExecutionPlanner,
    AssistantTransactionExecutionGateway? transactionExecutionGateway,
    AssistantTransactionExecutionFormatter? transactionExecutionFormatter,
    this._executionMode = AssistantExecutionMode.dryRun,
    Set<String> confirmedStepIds = const {},
    DateTime Function()? clock,
  })  : _writeGateway = writeGateway,
        _readGateway = readGateway,
        _insightGateway = insightGateway,
        _actionGateway = actionGateway ??
            LocalAssistantActionGateway(clock: clock),
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
        _writeCoordinator = writeCoordinator ??
            LocalAssistantWriteCoordinator(
              idempotencyService:
                  idempotencyService ?? LocalAssistantIdempotencyService(),
              observer: writeObserver,
              clock: clock,
            ),
        _writeIntentFactory =
            writeIntentFactory ?? const LocalAssistantWriteIntentFactory(),
        _readCoordinator = readCoordinator ??
            LocalAssistantReadCoordinator(clock: clock),
        _readQueryFactory =
            readQueryFactory ?? const LocalAssistantReadQueryFactory(),
        _readFormatter = readFormatter ?? const LocalAssistantReadFormatter(),
        _conversationSessions = conversationSessions ??
            AssistantConversationSessionRegistry(clock: clock),
        _conversationPlanner = conversationPlanner ??
            const LocalAssistantConversationPlanner(),
        _insightIntentResolver = insightIntentResolver ??
            const LocalAssistantInsightIntentResolver(),
        _insightPlanner =
            insightPlanner ?? const LocalAssistantInsightPlanner(),
        _insightFormatter =
            insightFormatter ?? const LocalAssistantInsightFormatter(),
        _actionIntentResolver = actionIntentResolver ??
            const LocalAssistantActionIntentResolver(),
        _actionPlanner = actionPlanner ?? const LocalAssistantActionPlanner(),
        _actionFormatter =
            actionFormatter ?? const LocalAssistantActionFormatter(),
        _confirmationSessions = confirmationSessions ??
            AssistantConfirmationSessionRegistry(clock: clock),
        _confirmationIntentResolver = confirmationIntentResolver ??
            const LocalAssistantSafeConfirmationIntentResolver(),
        _confirmationPlanner = confirmationPlanner ??
            LocalAssistantConfirmationPlanner(clock: clock),
        _confirmationFormatter = confirmationFormatter ??
            const LocalAssistantConfirmationFormatter(),
        _transactionExecutionIntentResolver =
            transactionExecutionIntentResolver ??
                const LocalAssistantTransactionExecutionIntentResolver(),
        _transactionExecutionPlanner = transactionExecutionPlanner ??
            LocalAssistantTransactionExecutionPlanner(clock: clock),
        _transactionExecutionGateway = transactionExecutionGateway,
        _transactionExecutionFormatter = transactionExecutionFormatter ??
            const LocalAssistantTransactionExecutionFormatter() {
    _resolvedTransactionExecutionGateway = transactionExecutionGateway ??
        LocalAssistantTransactionExecutionGateway(
          writeCoordinator: _writeCoordinator,
          clock: clock,
        );
  }

  final AssistantCapabilities _capabilities;
  final AssistantExecutionMode _executionMode;
  final Set<String> _confirmedStepIds;
  final DateTime Function() _clock;
  final AssistantWriteGateway? _writeGateway;
  final AssistantReadGateway? _readGateway;
  final AssistantInsightGateway? _insightGateway;
  final AssistantActionGateway _actionGateway;
  final AssistantParser _parser;
  final AssistantIntentClassifier _intentClassifier;
  final AssistantResponseBuilder _responseBuilder;
  final AssistantExecutionPlanner _executionPlanner;
  final AssistantModuleConsultant _moduleConsultant;
  final AssistantExecutionDispatcher _executionDispatcher;
  final AssistantWriteCoordinator _writeCoordinator;
  final LocalAssistantWriteIntentFactory _writeIntentFactory;
  final LocalAssistantReadCoordinator _readCoordinator;
  final LocalAssistantReadQueryFactory _readQueryFactory;
  final LocalAssistantReadFormatter _readFormatter;
  final AssistantConversationSessionRegistry _conversationSessions;
  final AssistantConversationPlanner _conversationPlanner;
  final LocalAssistantInsightIntentResolver _insightIntentResolver;
  final AssistantInsightPlanner _insightPlanner;
  final AssistantInsightFormatter _insightFormatter;
  final LocalAssistantActionIntentResolver _actionIntentResolver;
  final AssistantActionPlanner _actionPlanner;
  final AssistantActionFormatter _actionFormatter;
  final AssistantConfirmationSessionRegistry _confirmationSessions;
  final LocalAssistantSafeConfirmationIntentResolver
      _confirmationIntentResolver;
  final AssistantConfirmationPlanner _confirmationPlanner;
  final AssistantConfirmationFormatter _confirmationFormatter;
  final LocalAssistantTransactionExecutionIntentResolver
      _transactionExecutionIntentResolver;
  final AssistantTransactionExecutionPlanner _transactionExecutionPlanner;
  final AssistantTransactionExecutionGateway? _transactionExecutionGateway;
  final AssistantTransactionExecutionFormatter _transactionExecutionFormatter;
  late final AssistantTransactionExecutionGateway
      _resolvedTransactionExecutionGateway;

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

    final sessionId = request.context?.sessionId?.trim();
    final session = (sessionId != null && sessionId.isNotEmpty)
        ? _conversationSessions.getOrCreate(sessionId)
        : null;

    // AI-014 transaction execution takes the turn when execute intent matches.
    AssistantTransactionExecutionResult? transactionExecutionResult;
    AssistantTransactionExecutionPresentation?
        transactionExecutionPresentation;
    final transactionIntent = _transactionExecutionIntentResolver.resolve(
      request: request,
      capabilities: _capabilities,
    );
    if (transactionIntent != null &&
        _capabilities.canExecuteTransactionExecution) {
      final confirmationSession = (sessionId != null && sessionId.isNotEmpty)
          ? _confirmationSessions.getOrCreate(sessionId)
          : null;
      // Propose the approved plan from the confirmed pending (divergence
      // checks still apply when callers inject a custom planner/attrs).
      final approved = confirmationSession?.pending?.approvedAttributes;
      final proposedAttributes = (approved != null && approved.isNotEmpty)
          ? approved
          : (writeRequest?.attributes.isNotEmpty == true
              ? writeRequest!.attributes
              : AssistantTransactionPlanFingerprint
                  .defaultQuoteDraftAttributes);
      final planned = _transactionExecutionPlanner.plan(
        intent: transactionIntent,
        requestId: request.id,
        sessionId: sessionId,
        session: confirmationSession,
        proposedOperationKind:
            AssistantConfirmationOperationKind.createQuoteDraft,
        proposedAttributes: proposedAttributes,
      );
      if (planned.rejection != null) {
        transactionExecutionResult = planned.rejection;
      } else if (planned.request != null) {
        transactionExecutionResult =
            await _resolvedTransactionExecutionGateway.execute(
          request: planned.request!,
          context: executionRequest.context,
          writeGateway: _writeGateway,
        );
      }
      if (transactionExecutionResult != null) {
        transactionExecutionPresentation =
            _transactionExecutionFormatter.format(transactionExecutionResult);
      }
    }

    // Pipeline write: when AI-014 is enabled, Create Quote Draft writes only
    // via TransactionExecutionGateway (not the early write path).
    AssistantWritePreparation? writePreparation;
    final skipPipelineQuoteWrite =
        _capabilities.canExecuteTransactionExecution &&
            writeRequest != null &&
            writeRequest.isAi006QuoteDraft;
    if (writeRequest != null &&
        !skipPipelineQuoteWrite &&
        transactionExecutionPresentation == null) {
      final confirmationSatisfied = writeRequest.relatedStepId != null &&
          _confirmedStepIds.contains(writeRequest.relatedStepId);
      writePreparation = await _writeCoordinator.prepareAndMaybeExecute(
        request: writeRequest,
        context: executionRequest.context,
        confirmationSatisfied: confirmationSatisfied,
        writeGateway: _writeGateway,
      );
    }

    // AI-013 safe confirmation pipeline (lifecycle only — no ERP write).
    AssistantConfirmationResult? confirmationResult;
    AssistantConfirmationPresentation? confirmationPresentation;
    if (transactionExecutionPresentation == null) {
      var confirmationIntent = _confirmationIntentResolver.resolve(
        request: request,
        capabilities: _capabilities,
      );
      if (confirmationIntent is CreateConfirmationIntent) {
        final attrs = writeRequest?.attributes.isNotEmpty == true
            ? writeRequest!.attributes
            : AssistantTransactionPlanFingerprint.defaultQuoteDraftAttributes;
        confirmationIntent = CreateConfirmationIntent(
          operationKind: confirmationIntent.operationKind,
          approvedAttributes: attrs,
        );
      }
      if (confirmationIntent != null &&
          _capabilities.canExecuteSafeConfirmation) {
        final confirmationSession = (sessionId != null && sessionId.isNotEmpty)
            ? _confirmationSessions.getOrCreate(sessionId)
            : null;
        final confirmationRequest = _confirmationPlanner.planRequest(
          confirmationIntent,
          requestId: request.id,
          sessionId: sessionId,
        );
        confirmationResult = _confirmationPlanner.process(
          request: confirmationRequest,
          session: confirmationSession,
        );
        confirmationPresentation =
            _confirmationFormatter.format(confirmationResult);
      }
    }

    // AI-012 smart-action pipeline (independent of write/read/conversation/insight).
    AssistantActionResult? actionResult;
    AssistantActionPresentation? actionPresentation;
    if (transactionExecutionPresentation == null &&
        confirmationPresentation == null) {
      final actionIntent = _actionIntentResolver.resolve(
        request: request,
        capabilities: _capabilities,
        session: session,
      );
      if (actionIntent != null && _capabilities.canExecuteSmartActions) {
        final actionRequest = _actionPlanner.plan(
          actionIntent,
          request: request,
        );
        actionResult = await _actionGateway.execute(actionRequest);
        actionPresentation = _actionFormatter.format(actionResult);
      }
    }

    // AI-011 insight pipeline (independent of read/conversation/write).
    AssistantInsightResult? insightResult;
    AssistantInsightPresentation? insightPresentation;
    if (transactionExecutionPresentation == null &&
        confirmationPresentation == null &&
        actionPresentation == null) {
      final insightIntent = _insightIntentResolver.resolve(
        request: request,
        capabilities: _capabilities,
      );
      if (insightIntent != null &&
          _capabilities.canExecuteQuoteInsights &&
          _insightGateway != null) {
        final insightRequest = _insightPlanner.plan(
          insightIntent,
          requestId: request.id,
          referenceTimestamp: _clock().toUtc(),
        );
        insightResult = await _insightGateway.execute(insightRequest);
        insightPresentation = _insightFormatter.format(insightResult);
      }
    }

    AssistantReadResult? readResult;
    AssistantReadPresentation? readPresentation;
    AssistantConversationPresentation? conversationPresentation;

    // Preserve AI-009/AI-010 when tx/confirmation/action/insight did not handle.
    if (transactionExecutionPresentation == null &&
        confirmationPresentation == null &&
        actionPresentation == null &&
        insightPresentation == null) {
      final conversationPlan = _conversationPlanner.plan(
        request: request,
        session: session,
        capabilities: _capabilities,
      );

      if (conversationPlan.missingContext) {
        conversationPresentation = AssistantConversationPresentation(
          naturalLanguage: conversationPlan.missingContextMessage ??
              LocalAssistantConversationPlanner.missingContextMessage,
          isFollowUp: true,
          missingContext: true,
          sessionId: session?.sessionId,
          contextVersion: session?.context.version ?? 0,
        );
      } else if (conversationPlan.contextualAnswer != null) {
        conversationPresentation = AssistantConversationPresentation(
          naturalLanguage: conversationPlan.contextualAnswer!,
          isFollowUp: true,
          sessionId: session?.sessionId,
          contextVersion: session?.context.version ?? 0,
        );
      } else if (conversationPlan.shouldExecuteRead) {
        final readIntent = conversationPlan.intent!;
        final readQuery = conversationPlan.query ??
            _readQueryFactory.planIntent(
              readIntent,
              requestId: request.id,
            );
        readResult = await _readCoordinator.execute(
          query: readQuery,
          capabilities: _capabilities,
          gateway: _readGateway,
        );
        readPresentation = _readFormatter.format(
          result: readResult,
          intent: readIntent,
        );
        if (session != null && readResult.valid) {
          session.rememberTurn(
            intent: readIntent,
            query: readQuery,
            result: readResult,
            focusedIndex: conversationPlan.focusIndex,
          );
        }
        conversationPresentation = AssistantConversationPresentation(
          naturalLanguage: readPresentation.naturalLanguage,
          isFollowUp: conversationPlan.isFollowUp,
          sessionId: session?.sessionId,
          contextVersion: session?.context.version ?? 0,
        );
      }
    }

    final txWrite = transactionExecutionResult?.writeResult;
    final mutated = writePreparation?.writeResult.mutatedErp == true ||
        txWrite?.mutatedErp == true;
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
      transactionWriteResult: txWrite,
      readPresentation: readPresentation,
      conversationPresentation: conversationPresentation,
      insightPresentation: insightPresentation,
      actionPresentation: actionPresentation,
      confirmationPresentation: confirmationPresentation,
      transactionExecutionPresentation: transactionExecutionPresentation,
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
      writeResult: txWrite ?? writePreparation?.writeResult,
      writeValidation: writePreparation?.writeValidation,
      writeAuthorization: writePreparation?.writeAuthorization,
      writeWarnings: writePreparation?.writeWarnings ?? const [],
      readResult: readResult,
      readPresentation: readPresentation,
      conversationPresentation: conversationPresentation,
      insightResult: insightResult,
      insightPresentation: insightPresentation,
      actionResult: actionResult,
      actionPresentation: actionPresentation,
      confirmationResult: confirmationResult,
      confirmationPresentation: confirmationPresentation,
      transactionExecutionResult: transactionExecutionResult,
      transactionExecutionPresentation: transactionExecutionPresentation,
      friendlyMessage: friendlyMessage,
    );
  }

  AssistantCapabilities get capabilities => _capabilities;

  AssistantConversationSessionRegistry get conversationSessions =>
      _conversationSessions;

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
    AssistantWriteResult? transactionWriteResult,
    AssistantReadPresentation? readPresentation,
    AssistantConversationPresentation? conversationPresentation,
    AssistantInsightPresentation? insightPresentation,
    AssistantActionPresentation? actionPresentation,
    AssistantConfirmationPresentation? confirmationPresentation,
    AssistantTransactionExecutionPresentation?
        transactionExecutionPresentation,
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
    if (transactionExecutionPresentation != null) {
      parts.add(transactionExecutionPresentation.naturalLanguage);
    } else if (confirmationPresentation != null) {
      parts.add(confirmationPresentation.naturalLanguage);
    } else if (actionPresentation != null) {
      parts.add(actionPresentation.naturalLanguage);
    } else if (insightPresentation != null) {
      parts.add(insightPresentation.naturalLanguage);
    } else if (conversationPresentation != null) {
      parts.add(conversationPresentation.naturalLanguage);
    } else if (readPresentation != null) {
      parts.add(readPresentation.naturalLanguage);
    }
    parts.add(reportSummary);

    final write = transactionWriteResult ?? writePreparation?.writeResult;
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
      if (writePreparation != null && transactionExecutionPresentation == null) {
        parts.add(
          'A operação foi apenas preparada. '
          'Nenhuma alteração foi realizada no EventPRO.',
        );
      }
    } else if (transactionExecutionPresentation == null) {
      parts.add(
        writePreparation?.writeResult.summary ??
            'Nenhuma alteração foi realizada no EventPRO.',
      );
    }
    return parts.join(' ');
  }
}
