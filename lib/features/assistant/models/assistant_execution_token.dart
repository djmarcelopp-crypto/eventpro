/// Opaque in-memory token identifying one controlled execution attempt.
class AssistantExecutionToken {
  const AssistantExecutionToken(this.value);

  final String value;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionToken && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'AssistantExecutionToken($value)';
}
