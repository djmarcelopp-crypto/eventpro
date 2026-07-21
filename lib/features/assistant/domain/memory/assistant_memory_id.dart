/// Stable identifier for a persistent memory entry (AI-024).
class AssistantMemoryId {
  const AssistantMemoryId(this.value);

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssistantMemoryId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;

  Map<String, Object?> toDeterministicMap() => {'value': value};
}
