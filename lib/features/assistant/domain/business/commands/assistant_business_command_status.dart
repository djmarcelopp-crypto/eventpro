/// Lifecycle status of a business command instance (declarative; no execution).
enum AssistantBusinessCommandStatus {
  /// Command declaration only — not yet resolved for planning.
  declared,

  /// Parameters/constraints evaluated by a future resolver.
  resolved,

  /// Ready to be planned / queued.
  ready,

  /// Blocked by missing data or unmet prerequisites.
  blocked,

  /// Completed successfully (reserved for future execution layers).
  completed,

  /// Failed (reserved for future execution layers).
  failed,

  /// Cancelled (reserved for future execution layers).
  cancelled,
}

extension AssistantBusinessCommandStatusX on AssistantBusinessCommandStatus {
  bool get isReady => this == AssistantBusinessCommandStatus.ready;

  Map<String, Object?> toDeterministicMap() => {'status': name};
}
