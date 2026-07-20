/// Lifecycle status of a business operation invocation.
enum AssistantBusinessStatus {
  /// Operation completed successfully (stub or real).
  succeeded,

  /// Operation was rejected (unknown op, missing input, etc.).
  rejected,

  /// Operation is not available in the current configuration.
  unavailable,

  /// Operation ran but produced a soft failure.
  failed,
}
