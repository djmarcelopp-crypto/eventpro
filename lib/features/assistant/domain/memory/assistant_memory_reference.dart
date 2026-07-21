/// Opaque reference to a remembered entity / decision / workflow.
class AssistantMemoryReference {
  const AssistantMemoryReference({
    required this.key,
    this.value,
    this.kind,
  });

  final String key;
  final String? value;
  final String? kind;

  Map<String, Object?> toDeterministicMap() => {
        'key': key,
        'value': value,
        'kind': kind,
      };
}
