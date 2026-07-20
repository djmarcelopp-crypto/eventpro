/// Domain audit event kinds for confirmation + transaction execution (AI-015).
enum AssistantAuditEventType {
  confirmationCreated,
  confirmationStatusChecked,
  confirmationConfirmed,
  confirmationCancelled,
  confirmationExpired,
  executionRequested,
  executionRejected,
  executionCompleted,
  executionWriteFailed,
}
