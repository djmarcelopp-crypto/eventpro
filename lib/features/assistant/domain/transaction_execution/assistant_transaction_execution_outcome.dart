/// Outcome of a transaction execution attempt.
enum AssistantTransactionExecutionOutcome {
  completed,
  invalidConfirmation,
  confirmationConsumed,
  confirmationCancelled,
  confirmationExpired,
  planDivergence,
  invalidSession,
  unsupportedOperation,
  writeFailed,
}
