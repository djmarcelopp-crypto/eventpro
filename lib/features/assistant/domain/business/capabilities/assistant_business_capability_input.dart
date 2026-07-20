/// Declared input slot for a capability.
class AssistantBusinessCapabilityInput {
  const AssistantBusinessCapabilityInput({
    required this.key,
    this.required = false,
    this.description,
  });

  final String key;
  final bool required;
  final String? description;

  Map<String, Object?> toDeterministicMap() => {
        'key': key,
        'required': required,
        'description': description,
      };
}
