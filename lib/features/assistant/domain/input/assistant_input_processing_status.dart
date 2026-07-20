/// Outcome of specialized multimodal processing (extension point).
enum AssistantInputProcessingStatus {
  /// Processor produced usable text / content.
  completed,

  /// No processor registered for this input.
  unavailable,

  /// Processor declined / cannot handle.
  unsupported,

  /// Processor failed in a controlled way.
  failed,

  /// Processing skipped (e.g. text already ready).
  skipped,
}

extension AssistantInputProcessingStatusX on AssistantInputProcessingStatus {
  Map<String, Object?> toDeterministicMap() => {'status': name};
}
