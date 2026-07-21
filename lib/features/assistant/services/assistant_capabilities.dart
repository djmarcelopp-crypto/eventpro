import '../models/assistant_integration_mode.dart';

/// Locally configurable capability flags for the assistant planner/consultant.
///
/// Separates **planning** (may describe a step) from **execution** (may invoke
/// a registered read/write executor for the current configuration).
///
/// Important:
/// - `canExecuteClientSearch` / `canExecuteScheduleRead` /
///   `canExecuteAvailabilityRead` mean only that a **read executor may be
///   invoked** when a matching gateway is registered.
/// - They do **not** mean ERP database access, productive data, or a trusted
///   operational source. Trust/environment is [integrationMode] +
///   `AssistantModuleDataSource` on each result.
class AssistantCapabilities {
  const AssistantCapabilities({
    this.integrationMode = AssistantIntegrationMode.none,
    this.canPlanCreateEvent = true,
    this.canPlanCreateQuote = true,
    this.canPlanCheckSchedule = true,
    this.canPlanCheckAvailability = true,
    this.canPlanSearchClient = true,
    this.canPlanLookupQuote = false,
    this.canPlanSearchInventory = false,
    this.canPlanSearchTeam = false,
    this.canPlanStructuredQuoteRead = false,
    this.canPlanQuoteInsights = false,
    this.canPlanSmartActions = false,
    this.canPlanSafeConfirmation = false,
    this.canPlanTransactionExecution = false,
    this.canPlanAuditTrail = false,
    this.canPlanWorkflow = false,
    this.canPlanBusinessWorkflow = false,
    this.canExecuteCreateEvent = false,
    this.canExecuteCreateQuote = false,
    this.canExecuteScheduleRead = false,
    this.canExecuteAvailabilityRead = false,
    this.canExecuteClientSearch = false,
    this.canExecuteLookupQuote = false,
    this.canExecuteSearchInventory = false,
    this.canExecuteSearchTeam = false,
    this.canExecuteStructuredQuoteRead = false,
    this.canExecuteQuoteInsights = false,
    this.canExecuteSmartActions = false,
    this.canExecuteSafeConfirmation = false,
    this.canExecuteTransactionExecution = false,
    this.canExecuteAuditTrail = false,
    this.canExecuteWorkflow = false,
    this.canExecuteBusinessWorkflow = false,
    this.canUseOCR = false,
    this.canUseSpeech = false,
    this.canUseVision = false,
    this.canUseLLM = false,
    this.canUseMultimodalInput = false,
    this.canUseContextEngine = false,
    this.canUseGatewayIntelligence = false,
    this.canUseBusinessReasoning = false,
    this.canUsePersistentMemory = false,
  });

  /// Trust/environment level. ERP mode is reserved for a future approved adapter.
  final AssistantIntegrationMode integrationMode;

  // --- Planning ---
  final bool canPlanCreateEvent;
  final bool canPlanCreateQuote;
  final bool canPlanCheckSchedule;
  final bool canPlanCheckAvailability;
  final bool canPlanSearchClient;
  final bool canPlanLookupQuote;
  final bool canPlanSearchInventory;
  final bool canPlanSearchTeam;
  final bool canPlanStructuredQuoteRead;
  final bool canPlanQuoteInsights;
  final bool canPlanSmartActions;
  final bool canPlanSafeConfirmation;
  final bool canPlanTransactionExecution;
  final bool canPlanAuditTrail;
  final bool canPlanWorkflow;
  final bool canPlanBusinessWorkflow;

  // --- Execution (writes always false by default; reads opt-in) ---
  final bool canExecuteCreateEvent;
  final bool canExecuteCreateQuote;
  final bool canExecuteScheduleRead;
  final bool canExecuteAvailabilityRead;
  final bool canExecuteClientSearch;
  final bool canExecuteLookupQuote;
  final bool canExecuteSearchInventory;
  final bool canExecuteSearchTeam;
  final bool canExecuteStructuredQuoteRead;
  final bool canExecuteQuoteInsights;
  final bool canExecuteSmartActions;
  final bool canExecuteSafeConfirmation;
  final bool canExecuteTransactionExecution;
  final bool canExecuteAuditTrail;
  final bool canExecuteWorkflow;
  final bool canExecuteBusinessWorkflow;

  final bool canUseOCR;
  final bool canUseSpeech;
  final bool canUseVision;
  final bool canUseLLM;

  /// Opt-in multimodal intake pipeline (AI-020) before interpretation.
  final bool canUseMultimodalInput;

  /// Opt-in conversational Context Engine (AI-021) — in-memory only.
  final bool canUseContextEngine;

  /// Opt-in Gateway Intelligence discovery (AI-022) — no LLM/HTTP.
  final bool canUseGatewayIntelligence;

  /// Opt-in Business Reasoning rules engine (AI-023) — no LLM/NLP/HTTP.
  final bool canUseBusinessReasoning;

  /// Opt-in Persistent Memory Engine (AI-024) — in-memory operational memory.
  final bool canUsePersistentMemory;

  /// Default: planning on for core intents, no read/write executors.
  factory AssistantCapabilities.localDefaults() =>
      const AssistantCapabilities();

  /// In-memory demo/test profile: read executors for client/agenda only.
  ///
  /// Writes remain false. [integrationMode] is [AssistantIntegrationMode.inMemory].
  factory AssistantCapabilities.localReadIntegration() =>
      const AssistantCapabilities(
        integrationMode: AssistantIntegrationMode.inMemory,
        canExecuteScheduleRead: true,
        canExecuteAvailabilityRead: true,
        canExecuteClientSearch: true,
      );

  /// Structured ERP quote reads (AI-008) — still no writes.
  factory AssistantCapabilities.localStructuredQuoteRead() =>
      const AssistantCapabilities(
        integrationMode: AssistantIntegrationMode.erp,
        canPlanStructuredQuoteRead: true,
        canExecuteStructuredQuoteRead: true,
      );

  /// Quote insights (AI-011) + structured reads for conversational compat.
  factory AssistantCapabilities.localQuoteInsights() =>
      const AssistantCapabilities(
        integrationMode: AssistantIntegrationMode.erp,
        canPlanStructuredQuoteRead: true,
        canExecuteStructuredQuoteRead: true,
        canPlanQuoteInsights: true,
        canExecuteQuoteInsights: true,
      );

  /// Smart actions (AI-012) + insights/reads for cross-pipeline compat tests.
  factory AssistantCapabilities.localSmartActions() =>
      const AssistantCapabilities(
        integrationMode: AssistantIntegrationMode.erp,
        canPlanStructuredQuoteRead: true,
        canExecuteStructuredQuoteRead: true,
        canPlanQuoteInsights: true,
        canExecuteQuoteInsights: true,
        canPlanSmartActions: true,
        canExecuteSmartActions: true,
      );

  /// Safe confirmation engine (AI-013) + actions for cross-pipeline compat.
  factory AssistantCapabilities.localSafeConfirmation() =>
      const AssistantCapabilities(
        integrationMode: AssistantIntegrationMode.erp,
        canPlanStructuredQuoteRead: true,
        canExecuteStructuredQuoteRead: true,
        canPlanQuoteInsights: true,
        canExecuteQuoteInsights: true,
        canPlanSmartActions: true,
        canExecuteSmartActions: true,
        canPlanSafeConfirmation: true,
        canExecuteSafeConfirmation: true,
      );

  /// Transaction execution (AI-014) after safe confirmation — Create Quote Draft.
  factory AssistantCapabilities.localTransactionExecution() =>
      const AssistantCapabilities(
        integrationMode: AssistantIntegrationMode.erp,
        canPlanStructuredQuoteRead: true,
        canExecuteStructuredQuoteRead: true,
        canPlanQuoteInsights: true,
        canExecuteQuoteInsights: true,
        canPlanSmartActions: true,
        canExecuteSmartActions: true,
        canPlanSafeConfirmation: true,
        canExecuteSafeConfirmation: true,
        canPlanTransactionExecution: true,
        canExecuteTransactionExecution: true,
        canExecuteCreateQuote: true,
      );

  /// Audit trail (AI-015) over confirmation + transaction execution.
  factory AssistantCapabilities.localAuditTrail() =>
      const AssistantCapabilities(
        integrationMode: AssistantIntegrationMode.erp,
        canPlanStructuredQuoteRead: true,
        canExecuteStructuredQuoteRead: true,
        canPlanQuoteInsights: true,
        canExecuteQuoteInsights: true,
        canPlanSmartActions: true,
        canExecuteSmartActions: true,
        canPlanSafeConfirmation: true,
        canExecuteSafeConfirmation: true,
        canPlanTransactionExecution: true,
        canExecuteTransactionExecution: true,
        canExecuteCreateQuote: true,
        canPlanAuditTrail: true,
        canExecuteAuditTrail: true,
      );

  /// Workflow engine (AI-016) composing existing pipelines.
  factory AssistantCapabilities.localWorkflow() =>
      const AssistantCapabilities(
        integrationMode: AssistantIntegrationMode.erp,
        canPlanStructuredQuoteRead: true,
        canExecuteStructuredQuoteRead: true,
        canPlanQuoteInsights: true,
        canExecuteQuoteInsights: true,
        canPlanSmartActions: true,
        canExecuteSmartActions: true,
        canPlanSafeConfirmation: true,
        canExecuteSafeConfirmation: true,
        canPlanTransactionExecution: true,
        canExecuteTransactionExecution: true,
        canExecuteCreateQuote: true,
        canPlanAuditTrail: true,
        canExecuteAuditTrail: true,
        canPlanWorkflow: true,
        canExecuteWorkflow: true,
      );

  /// Business workflow integration (AI-017) over AI-016 stubs.
  factory AssistantCapabilities.localBusinessWorkflow() =>
      const AssistantCapabilities(
        integrationMode: AssistantIntegrationMode.erp,
        canPlanStructuredQuoteRead: true,
        canExecuteStructuredQuoteRead: true,
        canPlanQuoteInsights: true,
        canExecuteQuoteInsights: true,
        canPlanSmartActions: true,
        canExecuteSmartActions: true,
        canPlanSafeConfirmation: true,
        canExecuteSafeConfirmation: true,
        canPlanTransactionExecution: true,
        canExecuteTransactionExecution: true,
        canExecuteCreateQuote: true,
        canPlanAuditTrail: true,
        canExecuteAuditTrail: true,
        canPlanWorkflow: true,
        canExecuteWorkflow: true,
        canPlanBusinessWorkflow: true,
        canExecuteBusinessWorkflow: true,
      );

  /// Multimodal input engine (AI-020) — normalize text before interpretation.
  factory AssistantCapabilities.localMultimodalInput() =>
      const AssistantCapabilities(
        canUseMultimodalInput: true,
      );

  /// Context Engine (AI-021) — conversational memory + execution context.
  factory AssistantCapabilities.localContextEngine() =>
      const AssistantCapabilities(
        canUseContextEngine: true,
      );

  /// Gateway Intelligence (AI-022) — entity discovery via local composition.
  factory AssistantCapabilities.localGatewayIntelligence() =>
      const AssistantCapabilities(
        canUseGatewayIntelligence: true,
        integrationMode: AssistantIntegrationMode.inMemory,
        canExecuteClientSearch: true,
        canExecuteLookupQuote: true,
      );

  /// Business Reasoning (AI-023) — deterministic ERP rule evaluation.
  factory AssistantCapabilities.localBusinessReasoning() =>
      const AssistantCapabilities(
        canUseBusinessReasoning: true,
        canUseGatewayIntelligence: true,
        integrationMode: AssistantIntegrationMode.inMemory,
      );

  /// Persistent Memory Engine (AI-024) — operational memory + context hints.
  factory AssistantCapabilities.localPersistentMemory() =>
      const AssistantCapabilities(
        canUsePersistentMemory: true,
        canUseContextEngine: true,
      );

  bool get anyExecutionEnabled =>
      canExecuteCreateEvent ||
      canExecuteCreateQuote ||
      canExecuteScheduleRead ||
      canExecuteAvailabilityRead ||
      canExecuteClientSearch ||
      canExecuteLookupQuote ||
      canExecuteSearchInventory ||
      canExecuteSearchTeam ||
      canExecuteStructuredQuoteRead ||
      canExecuteQuoteInsights ||
      canExecuteSmartActions ||
      canExecuteSafeConfirmation ||
      canExecuteTransactionExecution ||
      canExecuteAuditTrail ||
      canExecuteWorkflow ||
      canExecuteBusinessWorkflow;

  bool get anyWriteExecutionEnabled =>
      canExecuteCreateEvent || canExecuteCreateQuote;

  bool get claimsErpIntegration =>
      integrationMode == AssistantIntegrationMode.erp;

  AssistantCapabilities copyWith({
    AssistantIntegrationMode? integrationMode,
    bool? canPlanCreateEvent,
    bool? canPlanCreateQuote,
    bool? canPlanCheckSchedule,
    bool? canPlanCheckAvailability,
    bool? canPlanSearchClient,
    bool? canPlanLookupQuote,
    bool? canPlanSearchInventory,
    bool? canPlanSearchTeam,
    bool? canPlanStructuredQuoteRead,
    bool? canPlanQuoteInsights,
    bool? canPlanSmartActions,
    bool? canPlanSafeConfirmation,
    bool? canPlanTransactionExecution,
    bool? canPlanAuditTrail,
    bool? canPlanWorkflow,
    bool? canPlanBusinessWorkflow,
    bool? canExecuteCreateEvent,
    bool? canExecuteCreateQuote,
    bool? canExecuteScheduleRead,
    bool? canExecuteAvailabilityRead,
    bool? canExecuteClientSearch,
    bool? canExecuteLookupQuote,
    bool? canExecuteSearchInventory,
    bool? canExecuteSearchTeam,
    bool? canExecuteStructuredQuoteRead,
    bool? canExecuteQuoteInsights,
    bool? canExecuteSmartActions,
    bool? canExecuteSafeConfirmation,
    bool? canExecuteTransactionExecution,
    bool? canExecuteAuditTrail,
    bool? canExecuteWorkflow,
    bool? canExecuteBusinessWorkflow,
    bool? canUseOCR,
    bool? canUseSpeech,
    bool? canUseVision,
    bool? canUseLLM,
    bool? canUseMultimodalInput,
    bool? canUseContextEngine,
    bool? canUseGatewayIntelligence,
    bool? canUseBusinessReasoning,
    bool? canUsePersistentMemory,
  }) {
    return AssistantCapabilities(
      integrationMode: integrationMode ?? this.integrationMode,
      canPlanCreateEvent: canPlanCreateEvent ?? this.canPlanCreateEvent,
      canPlanCreateQuote: canPlanCreateQuote ?? this.canPlanCreateQuote,
      canPlanCheckSchedule: canPlanCheckSchedule ?? this.canPlanCheckSchedule,
      canPlanCheckAvailability:
          canPlanCheckAvailability ?? this.canPlanCheckAvailability,
      canPlanSearchClient: canPlanSearchClient ?? this.canPlanSearchClient,
      canPlanLookupQuote: canPlanLookupQuote ?? this.canPlanLookupQuote,
      canPlanSearchInventory:
          canPlanSearchInventory ?? this.canPlanSearchInventory,
      canPlanSearchTeam: canPlanSearchTeam ?? this.canPlanSearchTeam,
      canPlanStructuredQuoteRead:
          canPlanStructuredQuoteRead ?? this.canPlanStructuredQuoteRead,
      canPlanQuoteInsights:
          canPlanQuoteInsights ?? this.canPlanQuoteInsights,
      canPlanSmartActions:
          canPlanSmartActions ?? this.canPlanSmartActions,
      canPlanSafeConfirmation:
          canPlanSafeConfirmation ?? this.canPlanSafeConfirmation,
      canPlanTransactionExecution: canPlanTransactionExecution ??
          this.canPlanTransactionExecution,
      canPlanAuditTrail: canPlanAuditTrail ?? this.canPlanAuditTrail,
      canPlanWorkflow: canPlanWorkflow ?? this.canPlanWorkflow,
      canPlanBusinessWorkflow:
          canPlanBusinessWorkflow ?? this.canPlanBusinessWorkflow,
      canExecuteCreateEvent:
          canExecuteCreateEvent ?? this.canExecuteCreateEvent,
      canExecuteCreateQuote:
          canExecuteCreateQuote ?? this.canExecuteCreateQuote,
      canExecuteScheduleRead:
          canExecuteScheduleRead ?? this.canExecuteScheduleRead,
      canExecuteAvailabilityRead:
          canExecuteAvailabilityRead ?? this.canExecuteAvailabilityRead,
      canExecuteClientSearch:
          canExecuteClientSearch ?? this.canExecuteClientSearch,
      canExecuteLookupQuote:
          canExecuteLookupQuote ?? this.canExecuteLookupQuote,
      canExecuteSearchInventory:
          canExecuteSearchInventory ?? this.canExecuteSearchInventory,
      canExecuteSearchTeam: canExecuteSearchTeam ?? this.canExecuteSearchTeam,
      canExecuteStructuredQuoteRead: canExecuteStructuredQuoteRead ??
          this.canExecuteStructuredQuoteRead,
      canExecuteQuoteInsights:
          canExecuteQuoteInsights ?? this.canExecuteQuoteInsights,
      canExecuteSmartActions:
          canExecuteSmartActions ?? this.canExecuteSmartActions,
      canExecuteSafeConfirmation:
          canExecuteSafeConfirmation ?? this.canExecuteSafeConfirmation,
      canExecuteTransactionExecution: canExecuteTransactionExecution ??
          this.canExecuteTransactionExecution,
      canExecuteAuditTrail:
          canExecuteAuditTrail ?? this.canExecuteAuditTrail,
      canExecuteWorkflow: canExecuteWorkflow ?? this.canExecuteWorkflow,
      canExecuteBusinessWorkflow:
          canExecuteBusinessWorkflow ?? this.canExecuteBusinessWorkflow,
      canUseOCR: canUseOCR ?? this.canUseOCR,
      canUseSpeech: canUseSpeech ?? this.canUseSpeech,
      canUseVision: canUseVision ?? this.canUseVision,
      canUseLLM: canUseLLM ?? this.canUseLLM,
      canUseMultimodalInput:
          canUseMultimodalInput ?? this.canUseMultimodalInput,
      canUseContextEngine:
          canUseContextEngine ?? this.canUseContextEngine,
      canUseGatewayIntelligence:
          canUseGatewayIntelligence ?? this.canUseGatewayIntelligence,
      canUseBusinessReasoning:
          canUseBusinessReasoning ?? this.canUseBusinessReasoning,
      canUsePersistentMemory:
          canUsePersistentMemory ?? this.canUsePersistentMemory,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantCapabilities &&
            other.integrationMode == integrationMode &&
            other.canPlanCreateEvent == canPlanCreateEvent &&
            other.canPlanCreateQuote == canPlanCreateQuote &&
            other.canPlanCheckSchedule == canPlanCheckSchedule &&
            other.canPlanCheckAvailability == canPlanCheckAvailability &&
            other.canPlanSearchClient == canPlanSearchClient &&
            other.canPlanLookupQuote == canPlanLookupQuote &&
            other.canPlanSearchInventory == canPlanSearchInventory &&
            other.canPlanSearchTeam == canPlanSearchTeam &&
            other.canPlanStructuredQuoteRead == canPlanStructuredQuoteRead &&
            other.canPlanQuoteInsights == canPlanQuoteInsights &&
            other.canPlanSmartActions == canPlanSmartActions &&
            other.canPlanSafeConfirmation == canPlanSafeConfirmation &&
            other.canPlanTransactionExecution == canPlanTransactionExecution &&
            other.canPlanAuditTrail == canPlanAuditTrail &&
            other.canPlanWorkflow == canPlanWorkflow &&
            other.canPlanBusinessWorkflow == canPlanBusinessWorkflow &&
            other.canExecuteCreateEvent == canExecuteCreateEvent &&
            other.canExecuteCreateQuote == canExecuteCreateQuote &&
            other.canExecuteScheduleRead == canExecuteScheduleRead &&
            other.canExecuteAvailabilityRead == canExecuteAvailabilityRead &&
            other.canExecuteClientSearch == canExecuteClientSearch &&
            other.canExecuteLookupQuote == canExecuteLookupQuote &&
            other.canExecuteSearchInventory == canExecuteSearchInventory &&
            other.canExecuteSearchTeam == canExecuteSearchTeam &&
            other.canExecuteStructuredQuoteRead ==
                canExecuteStructuredQuoteRead &&
            other.canExecuteQuoteInsights == canExecuteQuoteInsights &&
            other.canExecuteSmartActions == canExecuteSmartActions &&
            other.canExecuteSafeConfirmation == canExecuteSafeConfirmation &&
            other.canExecuteTransactionExecution ==
                canExecuteTransactionExecution &&
            other.canExecuteAuditTrail == canExecuteAuditTrail &&
            other.canExecuteWorkflow == canExecuteWorkflow &&
            other.canExecuteBusinessWorkflow == canExecuteBusinessWorkflow &&
            other.canUseOCR == canUseOCR &&
            other.canUseSpeech == canUseSpeech &&
            other.canUseVision == canUseVision &&
            other.canUseLLM == canUseLLM &&
            other.canUseMultimodalInput == canUseMultimodalInput &&
            other.canUseContextEngine == canUseContextEngine &&
            other.canUseGatewayIntelligence == canUseGatewayIntelligence &&
            other.canUseBusinessReasoning == canUseBusinessReasoning &&
            other.canUsePersistentMemory == canUsePersistentMemory;
  }

  @override
  int get hashCode => Object.hashAll([
        integrationMode,
        canPlanCreateEvent,
        canPlanCreateQuote,
        canPlanCheckSchedule,
        canPlanCheckAvailability,
        canPlanSearchClient,
        canPlanLookupQuote,
        canPlanSearchInventory,
        canPlanSearchTeam,
        canPlanStructuredQuoteRead,
        canPlanQuoteInsights,
        canPlanSmartActions,
        canPlanSafeConfirmation,
        canPlanTransactionExecution,
        canPlanAuditTrail,
        canPlanWorkflow,
        canPlanBusinessWorkflow,
        canExecuteCreateEvent,
        canExecuteCreateQuote,
        canExecuteScheduleRead,
        canExecuteAvailabilityRead,
        canExecuteClientSearch,
        canExecuteLookupQuote,
        canExecuteSearchInventory,
        canExecuteSearchTeam,
        canExecuteStructuredQuoteRead,
        canExecuteQuoteInsights,
        canExecuteSmartActions,
        canExecuteSafeConfirmation,
        canExecuteTransactionExecution,
        canExecuteAuditTrail,
        canExecuteWorkflow,
        canExecuteBusinessWorkflow,
        canUseOCR,
        canUseSpeech,
        canUseVision,
        canUseLLM,
        canUseMultimodalInput,
        canUseContextEngine,
        canUseGatewayIntelligence,
        canUseBusinessReasoning,
        canUsePersistentMemory,
      ]);
}
