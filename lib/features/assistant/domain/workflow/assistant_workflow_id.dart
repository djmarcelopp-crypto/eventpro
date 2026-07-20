/// Opaque workflow identifier.
class AssistantWorkflowId {
  const AssistantWorkflowId(this.value);

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssistantWorkflowId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'AssistantWorkflowId($value)';
}
