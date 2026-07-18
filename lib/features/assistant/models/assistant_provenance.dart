/// How a value was obtained during interpretation.
enum AssistantProvenance {
  /// Explicitly present in the source text.
  extracted,

  /// Derived by a deterministic local rule (e.g. missing year).
  inferred,

  /// Soft suggestion for the user to confirm.
  suggested,

  /// Required for the proposed action but not found.
  missing,

  /// Multiple incompatible values found for the same field.
  conflicted,
}
