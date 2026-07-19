/// Lifecycle state of a planned step. Never implies ERP execution.
enum AssistantExecutionStatus {
  /// Missing information, unmet dependency, or unmet preconditions.
  blocked,

  /// Known step, but no real executor/capability is enabled.
  unavailable,

  /// Preconditions and executor exist; explicit user confirmation still required.
  awaitingConfirmation,

  /// All preconditions, confirmation and execution capabilities satisfied.
  /// AI-002 defaults never produce this for real ERP operations.
  ready,
}
