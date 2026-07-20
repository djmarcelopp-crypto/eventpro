/// Descriptive metadata for a business command (no ERP coupling).
///
/// Single resolution key: [operationCode] (AI-017 / Capability bridge).
class AssistantBusinessCommandMetadata {
  const AssistantBusinessCommandMetadata({
    required this.label,
    this.description,
    this.operationCode,
    this.tags = const [],
  });

  final String label;
  final String? description;

  /// Stable operation code (e.g. FIND_CLIENT) — sole link for Capability resolve.
  final String? operationCode;
  final List<String> tags;

  Map<String, Object?> toDeterministicMap() => {
        'label': label,
        'description': description,
        'operationCode': operationCode,
        'tags': tags,
      };
}
