/// Lifecycle status of an [AssistantInput] instance.
enum AssistantInputStatus {
  received,
  validating,
  normalized,
  requiresProcessing,
  rejected,
  failed,
}

extension AssistantInputStatusX on AssistantInputStatus {
  Map<String, Object?> toDeterministicMap() => {'status': name};
}
