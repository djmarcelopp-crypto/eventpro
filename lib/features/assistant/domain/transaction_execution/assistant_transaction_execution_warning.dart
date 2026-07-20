/// Structured warning for transaction execution turns.
class AssistantTransactionExecutionWarning {
  const AssistantTransactionExecutionWarning({
    required this.code,
    required this.message,
  });

  static const invalidToken = 'invalidToken';
  static const tokenReused = 'tokenReused';
  static const cancelled = 'cancelled';
  static const expired = 'expired';
  static const sessionMismatch = 'sessionMismatch';
  static const planDivergence = 'planDivergence';
  static const missingSession = 'missingSession';
  static const notConfirmed = 'notConfirmed';
  static const unsupportedOperation = 'unsupportedOperation';
  static const writeFailed = 'writeFailed';

  final String code;
  final String message;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
      };
}
