/// How idempotency was resolved for a write attempt.
enum AssistantWriteIdempotencyStatus {
  notApplicable,
  missing,
  firstExecution,
  replayed,
  conflict,
}
