/// Declared parameter slot for a business command.
class AssistantBusinessCommandParameter {
  const AssistantBusinessCommandParameter({
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
