/// Non-fatal insight warning (e.g. scan truncation).
class AssistantInsightWarning {
  const AssistantInsightWarning({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;

  static const maxScanCode = 'maxScan';

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantInsightWarning &&
            other.code == code &&
            other.message == message;
  }

  @override
  int get hashCode => Object.hash(code, message);
}
