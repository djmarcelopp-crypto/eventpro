/// Outcome of `AgendaAvailabilityAssistantService.ask` — always
/// [AgendaAvailabilityResponseKind.success] once a phrase was understood;
/// otherwise carries a clear, Portuguese request to rephrase.
enum AgendaAvailabilityResponseKind { success, ambiguous, unsupported }

/// Deterministic, PT-BR textual response produced by
/// `AgendaAvailabilityResponseFormatter` from already-computed structured
/// results (`AgendaAvailabilityResult` / `AgendaQueryResult`). Carries no
/// availability logic of its own.
class AgendaAvailabilityResponse {
  const AgendaAvailabilityResponse({required this.kind, required this.message});

  final AgendaAvailabilityResponseKind kind;

  /// Ready-to-display Portuguese (pt-BR) text.
  final String message;

  bool get isError => kind != AgendaAvailabilityResponseKind.success;
}
