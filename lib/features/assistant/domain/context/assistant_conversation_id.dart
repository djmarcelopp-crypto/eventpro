/// Stable identifier for an assistant conversation (Context Engine AI-021).
class AssistantConversationId {
  const AssistantConversationId(this.value);

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssistantConversationId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;

  Map<String, Object?> toDeterministicMap() => {'value': value};
}
