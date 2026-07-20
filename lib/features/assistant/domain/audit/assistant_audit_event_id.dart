/// Opaque audit event identifier.
class AssistantAuditEventId {
  const AssistantAuditEventId(this.value);

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssistantAuditEventId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'AssistantAuditEventId($value)';
}
