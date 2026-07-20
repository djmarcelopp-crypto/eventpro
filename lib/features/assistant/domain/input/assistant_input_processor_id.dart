/// Stable processor identifier.
class AssistantInputProcessorId {
  const AssistantInputProcessorId(this.value);

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssistantInputProcessorId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;

  Map<String, Object?> toDeterministicMap() => {'value': value};
}

/// Built-in processor ids (AI-020).
abstract final class AssistantInputProcessorIds {
  static const localText = AssistantInputProcessorId('localText');
}
