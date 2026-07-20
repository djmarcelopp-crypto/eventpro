/// Constraint kinds validated by the capability resolver (no execution).
enum AssistantBusinessCapabilityConstraintKind {
  /// Context must already contain [key].
  requiresContextKey,

  /// A prior capability in the plan must have produced [key].
  requiresSatisfiedDependency,

  /// Named prior capability id must have been resolved successfully.
  requiresPriorCapability,
}

/// Declarative constraint on when a capability may be planned.
class AssistantBusinessCapabilityConstraint {
  const AssistantBusinessCapabilityConstraint({
    required this.kind,
    required this.key,
    this.message,
  });

  final AssistantBusinessCapabilityConstraintKind kind;

  /// Context key, dependency key, or prior capability id (by kind).
  final String key;
  final String? message;

  Map<String, Object?> toDeterministicMap() => {
        'kind': kind.name,
        'key': key,
        'message': message,
      };
}
