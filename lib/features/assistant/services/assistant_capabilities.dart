/// Locally configurable capability flags for the assistant planner.
///
/// Separates **planning** (may describe a step) from **execution**
/// (would actually call an ERP module). AI-002 never enables execution.
///
/// Never probes real ERP modules or network SDKs.
class AssistantCapabilities {
  const AssistantCapabilities({
    this.canPlanCreateEvent = true,
    this.canPlanCreateQuote = true,
    this.canPlanCheckSchedule = true,
    this.canPlanCheckAvailability = true,
    this.canPlanSearchClient = true,
    this.canExecuteCreateEvent = false,
    this.canExecuteCreateQuote = false,
    this.canExecuteScheduleRead = false,
    this.canExecuteAvailabilityRead = false,
    this.canExecuteClientSearch = false,
    this.canUseOCR = false,
    this.canUseSpeech = false,
    this.canUseVision = false,
    this.canUseLLM = false,
  });

  // --- Planning (may appear in Execution Plan) ---
  final bool canPlanCreateEvent;
  final bool canPlanCreateQuote;
  final bool canPlanCheckSchedule;
  final bool canPlanCheckAvailability;
  final bool canPlanSearchClient;

  // --- Execution (real ERP integration — always false in AI-002 defaults) ---
  final bool canExecuteCreateEvent;
  final bool canExecuteCreateQuote;
  final bool canExecuteScheduleRead;
  final bool canExecuteAvailabilityRead;
  final bool canExecuteClientSearch;

  // --- Future multimodal / LLM (disabled) ---
  final bool canUseOCR;
  final bool canUseSpeech;
  final bool canUseVision;
  final bool canUseLLM;

  /// Default local profile: planning on, execution off, multimodal/LLM off.
  factory AssistantCapabilities.localDefaults() =>
      const AssistantCapabilities();

  bool get anyExecutionEnabled =>
      canExecuteCreateEvent ||
      canExecuteCreateQuote ||
      canExecuteScheduleRead ||
      canExecuteAvailabilityRead ||
      canExecuteClientSearch;

  AssistantCapabilities copyWith({
    bool? canPlanCreateEvent,
    bool? canPlanCreateQuote,
    bool? canPlanCheckSchedule,
    bool? canPlanCheckAvailability,
    bool? canPlanSearchClient,
    bool? canExecuteCreateEvent,
    bool? canExecuteCreateQuote,
    bool? canExecuteScheduleRead,
    bool? canExecuteAvailabilityRead,
    bool? canExecuteClientSearch,
    bool? canUseOCR,
    bool? canUseSpeech,
    bool? canUseVision,
    bool? canUseLLM,
  }) {
    return AssistantCapabilities(
      canPlanCreateEvent: canPlanCreateEvent ?? this.canPlanCreateEvent,
      canPlanCreateQuote: canPlanCreateQuote ?? this.canPlanCreateQuote,
      canPlanCheckSchedule: canPlanCheckSchedule ?? this.canPlanCheckSchedule,
      canPlanCheckAvailability:
          canPlanCheckAvailability ?? this.canPlanCheckAvailability,
      canPlanSearchClient: canPlanSearchClient ?? this.canPlanSearchClient,
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
            other.canPlanCreateEvent == canPlanCreateEvent &&
            other.canPlanCreateQuote == canPlanCreateQuote &&
            other.canPlanCheckSchedule == canPlanCheckSchedule &&
            other.canPlanCheckAvailability == canPlanCheckAvailability &&
            other.canPlanSearchClient == canPlanSearchClient &&
            other.canExecuteCreateEvent == canExecuteCreateEvent &&
            other.canExecuteCreateQuote == canExecuteCreateQuote &&
            other.canExecuteScheduleRead == canExecuteScheduleRead &&
            other.canExecuteAvailabilityRead == canExecuteAvailabilityRead &&
            other.canExecuteClientSearch == canExecuteClientSearch &&
            other.canUseOCR == canUseOCR &&
            other.canUseSpeech == canUseSpeech &&
            other.canUseVision == canUseVision &&
            other.canUseLLM == canUseLLM;
  }

  @override
  int get hashCode => Object.hash(
        canPlanCreateEvent,
        canPlanCreateQuote,
        canPlanCheckSchedule,
        canPlanCheckAvailability,
        canPlanSearchClient,
        canExecuteCreateEvent,
        canExecuteCreateQuote,
        canExecuteScheduleRead,
        canExecuteAvailabilityRead,
        canExecuteClientSearch,
        canUseOCR,
        canUseSpeech,
        canUseVision,
        canUseLLM,
      );
}
