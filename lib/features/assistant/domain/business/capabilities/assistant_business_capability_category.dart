/// Formal category for a declared business capability.
enum AssistantBusinessCapabilityCategory {
  /// Resolve / look up an entity reference.
  lookup,

  /// Create a new business artifact (e.g. quote draft stub).
  create,

  /// Open / focus a previously resolved entity.
  open,

  /// Mutate an existing entity (reserved for future adapters).
  mutate,

  /// Catch-all when no specific category applies.
  other,
}

extension AssistantBusinessCapabilityCategoryX
    on AssistantBusinessCapabilityCategory {
  String get wireName => name;

  Map<String, Object?> toDeterministicMap() => {'category': name};
}
