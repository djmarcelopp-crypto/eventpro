/// Declared result slot produced by a business command.
class AssistantBusinessCommandResult {
  const AssistantBusinessCommandResult({
    required this.key,
    this.description,
  });

  final String key;
  final String? description;

  Map<String, Object?> toDeterministicMap() => {
        'key': key,
        'description': description,
      };
}
