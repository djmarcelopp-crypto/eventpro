/// Outcome of resolving a capability for planning (never execution).
enum CapabilityResolutionStatus {
  /// Inputs and constraints satisfied — may be planned.
  ready,

  /// Capability id not present in the registry.
  notFound,

  /// One or more required inputs missing.
  missingInput,

  /// One or more declarative constraints unmet.
  unmetConstraint,

  /// Not ready for a composite / unspecified reason.
  blocked,
}

extension CapabilityResolutionStatusX on CapabilityResolutionStatus {
  bool get isReady => this == CapabilityResolutionStatus.ready;

  Map<String, Object?> toDeterministicMap() => {'status': name};
}
