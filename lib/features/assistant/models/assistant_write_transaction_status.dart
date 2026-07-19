/// Lifecycle of an [AssistantWriteTransaction].
enum AssistantWriteTransactionStatus {
  pending,
  prepared,
  executing,
  committed,
  rolledBack,
  failed,
  uncertain,
  skipped,
}
