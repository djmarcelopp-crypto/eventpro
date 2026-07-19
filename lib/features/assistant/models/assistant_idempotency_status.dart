/// Lifecycle status of an idempotent write operation claim.
enum AssistantIdempotencyStatus {
  pending,
  completed,
  failed,
  uncertain,
}
