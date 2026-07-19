/// Per-step outcome of the controlled execution pipeline (never a real write).
enum AssistantExecutionOutcome {
  /// Step was included in the dry-run/simulation report.
  simulated,

  /// Step skipped because it is blocked (missing data/deps).
  skippedBlocked,

  /// Step skipped because executor/capability/gateway is unavailable.
  skippedUnavailable,

  /// Step cannot proceed without a valid confirmation.
  awaitingConfirmation,

  /// Step rejected by validator or policy.
  rejected,
}
