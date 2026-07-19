/// Warning about module integration (missing gateway, capability, adapter error).
class AssistantIntegrationWarning {
  const AssistantIntegrationWarning({
    required this.id,
    required this.message,
    this.module,
  });

  final String id;
  final String message;
  final String? module;

  AssistantIntegrationWarning copyWith({
    String? id,
    String? message,
    String? module,
    bool clearModule = false,
  }) {
    return AssistantIntegrationWarning(
      id: id ?? this.id,
      message: message ?? this.message,
      module: clearModule ? null : (module ?? this.module),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantIntegrationWarning &&
            other.id == id &&
            other.message == message &&
            other.module == module;
  }

  @override
  int get hashCode => Object.hash(id, message, module);
}
