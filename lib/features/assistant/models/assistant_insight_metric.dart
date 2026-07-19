/// Named numeric metric produced by an insight computation.
class AssistantInsightMetric {
  const AssistantInsightMetric({
    required this.name,
    required this.value,
    this.unit,
    this.label,
  });

  final String name;
  final num value;
  final String? unit;
  final String? label;

  Map<String, Object?> toDeterministicMap() => {
        'name': name,
        'value': value,
        'unit': unit,
        'label': label,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantInsightMetric &&
            other.name == name &&
            other.value == value &&
            other.unit == unit &&
            other.label == label;
  }

  @override
  int get hashCode => Object.hash(name, value, unit, label);
}
