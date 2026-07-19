/// Coarse outcome category for write observability (non-authoritative).
enum AssistantWriteOutcomeCategory {
  success,
  blocked,
  dryRun,
  simulation,
  timeout,
  rollback,
  failed,
  uncertain,
  idempotentReplay,
}
