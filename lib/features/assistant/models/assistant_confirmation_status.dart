/// Result of evaluating confirmation for a planned step.
enum AssistantConfirmationStatus {
  /// Policy does not require confirmation.
  notRequired,

  /// Confirmation is required but was not provided.
  requiredMissing,

  /// Confirmation was provided and accepted for dry-run/simulation only.
  providedValid,

  /// Confirmation was provided but is invalid for this step/context.
  providedInvalid,
}
