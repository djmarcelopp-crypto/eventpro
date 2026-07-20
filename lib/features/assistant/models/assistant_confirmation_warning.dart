/// Non-fatal warning from the safe confirmation engine.
class AssistantConfirmationWarning {
  const AssistantConfirmationWarning({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;

  static const missingPending = 'missingPending';
  static const expired = 'expired';
  static const alreadyResolved = 'alreadyResolved';
  static const missingSession = 'missingSession';
  static const tokenMismatch = 'tokenMismatch';

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantConfirmationWarning &&
            other.code == code &&
            other.message == message;
  }

  @override
  int get hashCode => Object.hash(code, message);
}
