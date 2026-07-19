/// When a planned step would need user confirmation before any future execution.
enum AssistantConfirmationPolicy {
  /// Read-only / informational step — no confirmation required.
  none,

  /// Write/side-effect step — confirmation mandatory before any future run.
  requiredBeforeWrite,

  /// Always ask, even for reads (reserved for sensitive queries).
  alwaysRequired,
}
