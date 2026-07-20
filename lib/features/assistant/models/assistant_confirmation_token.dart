/// Opaque token identifying one pending safe confirmation.
class AssistantConfirmationToken {
  const AssistantConfirmationToken(this.value);

  final String value;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantConfirmationToken && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'AssistantConfirmationToken($value)';
}
