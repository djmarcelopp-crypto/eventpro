/// Encapsulated module integration failure — never thrown to the UI.
class AssistantModuleError {
  const AssistantModuleError({
    required this.code,
    required this.message,
    this.details,
  });

  final String code;
  final String message;
  final String? details;

  AssistantModuleError copyWith({
    String? code,
    String? message,
    String? details,
    bool clearDetails = false,
  }) {
    return AssistantModuleError(
      code: code ?? this.code,
      message: message ?? this.message,
      details: clearDetails ? null : (details ?? this.details),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantModuleError &&
            other.code == code &&
            other.message == message &&
            other.details == details;
  }

  @override
  int get hashCode => Object.hash(code, message, details);
}
