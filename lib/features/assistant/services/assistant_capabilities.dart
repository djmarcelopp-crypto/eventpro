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
    this.canExecuteCreateEvent = false,
    this.canExecuteCreateQuote = false,
    this.canExecuteScheduleRead = false,
    this.canExecuteAvailabilityRead = false,
    this.canExecuteClientSearch = false,
    this.canExecuteLookupQuote = false,
    this.canExecuteSearchInventory = false,
    this.canExecuteSearchTeam = false,
    this.canUseOCR = false,
    this.canUseSpeech = false,
    this.canUseVision = false,
    this.canUseLLM = false,
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

  // --- Execution (writes always false by default; reads opt-in) ---
  final bool canExecuteCreateEvent;
  final bool canExecuteCreateQuote;
  final bool canExecuteScheduleRead;
  final bool canExecuteAvailabilityRead;
  final bool canExecuteClientSearch;
  final bool canExecuteLookupQuote;
  final bool canExecuteSearchInventory;
  final bool canExecuteSearchTeam;

  final bool canUseOCR;
  final bool canUseSpeech;
  final bool canUseVision;
  final bool canUseLLM;

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

  bool get anyExecutionEnabled =>
      canExecuteCreateEvent ||
      canExecuteCreateQuote ||
      canExecuteScheduleRead ||
      canExecuteAvailabilityRead ||
      canExecuteClientSearch ||
      canExecuteLookupQuote ||
      canExecuteSearchInventory ||
      canExecuteSearchTeam;

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
    bool? canExecuteCreateEvent,
    bool? canExecuteCreateQuote,
    bool? canExecuteScheduleRead,
    bool? canExecuteAvailabilityRead,
    bool? canExecuteClientSearch,
    bool? canExecuteLookupQuote,
    bool? canExecuteSearchInventory,
    bool? canExecuteSearchTeam,
    bool? canUseOCR,
    bool? canUseSpeech,
    bool? canUseVision,
    bool? canUseLLM,
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
      canUseOCR: canUseOCR ?? this.canUseOCR,
      canUseSpeech: canUseSpeech ?? this.canUseSpeech,
      canUseVision: canUseVision ?? this.canUseVision,
      canUseLLM: canUseLLM ?? this.canUseLLM,
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
            other.canExecuteCreateEvent == canExecuteCreateEvent &&
            other.canExecuteCreateQuote == canExecuteCreateQuote &&
            other.canExecuteScheduleRead == canExecuteScheduleRead &&
            other.canExecuteAvailabilityRead == canExecuteAvailabilityRead &&
            other.canExecuteClientSearch == canExecuteClientSearch &&
            other.canExecuteLookupQuote == canExecuteLookupQuote &&
            other.canExecuteSearchInventory == canExecuteSearchInventory &&
            other.canExecuteSearchTeam == canExecuteSearchTeam &&
            other.canUseOCR == canUseOCR &&
            other.canUseSpeech == canUseSpeech &&
            other.canUseVision == canUseVision &&
            other.canUseLLM == canUseLLM;
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
        canExecuteCreateEvent,
        canExecuteCreateQuote,
        canExecuteScheduleRead,
        canExecuteAvailabilityRead,
        canExecuteClientSearch,
        canExecuteLookupQuote,
        canExecuteSearchInventory,
        canExecuteSearchTeam,
        canUseOCR,
        canUseSpeech,
        canUseVision,
        canUseLLM,
      ]);
}
