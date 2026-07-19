/// Generic equality/comparison filter for structured reads.
///
/// Module-agnostic: adapters interpret [field] / [operator] / [value].
class AssistantReadFilter {
  const AssistantReadFilter({
    required this.field,
    required this.operator,
    required this.value,
  });

  /// Logical field name (e.g. `id`, `number`, `status`).
  final String field;

  /// Comparison operator (`eq`, `contains`, `neq`, …).
  final String operator;

  /// Opaque string value — never a module DTO.
  final String value;

  bool get isValid =>
      field.trim().isNotEmpty &&
      operator.trim().isNotEmpty &&
      value.trim().isNotEmpty;

  Map<String, Object?> toDeterministicMap() => {
        'field': field.trim(),
        'operator': operator.trim(),
        'value': value.trim(),
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantReadFilter &&
            other.field == field &&
            other.operator == operator &&
            other.value == value;
  }

  @override
  int get hashCode => Object.hash(field, operator, value);
}
