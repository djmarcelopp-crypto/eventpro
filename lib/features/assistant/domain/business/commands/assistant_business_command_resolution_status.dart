/// Outcome of resolving a command for planning (never execution).
enum AssistantBusinessCommandResolutionStatus {
  /// Parameters satisfied — may be planned.
  ready,

  /// Command id not known to a future registry.
  notFound,

  /// One or more required parameters missing.
  missingParameter,

  /// Not ready for a composite / unspecified reason.
  blocked,
}

extension AssistantBusinessCommandResolutionStatusX
    on AssistantBusinessCommandResolutionStatus {
  bool get isReady => this == AssistantBusinessCommandResolutionStatus.ready;

  Map<String, Object?> toDeterministicMap() => {'status': name};
}
