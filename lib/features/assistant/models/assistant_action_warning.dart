/// Non-fatal smart-action warning.
class AssistantActionWarning {
  const AssistantActionWarning({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;

  static const unknownAction = 'unknownAction';
  static const missingTarget = 'missingTarget';
  static const idempotentReplay = 'idempotentReplay';

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantActionWarning &&
            other.code == code &&
            other.message == message;
  }

  @override
  int get hashCode => Object.hash(code, message);
}
