/// Descriptive metadata for a business capability (no ERP coupling).
class AssistantBusinessCapabilityMetadata {
  const AssistantBusinessCapabilityMetadata({
    required this.label,
    this.description,
    this.operationCode,
    this.tags = const [],
  });

  final String label;
  final String? description;

  /// Optional bridge to AI-017 operation codes (e.g. FIND_CLIENT).
  final String? operationCode;
  final List<String> tags;

  Map<String, Object?> toDeterministicMap() => {
        'label': label,
        'description': description,
        'operationCode': operationCode,
        'tags': tags,
      };
}
