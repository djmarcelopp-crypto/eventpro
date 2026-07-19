/// Categorical breakdown bucket (e.g. status → count).
class AssistantInsightDimension {
  const AssistantInsightDimension({
    required this.key,
    required this.value,
    this.label,
    this.count = 0,
  });

  final String key;
  final String value;
  final String? label;
  final int count;

  Map<String, Object?> toDeterministicMap() => {
        'key': key,
        'value': value,
        'label': label,
        'count': count,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantInsightDimension &&
            other.key == key &&
            other.value == value &&
            other.label == label &&
            other.count == count;
  }

  @override
  int get hashCode => Object.hash(key, value, label, count);
}
