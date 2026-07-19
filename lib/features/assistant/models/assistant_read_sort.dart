/// Generic sort directive for structured reads.
class AssistantReadSort {
  const AssistantReadSort({
    required this.field,
    this.ascending = true,
  });

  final String field;
  final bool ascending;

  bool get isValid => field.trim().isNotEmpty;

  Map<String, Object?> toDeterministicMap() => {
        'field': field.trim(),
        'ascending': ascending,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantReadSort &&
            other.field == field &&
            other.ascending == ascending;
  }

  @override
  int get hashCode => Object.hash(field, ascending);
}
