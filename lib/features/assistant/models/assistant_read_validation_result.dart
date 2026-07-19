/// Structural validation of a read query (no ERP access).
class AssistantReadValidationResult {
  const AssistantReadValidationResult({
    required this.valid,
    this.errors = const [],
    this.warnings = const [],
  });

  final bool valid;
  final List<String> errors;
  final List<String> warnings;

  factory AssistantReadValidationResult.fromParts({
    List<String> errors = const [],
    List<String> warnings = const [],
  }) {
    return AssistantReadValidationResult(
      valid: errors.isEmpty,
      errors: List.unmodifiable(errors),
      warnings: List.unmodifiable(warnings),
    );
  }
}
