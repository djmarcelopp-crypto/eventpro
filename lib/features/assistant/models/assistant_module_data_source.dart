/// Provenance of a module consultation result.
///
/// In-memory adapters must never claim [erp] or [remote].
enum AssistantModuleDataSource {
  /// Deterministic local fixture / seed (AI-003 adapters).
  inMemory,

  /// Demo seed profile (reserved; not used as ERP).
  demo,

  /// Test-only doubles.
  test,

  /// Future real ERP adapter (not available in AI-003).
  erp,

  /// Future remote/network adapter (not available in AI-003).
  remote,
}
