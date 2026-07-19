/// Controlled execution mode for the AI-004 pipeline.
///
/// AI-004 only allows [dryRun] and [simulation]. [production] is reserved.
enum AssistantExecutionMode {
  /// Validate + confirm + report — no side effects.
  dryRun,

  /// Same as dryRun with explicit simulation wording in reports.
  simulation,

  /// Reserved for future real execution (never enabled in AI-004).
  production,
}
