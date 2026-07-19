/// Environment / trust level of assistant module integration.
///
/// Orthogonal to `canExecute*` flags: those only mean a read executor may be
/// invoked for the current configuration — not that data is productive ERP.
enum AssistantIntegrationMode {
  /// No read executors enabled (`localDefaults`).
  none,

  /// In-memory / fixture adapters only (AI-003 demo & tests).
  inMemory,

  /// Reserved for a future approved ERP adapter.
  erp,
}
