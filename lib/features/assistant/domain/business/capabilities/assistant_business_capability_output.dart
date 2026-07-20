/// Declared output slot produced by a capability.
class AssistantBusinessCapabilityOutput {
  const AssistantBusinessCapabilityOutput({
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
