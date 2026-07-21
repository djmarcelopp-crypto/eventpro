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
import '../domain/audit/assistant_audit_event_factory.dart';
import '../domain/audit/assistant_audit_event_type.dart';
import '../domain/audit/assistant_audit_formatter.dart';
import '../domain/audit/assistant_audit_gateway.dart';
import '../domain/audit/assistant_audit_query.dart';
import '../domain/audit/assistant_audit_query_service.dart';
import '../domain/audit/assistant_audit_result.dart';
import '../domain/audit/assistant_audit_token_fingerprinter.dart';
import '../domain/audit/assistant_audit_warning.dart';
import '../domain/business/assistant_business_gateway.dart';
import '../domain/confirmation/assistant_confirmation_formatter.dart';
import '../domain/confirmation/assistant_confirmation_planner.dart';
import '../domain/conversation/assistant_conversation_planner.dart';
import '../domain/gateway/assistant_gateway.dart';
import '../domain/idempotency/assistant_idempotency_service.dart';
import '../domain/insight/assistant_insight_formatter.dart';
import '../domain/insight/assistant_insight_gateway.dart';
import '../domain/insight/assistant_insight_planner.dart';
import '../domain/business/reasoning/assistant_business_reasoning.dart';
import '../domain/business/reasoning/business_reasoning_metadata.dart';
import '../domain/business/reasoning/business_reasoning_request.dart';
import '../domain/gateway_intelligence/assistant_gateway_intelligence.dart';
import '../domain/gateway_intelligence/gateway_entity_kind.dart';
import '../domain/gateway_intelligence/gateway_query.dart';
import '../domain/gateway_intelligence/gateway_query_context.dart';
import '../domain/input/assistant_input_pipeline.dart';
import '../domain/context/assistant_context_pipeline.dart';
import '../domain/context/assistant_conversation_id.dart';
import '../domain/context/assistant_conversation_metadata.dart';
import '../domain/context/assistant_turn_identity.dart';
import '../domain/memory/assistant_memory_keys.dart';
import '../domain/memory/assistant_memory_search.dart';
import '../domain/model_provider/assistant_model.dart';
import '../domain/model_provider/assistant_model_message.dart';
import '../domain/model_provider/assistant_model_role.dart';
import '../domain/model_provider/assistant_provider_registry.dart';
import '../domain/vision/assistant_vision_core.dart';
import '../domain/vision/assistant_vision_port.dart';
import '../domain/vision/assistant_vision_result.dart';
import '../domain/vision/assistant_vision_types.dart';
import '../domain/observability/assistant_write_observer.dart';
import '../domain/read/assistant_read_gateway.dart';
import '../domain/transaction_execution/assistant_transaction_execution_formatter.dart';
import '../domain/transaction_execution/assistant_transaction_execution_gateway.dart';
import '../domain/transaction_execution/assistant_transaction_execution_metadata.dart';
import '../domain/transaction_execution/assistant_transaction_execution_outcome.dart';
import '../domain/transaction_execution/assistant_transaction_execution_planner.dart';
import '../domain/transaction_execution/assistant_transaction_execution_result.dart';
import '../domain/workflow/assistant_workflow_business_context.dart';
import '../domain/workflow/assistant_workflow_context.dart';
import '../domain/workflow/assistant_workflow_executor.dart';
import '../domain/workflow/assistant_workflow_formatter.dart';
import '../domain/workflow/assistant_workflow_planner.dart';
import '../domain/workflow/assistant_workflow_result.dart';
import '../domain/write/assistant_write_gateway.dart';
import '../models/assistant_action.dart';
import '../models/assistant_action_presentation.dart';
import '../models/assistant_action_result.dart';
import '../models/assistant_action_type.dart';
import '../models/assistant_audit_intent.dart';
import '../models/assistant_audit_presentation.dart';
import '../models/assistant_context.dart';
import '../models/assistant_confidence.dart';
import '../models/assistant_confirmation_operation_kind.dart';
import '../models/assistant_confirmation_presentation.dart';
import '../models/assistant_confirmation_result.dart';
import '../models/assistant_conversation_presentation.dart';
import '../models/assistant_entity_type.dart';
import '../models/assistant_execution_context.dart';
import '../models/assistant_execution_mode.dart';
import '../models/assistant_execution_policy.dart';
import '../models/assistant_execution_request.dart';
import '../models/assistant_execution_token.dart';
import '../models/assistant_insight_presentation.dart';
import '../models/assistant_insight_result.dart';
import '../models/assistant_intent.dart';
import '../models/assistant_intent_type.dart';
import '../models/assistant_module_response.dart';
import '../models/assistant_parse_issue.dart';
import '../models/assistant_parse_issue_type.dart';
import '../models/assistant_parse_result.dart';
import '../models/assistant_read_presentation.dart';
import '../models/assistant_read_result.dart';
import '../models/assistant_request.dart';
import '../models/assistant_response.dart';
import '../models/assistant_safe_confirmation_intent.dart';
import '../models/assistant_transaction_execution_presentation.dart';
import '../models/assistant_transaction_plan_fingerprint.dart';
import '../models/assistant_workflow_presentation.dart';
import '../models/assistant_write_preparation.dart';
import '../models/assistant_write_result.dart';
import '../parsers/local_assistant_parser.dart';
import 'assistant_capabilities.dart';
import 'assistant_confirmation_session_registry.dart';
import 'assistant_conversation_session_registry.dart';
import 'assistant_draft_builder.dart';
import 'assistant_input_factory.dart';
import 'assistant_module_consultant.dart';
import 'local_assistant_action_formatter.dart';
import 'local_assistant_action_gateway.dart';
import 'local_assistant_action_intent_resolver.dart';
import 'local_assistant_action_planner.dart';
import 'local_assistant_audit_emitter.dart';
import 'local_assistant_audit_event_factory.dart';
import 'local_assistant_audit_formatter.dart';
import 'local_assistant_audit_gateway.dart';
import 'local_assistant_audit_intent_resolver.dart';
import 'local_assistant_audit_query_service.dart';
import 'local_assistant_confirmation_formatter.dart';
import 'local_assistant_confirmation_planner.dart';
import 'local_assistant_conversation_planner.dart';
import 'local_assistant_execution_dispatcher.dart';
import 'local_assistant_execution_planner.dart';
import 'local_assistant_idempotency_service.dart';
import 'local_assistant_insight_formatter.dart';
import 'local_assistant_insight_intent_resolver.dart';
import 'local_assistant_insight_planner.dart';
import 'local_assistant_input_pipeline.dart';
import 'local_assistant_context_pipeline.dart';
import 'local_assistant_business_reasoning.dart';
import 'local_assistant_gateway_intelligence.dart';
import 'local_assistant_intent_classifier.dart';
import 'local_assistant_persistent_memory.dart';
import 'local_assistant_provider_registry.dart';
import 'local_assistant_provider_selector.dart';
import 'local_assistant_vision_router.dart';
import 'local_assistant_read_coordinator.dart';
import 'local_mock_model_provider.dart';
import 'local_mock_vision_engine.dart';
import 'local_assistant_read_formatter.dart';
import 'local_assistant_read_query_factory.dart';
import 'local_assistant_response_builder.dart';
import 'local_assistant_safe_confirmation_intent_resolver.dart';
import 'local_assistant_transaction_execution_formatter.dart';
import 'local_assistant_transaction_execution_gateway.dart';
import 'local_assistant_transaction_execution_intent_resolver.dart';
import 'local_assistant_transaction_execution_planner.dart';
import 'local_assistant_workflow_bridge.dart';
import 'local_assistant_workflow_executor.dart';
import 'local_assistant_workflow_formatter.dart';
import 'local_assistant_workflow_intent_resolver.dart';
import 'local_assistant_workflow_planner.dart';
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
    AssistantAuditGateway? auditGateway,
    AssistantAuditEventFactory? auditEventFactory,
    AssistantAuditTokenFingerprinter? auditTokenFingerprinter,
    LocalAssistantAuditEmitter? auditEmitter,
    LocalAssistantAuditIntentResolver? auditIntentResolver,
    AssistantAuditQueryService? auditQueryService,
    AssistantAuditFormatter? auditFormatter,
    LocalAssistantWorkflowIntentResolver? workflowIntentResolver,
    AssistantWorkflowPlanner? workflowPlanner,
    AssistantWorkflowExecutor? workflowExecutor,
    AssistantWorkflowFormatter? workflowFormatter,
    AssistantBusinessGateway? businessGateway,
    AssistantInputPipeline? inputPipeline,
    AssistantContextPipeline? contextPipeline,
    LocalAssistantPersistentMemory? persistentMemory,
    AssistantProviderRegistry? providerRegistry,
    AssistantProviderSelector? providerSelector,
    AssistantVisionRouter? visionRouter,
    AssistantGatewayIntelligence? gatewayIntelligence,
    AssistantBusinessReasoning? businessReasoning,
    this._executionMode = AssistantExecutionMode.dryRun,
    Set<String> confirmedStepIds = const {},
    DateTime Function()? clock,
  })  : _writeGateway = writeGateway,
        _readGateway = readGateway,
        _insightGateway = insightGateway,
        _actionGateway = actionGateway ??
            LocalAssistantActionGateway(clock: clock),
        _capabilities = capabilities ?? AssistantCapabilities.localDefaults(),
        _inputPipeline = inputPipeline ?? LocalAssistantInputPipeline(),
        _persistentMemory = persistentMemory ??
            ((capabilities ?? const AssistantCapabilities())
                    .canUsePersistentMemory
                ? LocalAssistantPersistentMemory(clock: clock)
                : null),
        _providerRegistry = providerRegistry ??
            ((capabilities ?? const AssistantCapabilities()).canUseModelProvider
                ? () {
                    final registry = LocalAssistantProviderRegistry();
                    registry.register(LocalMockProvider.registration(
                      port: LocalMockProvider(clock: clock),
                    ));
                    return registry;
                  }()
                : LocalAssistantProviderRegistry()),
        _providerSelector =
            providerSelector ?? const LocalAssistantProviderSelector(),
        _visionRouter = visionRouter ??
            ((capabilities ?? const AssistantCapabilities()).canUseVisionEngine
                ? () {
                    final router = LocalAssistantVisionRouter();
                    router.register(
                      LocalMockVisionEngine.registration(
                        port: LocalMockVisionEngine(clock: clock),
                      ),
                    );
                    return router;
                  }()
                : LocalAssistantVisionRouter()),
        _gatewayIntelligence = gatewayIntelligence ??
            LocalAssistantGatewayIntelligence(gateway: gateway),
        _businessReasoning =
            businessReasoning ?? const LocalAssistantBusinessReasoning(),
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
            const LocalAssistantTransactionExecutionFormatter(),
        _auditGateway = auditGateway ?? LocalAssistantAuditGateway(),
        _auditEventFactory = auditEventFactory ??
            LocalAssistantAuditEventFactory(
              clock: clock,
              tokenFingerprinter: auditTokenFingerprinter,
            ),
        _auditIntentResolver =
            auditIntentResolver ?? const LocalAssistantAuditIntentResolver(),
        _auditFormatter =
            auditFormatter ?? const LocalAssistantAuditFormatter(),
        _workflowIntentResolver = workflowIntentResolver ??
            const LocalAssistantWorkflowIntentResolver(),
        _workflowPlanner =
            workflowPlanner ?? LocalAssistantWorkflowPlanner(clock: clock),
        _workflowFormatter =
            workflowFormatter ?? const LocalAssistantWorkflowFormatter() {
    _contextPipeline = contextPipeline ??
        LocalAssistantContextPipeline(
          persistentMemory: _persistentMemory,
        );
    _resolvedTransactionExecutionGateway = transactionExecutionGateway ??
        LocalAssistantTransactionExecutionGateway(
          writeCoordinator: _writeCoordinator,
          writeGateway: writeGateway,
          clock: clock,
        );
    _auditEmitter = auditEmitter ??
        LocalAssistantAuditEmitter(
          gateway: _auditGateway,
          factory: _auditEventFactory,
        );
    _auditQueryService = auditQueryService ??
        LocalAssistantAuditQueryService(gateway: _auditGateway);
    _workflowExecutor = workflowExecutor ??
        LocalAssistantWorkflowExecutor(
          registry: const LocalAssistantWorkflowBridge().buildRegistry(
            confirmationPlanner: _confirmationPlanner,
            confirmationSessions: _confirmationSessions,
            auditQueryService: _auditQueryService,
            actionGateway: _actionGateway,
            insightGateway: _insightGateway,
            businessGateway: businessGateway,
            clock: clock,
          ),
          clock: clock,
        );
  }

  final AssistantCapabilities _capabilities;
  final AssistantInputPipeline _inputPipeline;
  late final AssistantContextPipeline _contextPipeline;
  final LocalAssistantPersistentMemory? _persistentMemory;
  final AssistantProviderRegistry _providerRegistry;
  final AssistantProviderSelector _providerSelector;
  final AssistantVisionRouter _visionRouter;
  final AssistantGatewayIntelligence _gatewayIntelligence;
  final AssistantBusinessReasoning _businessReasoning;
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
  final AssistantAuditGateway _auditGateway;
  final AssistantAuditEventFactory _auditEventFactory;
  late final LocalAssistantAuditEmitter _auditEmitter;
  final LocalAssistantAuditIntentResolver _auditIntentResolver;
  late final AssistantAuditQueryService _auditQueryService;
  final AssistantAuditFormatter _auditFormatter;
  final LocalAssistantWorkflowIntentResolver _workflowIntentResolver;
  final AssistantWorkflowPlanner _workflowPlanner;
  late final AssistantWorkflowExecutor _workflowExecutor;
  final AssistantWorkflowFormatter _workflowFormatter;

  AssistantAuditGateway get auditGateway => _auditGateway;

  @override
  Future<AssistantResponse> handle(AssistantRequest request) async {
    var effectiveRequest = request;

    if (_capabilities.canUseMultimodalInput) {
      final multimodal = await _inputPipeline.run(
        AssistantInputFactory.fromRequest(request),
      );
      if (!multimodal.readyForInterpretation) {
        return _buildMultimodalBlockedResponse(request, multimodal);
      }
      final normalized = multimodal.normalizedText;
      if (normalized != null && normalized.isNotEmpty) {
        final hints = <String>[
          ...?request.context?.hints,
          'inputId:${multimodal.inputId}',
          'correlationId:${multimodal.correlationId}',
          'inputStatus:${multimodal.normalization.status.name}',
        ];
        effectiveRequest = request.copyWith(
          rawText: normalized,
          context: (request.context ?? const AssistantContext()).copyWith(
            hints: hints,
          ),
        );
      }
    }

    if (_capabilities.canUseVisionEngine) {
      // AI-026: structured visual facts only — never decisions / workflows.
      final visionRequest = _buildVisionRequest(effectiveRequest);
      if (visionRequest != null) {
        final selection = _visionRouter.select(
          AssistantVisionSelectionCriteria(
            inputType: visionRequest.input.type,
            mimeType: visionRequest.input.reference.mimeType,
            requiredCapabilities: visionRequest.requestedCapabilities,
          ),
        );
        if (selection != null) {
          final vision = await selection.port.analyze(visionRequest);
          final hints = <String>[
            ...?effectiveRequest.context?.hints,
            'visionEngine:${vision.engineId}',
            'visionStatus:${vision.status.name}',
            'visionConfidence:${vision.confidence.name}',
            'visionDocType:${vision.document.documentType.name}',
            'visionEntities:${vision.entities.length}',
            for (final s in vision.signals.take(6))
              'visionSignal:${s.code}',
            if (vision.error != null) 'visionError:${vision.error!.code.name}',
          ];
          effectiveRequest = effectiveRequest.copyWith(
            context:
                (effectiveRequest.context ?? const AssistantContext()).copyWith(
              hints: hints,
            ),
          );
        }
      }
    }

    if (_capabilities.canUseContextEngine) {
      // AR-002: conversationId shares sessionId when present; never invents
      // sessionId for AI-010 (see AssistantConversationOwnership).
      final identity = AssistantTurnIdentity.resolve(effectiveRequest);
      final conversationId =
          AssistantConversationId(identity.conversationId);
      final contextResult = _contextPipeline.run(
        AssistantContextPipelineRequest(
          conversationId: conversationId,
          requestId: effectiveRequest.id,
          now: _clock(),
          metadata: AssistantConversationMetadata(
            sessionId: identity.sessionId,
            locale: effectiveRequest.locale,
            timezone: effectiveRequest.timezone,
            origin: effectiveRequest.origin.name,
            correlationId: identity.correlationId,
          ),
          correlationId: identity.correlationId,
          normalizedInputText: effectiveRequest.rawText,
          autoSummarize: false,
          commitTurn: false,
        ),
      );
      final hints = <String>[
        ...?effectiveRequest.context?.hints,
        ...contextResult.executionContext.traceHints,
        'conversationId:${identity.conversationId}',
        'correlationId:${identity.correlationId}',
        if (identity.sessionId != null) 'sessionId:${identity.sessionId}',
        if (contextResult.conversation.summary.text.isNotEmpty)
          'summary:${contextResult.conversation.summary.text}',
      ];
      effectiveRequest = effectiveRequest.copyWith(
        context: (effectiveRequest.context ?? const AssistantContext()).copyWith(
          hints: hints,
        ),
      );
    } else if (_capabilities.canUsePersistentMemory &&
        _persistentMemory != null) {
      // AI-024: memory hints without Context Engine (still opt-in).
      final identity = AssistantTurnIdentity.resolve(effectiveRequest);
      final memResult = _persistentMemory.searchSync(
        AssistantMemorySearch(
          sessionId: identity.sessionId,
          keys: const [
            AssistantMemoryKeys.lastClient,
            AssistantMemoryKeys.lastQuote,
            AssistantMemoryKeys.lastEvent,
            AssistantMemoryKeys.lastSupplier,
            AssistantMemoryKeys.lastDecision,
            AssistantMemoryKeys.lastWorkflow,
            AssistantMemoryKeys.lastCapability,
            AssistantMemoryKeys.lastEntity,
          ],
          limit: 16,
        ),
      );
      final memHints = <String>[
        'persistentMemory:${memResult.entries.length}',
        for (final e in memResult.entries)
          'mem:${e.key}:${e.value ?? ''}:${e.metadata.confidence.toStringAsFixed(2)}',
      ];
      effectiveRequest = effectiveRequest.copyWith(
        context: (effectiveRequest.context ?? const AssistantContext()).copyWith(
          hints: [
            ...?effectiveRequest.context?.hints,
            ...memHints,
          ],
        ),
      );
    }

    // AR-002: single identity + single request instance for all pipelines.
    final turnIdentity = AssistantTurnIdentity.resolve(effectiveRequest);
    final sessionId = turnIdentity.sessionId;

    final parseResult = _parser.parse(effectiveRequest);

    if (_capabilities.canUseGatewayIntelligence) {
      final giQuery = _buildGatewayIntelligenceQuery(
        request: effectiveRequest,
        parseResult: parseResult,
      );
      if (giQuery != null) {
        final giResult = await _gatewayIntelligence.suggestEntities(giQuery);
        if (giResult.isNotEmpty) {
          final hints = <String>[
            ...?effectiveRequest.context?.hints,
            'gatewayIntelligence:${giResult.length}',
            for (final m in giResult.take(5))
              'giCandidate:${m.reference.kind.name}:${m.reference.id}:${m.reference.label ?? ''}:${m.confidence.toStringAsFixed(2)}',
          ];
          effectiveRequest = effectiveRequest.copyWith(
            context:
                (effectiveRequest.context ?? const AssistantContext()).copyWith(
              hints: hints,
            ),
          );
        }
      }
    }

    final intents = _intentClassifier.classify(
      request: effectiveRequest,
      parseResult: parseResult,
    );
    final primary = intents.first;
    final List<AssistantIntent> alternatives =
        intents.length > 1 ? intents.sublist(1) : const <AssistantIntent>[];

    if (_capabilities.canUseBusinessReasoning) {
      final reasoningRequest = _buildBusinessReasoningRequest(
        request: effectiveRequest,
        intentLabel: primary.type.name,
      );
      final reasoning =
          await _businessReasoning.evaluate(reasoningRequest);
      final hints = <String>[
        ...?effectiveRequest.context?.hints,
        'businessReasoning:${reasoning.decision.kind.name}',
        'businessReasoningConfidence:${reasoning.decision.confidence.name}',
        for (final s in reasoning.suggestions.take(3))
          'brSuggestion:${s.code}:${s.message}',
        for (final line in reasoning.explanations.take(4))
          'brExplain:$line',
      ];
      effectiveRequest = effectiveRequest.copyWith(
        context: (effectiveRequest.context ?? const AssistantContext()).copyWith(
          hints: hints,
        ),
      );
    }

    if (_capabilities.canUseModelProvider) {
      // AI-025: provider abstraction only — hints, no vendor / no response change.
      final selection = _providerSelector.select(
        registry: _providerRegistry,
        criteria: const AssistantProviderSelectionCriteria(
          requiredCapabilities: {AssistantModelCapability.text},
          allowFallback: true,
        ),
      );
      if (selection != null) {
        final health = await selection.port.health();
        final probe = await selection.port.complete(
          AssistantModelRequest(
            messages: [
              AssistantModelMessage(
                role: AssistantModelRole.user,
                content: effectiveRequest.rawText,
              ),
            ],
            metadata: AssistantModelMetadata(
              origin: 'orchestrator',
              correlationId: turnIdentity.correlationId,
              sessionId: turnIdentity.sessionId,
            ),
          ),
        );
        final hints = <String>[
          ...?effectiveRequest.context?.hints,
          'modelProvider:${selection.provider.id}',
          'modelProviderReason:${selection.reason}',
          'modelProviderHealth:${health.status.name}',
          'modelProviderModel:${probe.modelId}',
          'modelProviderTokens:${probe.usage.totalTokens}',
          for (final c in selection.provider.capabilities.capabilities.take(6))
            'modelCapability:${c.name}',
        ];
        effectiveRequest = effectiveRequest.copyWith(
          context:
              (effectiveRequest.context ?? const AssistantContext()).copyWith(
            hints: hints,
          ),
        );
      }
    }

    final eventDraft = AssistantDraftBuilder.buildEventDraft(
      sourceText: effectiveRequest.rawText,
      entities: parseResult.entities,
    );
    final quoteDraft = AssistantDraftBuilder.buildQuoteDraft(
      entities: parseResult.entities,
    );

    final interpreted = _responseBuilder.build(
      request: effectiveRequest,
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
      id: 'exec-${effectiveRequest.id}',
      context: AssistantExecutionContext(
        requestId: effectiveRequest.id,
        token: AssistantExecutionToken(
          'tok-${effectiveRequest.id}-${_clock().millisecondsSinceEpoch}',
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

    // sessionId from turnIdentity (AR-002) — AI-010 reads same identity.
    final session = turnIdentity.hasSession
        ? _conversationSessions.getOrCreate(sessionId!)
        : null;

    // AI-016 workflow engine — multi-step composition of existing pipelines.
    AssistantWorkflowResult? workflowResult;
    AssistantWorkflowPresentation? workflowPresentation;
    final workflowIntent = _workflowIntentResolver.resolve(
      request: effectiveRequest,
      capabilities: _capabilities,
    );
    if (workflowIntent != null && _capabilities.canExecuteWorkflow) {
      final planned = _workflowPlanner.plan(
        workflowIntent,
        requestId: effectiveRequest.id,
        request: effectiveRequest,
      );
      if (planned != null) {
        // AR-002: seed planner metadata into context (nodes not executed).
        final initialContext = const AssistantWorkflowContext()
            .withResolvedCapabilities(planned.resolvedCapabilities)
            .withCapabilityExecutionNodes(planned.capabilityExecutionNodes)
            .withResolvedCommands(planned.resolvedCommands)
            .withCommandExecutionNodes(planned.commandExecutionNodes);
        workflowResult = await _workflowExecutor.execute(
          workflow: planned,
          request: effectiveRequest,
          initialContext: initialContext,
        );
        workflowPresentation = _workflowFormatter.format(workflowResult);
      }
    }

    // AI-014 transaction execution takes the turn when execute intent matches.
    AssistantTransactionExecutionResult? transactionExecutionResult;
    AssistantTransactionExecutionPresentation?
        transactionExecutionPresentation;
    final auditWarnings = <AssistantAuditWarning>[];
    final auditEnabled = _capabilities.canExecuteAuditTrail;
    final transactionIntent = _transactionExecutionIntentResolver.resolve(
      request: effectiveRequest,
      capabilities: _capabilities,
    );
    if (workflowPresentation == null &&
        transactionIntent != null &&
        _capabilities.canExecuteTransactionExecution) {
      final confirmationSession = (sessionId != null && sessionId.isNotEmpty)
          ? _confirmationSessions.getOrCreate(sessionId)
          : null;
      final approved = confirmationSession?.pending?.approvedAttributes;
      final proposedAttributes = (approved != null && approved.isNotEmpty)
          ? approved
          : (writeRequest?.attributes.isNotEmpty == true
              ? writeRequest!.attributes
              : AssistantTransactionPlanFingerprint
                  .defaultQuoteDraftAttributes);

      var blockedByAudit = false;
      final pending = confirmationSession?.pending;
      if (auditEnabled &&
          sessionId != null &&
          sessionId.isNotEmpty &&
          pending != null &&
          pending.isConfirmedAwaitingExecution) {
        final preWarn = _auditEmitter.emitExecutionRequested(
          sessionId: sessionId,
          rawToken: pending.token.value,
          planFingerprint: pending.approvedPlanFingerprint,
          operationKind: pending.operationKind.name,
        );
        if (preWarn != null) {
          blockedByAudit = true;
          auditWarnings.add(preWarn);
          transactionExecutionResult = AssistantTransactionExecutionResult(
            requestId: effectiveRequest.id,
            outcome: AssistantTransactionExecutionOutcome.invalidConfirmation,
            valid: false,
            executed: false,
            summary:
                'Execução bloqueada: falha ao registrar auditoria prévia.',
            warnings: const [],
            metadata: AssistantTransactionExecutionMetadata(
              requestId: effectiveRequest.id,
              generatedAt: _clock().toUtc(),
              sessionId: sessionId,
            ),
          );
        }
      }

      if (!blockedByAudit) {
        final planned = _transactionExecutionPlanner.plan(
          intent: transactionIntent,
          requestId: effectiveRequest.id,
          sessionId: sessionId,
          session: confirmationSession,
          proposedOperationKind:
              AssistantConfirmationOperationKind.createQuoteDraft,
          proposedAttributes: proposedAttributes,
        );
        if (planned.rejection != null) {
          transactionExecutionResult = planned.rejection;
          if (auditEnabled && sessionId != null && sessionId.isNotEmpty) {
            final raw = confirmationSession?.pending?.token.value ??
                planned.rejection!.metadata.token;
            final warn = _auditEmitter.emitExecutionRejected(
              planned.rejection!,
              sessionId: sessionId,
              rawToken: raw,
              planFingerprint: planned.rejection!.metadata.planFingerprint,
            );
            if (warn != null) auditWarnings.add(warn);
          }
        } else if (planned.request != null) {
          final txRequest = planned.request!;
          final executed = await _resolvedTransactionExecutionGateway.execute(
            request: txRequest,
            context: executionRequest.context,
          );
          transactionExecutionResult = executed;
          if (auditEnabled && sessionId != null && sessionId.isNotEmpty) {
            final warn = _auditEmitter.emitExecutionFinished(
              executed,
              sessionId: sessionId,
              rawToken: txRequest.token.value,
              planFingerprint: txRequest.planFingerprint,
            );
            if (warn != null) auditWarnings.add(warn);
          }
        }
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
        workflowPresentation == null &&
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
    if (workflowPresentation == null &&
        transactionExecutionPresentation == null) {
      var confirmationIntent = _confirmationIntentResolver.resolve(
        request: effectiveRequest,
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
          requestId: effectiveRequest.id,
          sessionId: sessionId,
        );
        confirmationResult = _confirmationPlanner.process(
          request: confirmationRequest,
          session: confirmationSession,
        );
        confirmationPresentation =
            _confirmationFormatter.format(confirmationResult);
        if (auditEnabled && sessionId != null && sessionId.isNotEmpty) {
          final warn = _auditEmitter.emitConfirmation(
            confirmationResult,
            sessionId: sessionId,
          );
          if (warn != null) auditWarnings.add(warn);
        }
      }
    }

    AssistantAuditResult? auditResult;
    AssistantAuditPresentation? auditPresentation;
    AssistantActionResult? actionResult;
    AssistantActionPresentation? actionPresentation;
    AssistantInsightResult? insightResult;
    AssistantInsightPresentation? insightPresentation;

    // Lift nested results from workflow context when present.
    if (workflowResult != null) {
      final ctx = workflowResult.context;
      final liftedConfirmation =
          ctx['confirmationResult'] as AssistantConfirmationResult?;
      if (liftedConfirmation != null) {
        confirmationResult = liftedConfirmation;
        confirmationPresentation =
            _confirmationFormatter.format(liftedConfirmation);
      }
      final liftedAudit = ctx['auditResult'] as AssistantAuditResult?;
      if (liftedAudit != null) {
        auditResult = liftedAudit;
        auditPresentation = _auditFormatter.format(liftedAudit);
      }
      final liftedAction = ctx['actionResult'] as AssistantActionResult?;
      if (liftedAction != null) {
        actionResult = liftedAction;
        actionPresentation = _actionFormatter.format(liftedAction);
      }
      final liftedInsight = ctx['insightResult'] as AssistantInsightResult?;
      if (liftedInsight != null) {
        insightResult = liftedInsight;
        insightPresentation = _insightFormatter.format(liftedInsight);
      }
    }

    // AI-015 audit query pipeline (independent of insight/read/tx write path).
    if (workflowPresentation == null &&
        transactionExecutionPresentation == null &&
        confirmationPresentation == null) {
      final auditIntent = _auditIntentResolver.resolve(
        request: effectiveRequest,
        capabilities: _capabilities,
      );
      if (auditIntent is AuditStatusIntent &&
          _capabilities.canExecuteAuditTrail) {
        AssistantAuditEventType? typeFilter;
        if (auditIntent.byType != null) {
          for (final t in AssistantAuditEventType.values) {
            if (t.name == auditIntent.byType) {
              typeFilter = t;
              break;
            }
          }
        }
        auditResult = _auditQueryService.query(
          AssistantAuditQuery(
            requestId: effectiveRequest.id,
            sessionId: sessionId,
            eventType: typeFilter,
            latestOnly: auditIntent.latestOnly,
          ),
        );
        if (auditWarnings.isNotEmpty) {
          auditResult = AssistantAuditResult(
            requestId: auditResult.requestId,
            events: auditResult.events,
            totalMatched: auditResult.totalMatched,
            returnedCount: auditResult.returnedCount,
            query: auditResult.query,
            warnings: [...auditResult.warnings, ...auditWarnings],
            summary: auditResult.summary,
            valid: auditResult.valid,
          );
        }
        auditPresentation = _auditFormatter.format(auditResult);
      }
    }

    // AI-012 smart-action pipeline (independent of write/read/conversation/insight).
    if (workflowPresentation == null &&
        transactionExecutionPresentation == null &&
        confirmationPresentation == null &&
        auditPresentation == null) {
      final actionIntent = _actionIntentResolver.resolve(
        request: effectiveRequest,
        capabilities: _capabilities,
        session: session,
      );
      if (actionIntent != null && _capabilities.canExecuteSmartActions) {
        final actionRequest = _actionPlanner.plan(
          actionIntent,
          request: effectiveRequest,
        );
        actionResult = await _actionGateway.execute(actionRequest);
        actionPresentation = _actionFormatter.format(actionResult);
      }
    }

    // AI-011 insight pipeline (independent of read/conversation/write).
    if (workflowPresentation == null &&
        transactionExecutionPresentation == null &&
        confirmationPresentation == null &&
        auditPresentation == null &&
        actionPresentation == null) {
      final insightIntent = _insightIntentResolver.resolve(
        request: effectiveRequest,
        capabilities: _capabilities,
      );
      if (insightIntent != null &&
          _capabilities.canExecuteQuoteInsights &&
          _insightGateway != null) {
        final insightRequest = _insightPlanner.plan(
          insightIntent,
          requestId: effectiveRequest.id,
          referenceTimestamp: _clock().toUtc(),
        );
        insightResult = await _insightGateway.execute(insightRequest);
        insightPresentation = _insightFormatter.format(insightResult);
      }
    }

    AssistantReadResult? readResult;
    AssistantReadPresentation? readPresentation;
    AssistantConversationPresentation? conversationPresentation;

    // Preserve AI-009/AI-010 when prior pipelines did not handle.
    if (workflowPresentation == null &&
        transactionExecutionPresentation == null &&
        confirmationPresentation == null &&
        auditPresentation == null &&
        actionPresentation == null &&
        insightPresentation == null) {
      final conversationPlan = _conversationPlanner.plan(
        request: effectiveRequest,
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
              requestId: effectiveRequest.id,
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
      auditPresentation: auditPresentation,
      workflowPresentation: workflowPresentation,
      auditWarnings: auditWarnings,
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
      auditResult: auditResult,
      auditPresentation: auditPresentation,
      workflowResult: workflowResult,
      workflowPresentation: workflowPresentation,
      friendlyMessage: friendlyMessage,
    );
  }

  AssistantCapabilities get capabilities => _capabilities;

  LocalAssistantPersistentMemory? get persistentMemory => _persistentMemory;

  AssistantProviderRegistry get providerRegistry => _providerRegistry;

  AssistantVisionRouter get visionRouter => _visionRouter;

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
    AssistantAuditPresentation? auditPresentation,
    AssistantWorkflowPresentation? workflowPresentation,
    List<AssistantAuditWarning> auditWarnings = const [],
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
    if (workflowPresentation != null) {
      parts.add(workflowPresentation.naturalLanguage);
    } else if (transactionExecutionPresentation != null) {
      parts.add(transactionExecutionPresentation.naturalLanguage);
    } else if (confirmationPresentation != null) {
      parts.add(confirmationPresentation.naturalLanguage);
    } else if (auditPresentation != null) {
      parts.add(auditPresentation.naturalLanguage);
    } else if (actionPresentation != null) {
      parts.add(actionPresentation.naturalLanguage);
    } else if (insightPresentation != null) {
      parts.add(insightPresentation.naturalLanguage);
    } else if (conversationPresentation != null) {
      parts.add(conversationPresentation.naturalLanguage);
    } else if (readPresentation != null) {
      parts.add(readPresentation.naturalLanguage);
    }
    for (final warning in auditWarnings) {
      parts.add(warning.message);
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
      if (writePreparation != null &&
          transactionExecutionPresentation == null &&
          workflowPresentation == null) {
        parts.add(
          'A operação foi apenas preparada. '
          'Nenhuma alteração foi realizada no EventPRO.',
        );
      }
    } else if (transactionExecutionPresentation == null &&
        auditPresentation == null &&
        workflowPresentation == null) {
      parts.add(
        writePreparation?.writeResult.summary ??
            'Nenhuma alteração foi realizada no EventPRO.',
      );
    }
    return parts.join(' ');
  }

  /// Builds a vision request from attachment hints or filename-like rawText.
  /// Returns null when there is nothing visual to analyze (keeps flow intact).
  AssistantVisionRequest? _buildVisionRequest(AssistantRequest request) {
    final hints = request.context?.hints ?? const <String>[];
    String? ref;
    String? fileName;
    String? mimeType;

    for (final h in hints) {
      if (h.startsWith('visionRef:')) {
        ref = h.substring('visionRef:'.length);
      } else if (h.startsWith('attachment:')) {
        ref = h.substring('attachment:'.length);
      } else if (h.startsWith('fileName:')) {
        fileName = h.substring('fileName:'.length);
      } else if (h.startsWith('mimeType:')) {
        mimeType = h.substring('mimeType:'.length);
      }
    }

    final raw = request.rawText.trim();
    final looksVisual = raw.contains('.') ||
        raw.toLowerCase().contains('contrato') ||
        raw.toLowerCase().contains('orcamento') ||
        raw.toLowerCase().contains('orçamento') ||
        raw.toLowerCase().contains('comprovante') ||
        raw.toLowerCase().contains('palco') ||
        raw.toLowerCase().contains('energia') ||
        raw.toLowerCase().contains('qr');

    if (ref == null && fileName == null && !looksVisual) {
      return null;
    }

    final resolvedName = fileName ?? ref ?? raw;
    final resolvedUri = ref ?? 'ref:$resolvedName';
    final identity = AssistantTurnIdentity.resolve(request);

    return AssistantVisionRequest(
      input: AssistantVisionInput(
        type: _inferVisionInputType(resolvedName, mimeType),
        reference: AssistantVisionReference(
          uri: resolvedUri,
          fileName: resolvedName,
          mimeType: mimeType,
        ),
        locale: request.locale,
      ),
      metadata: AssistantVisionMetadata(
        correlationId: identity.correlationId,
        sessionId: identity.sessionId,
        requestId: request.id,
        origin: 'orchestrator',
        locale: request.locale,
      ),
    );
  }

  AssistantVisionInputType _inferVisionInputType(
    String label,
    String? mimeType,
  ) {
    final lower = label.toLowerCase();
    final mime = mimeType?.toLowerCase() ?? '';
    if (mime.startsWith('image/')) return AssistantVisionInputType.image;
    if (mime.contains('pdf') || lower.endsWith('.pdf')) {
      return AssistantVisionInputType.pdf;
    }
    if (lower.contains('contrato')) return AssistantVisionInputType.contract;
    if (lower.contains('orcamento') || lower.contains('orçamento')) {
      return AssistantVisionInputType.quote;
    }
    if (lower.contains('comprovante')) return AssistantVisionInputType.receipt;
    if (lower.contains('palco')) return AssistantVisionInputType.stagePhoto;
    if (lower.contains('qr')) return AssistantVisionInputType.qrCode;
    return AssistantVisionInputType.unknown;
  }

  BusinessReasoningRequest _buildBusinessReasoningRequest({
    required AssistantRequest request,
    required String intentLabel,
  }) {
    final hints = request.context?.hints ?? const <String>[];
    final giCandidates = hints
        .where((h) => h.startsWith('giCandidate:'))
        .map((h) => h.substring('giCandidate:'.length).split(':'))
        .where((p) => p.isNotEmpty)
        .toList(growable: false);
    final clientCandidates =
        giCandidates.where((p) => p.first == 'client').toList(growable: false);
    final ambiguous = hints.any((h) => h.startsWith('gatewayIntelligence:')) &&
        clientCandidates.length > 1;

    return BusinessReasoningRequest(
      requestId: request.id,
      intentLabel: intentLabel,
      clientCandidateCount: clientCandidates.length,
      clientFound: clientCandidates.length == 1,
      clientId: clientCandidates.length == 1 && clientCandidates.first.length > 1
          ? clientCandidates.first[1]
          : null,
      clientLabel: clientCandidates.length == 1 &&
              clientCandidates.first.length > 2
          ? clientCandidates.first[2]
          : null,
      gatewayAmbiguous: ambiguous,
      metadata: BusinessReasoningMetadata(
        correlationId: request.id,
        sessionId: request.context?.sessionId,
        evaluatedAt: _clock().toUtc(),
      ),
    );
  }

  /// AI-022: only runs when opt-in and the turn looks like entity discovery.
  GatewayQuery? _buildGatewayIntelligenceQuery({
    required AssistantRequest request,
    required AssistantParseResult parseResult,
  }) {
    final text = request.rawText.trim();
    if (text.isEmpty) return null;

    final folded = text.toLowerCase();
    final kinds = <GatewayEntityKind>[];
    String? queryText;

    final clientEntities = parseResult.entities
        .where((e) => e.type == AssistantEntityType.clientName)
        .map((e) => e.rawValue.trim())
        .where((v) => v.isNotEmpty)
        .toList(growable: false);
    final clientEntity =
        clientEntities.isEmpty ? null : clientEntities.first;

    if (clientEntity != null) {
      kinds.add(GatewayEntityKind.client);
      queryText = clientEntity;
    } else if (folded.contains('cliente') ||
        folded.contains('buscar') ||
        folded.startsWith('joão') ||
        folded.startsWith('joao')) {
      kinds.add(GatewayEntityKind.client);
      queryText = text
          .replaceAll(RegExp(r'buscar\s+cliente', caseSensitive: false), '')
          .replaceAll(RegExp(r'cliente', caseSensitive: false), '')
          .trim();
      if (queryText.isEmpty) queryText = text;
    }

    if (folded.contains('orçamento') || folded.contains('orcamento')) {
      kinds.add(GatewayEntityKind.quote);
      queryText ??= text;
    }
    if (folded.contains('evento') || folded.contains('casamento')) {
      kinds.add(GatewayEntityKind.event);
      queryText ??= text;
    }
    if (folded.contains('contrato')) {
      kinds.add(GatewayEntityKind.contract);
      queryText ??= text;
    }
    if (folded.contains('fornecedor')) {
      kinds.add(GatewayEntityKind.supplier);
      queryText ??= text;
    }

    if (kinds.isEmpty || queryText == null || queryText.trim().isEmpty) {
      return null;
    }

    return GatewayQuery(
      requestId: request.id,
      rawText: queryText.trim(),
      kinds: kinds,
      context: GatewayQueryContext(
        activeClientId: request.context?.activeClientId,
        activeQuoteId: request.context?.activeQuoteId,
        hints: request.context?.hints ?? const [],
        preferredKinds: kinds,
      ),
      metadata: GatewayQueryMetadata(
        correlationId: request.id,
        sessionId: request.context?.sessionId,
        locale: request.locale,
      ),
    );
  }

  AssistantResponse _buildMultimodalBlockedResponse(
    AssistantRequest request,
    AssistantInputPipelineResult multimodal,
  ) {
    final issues = multimodal.normalization.messages
        .map(
          (m) => AssistantParseIssue(
            type: AssistantParseIssueType.unsupported,
            message: m.message,
            details: [m.code, 'inputId:${multimodal.inputId}'],
          ),
        )
        .toList(growable: false);

    final parseResult = AssistantParseResult(
      entities: const [],
      issues: issues,
      normalizedText: '',
    );

    return _responseBuilder.build(
      request: request,
      parseResult: parseResult,
      primaryIntent: const AssistantIntent(
        type: AssistantIntentType.unknown,
        confidence: AssistantConfidence.none,
      ),
      alternativeIntents: const [],
      eventDraft: AssistantDraftBuilder.buildEventDraft(
        sourceText: request.rawText,
        entities: const [],
      ),
      quoteDraft: AssistantDraftBuilder.buildQuoteDraft(entities: const []),
      entities: const [],
      issues: issues,
    );
  }
}
