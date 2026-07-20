/// Formal category for a declared business command.
enum AssistantBusinessCommandCategory {
  /// Resolve / look up an entity reference.
  lookup,

  /// Create a new business artifact.
  create,

  /// Open / focus a previously resolved entity.
  open,

  /// Mutate an existing entity (reserved for future adapters).
  mutate,

  /// Catch-all when no specific category applies.
  other,
}

extension AssistantBusinessCommandCategoryX on AssistantBusinessCommandCategory {
  String get wireName => name;

  Map<String, Object?> toDeterministicMap() => {'category': name};
}
