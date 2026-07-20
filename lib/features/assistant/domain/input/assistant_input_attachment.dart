/// Safe reference to an attachment — never stores heavy bytes in domain.
class AssistantInputAttachment {
  const AssistantInputAttachment({
    required this.reference,
    this.fileName,
    this.mimeType,
    this.sizeBytes,
    this.durationMs,
  });

  /// Opaque URI / storage key / path reference (not bytes).
  final String reference;
  final String? fileName;
  final String? mimeType;
  final int? sizeBytes;

  /// Duration in milliseconds (audio/video); null when N/A.
  final int? durationMs;

  bool get hasReference => reference.trim().isNotEmpty;

  Map<String, Object?> toDeterministicMap() => {
        'reference': reference,
        'fileName': fileName,
        'mimeType': mimeType,
        'sizeBytes': sizeBytes,
        'durationMs': durationMs,
      };
}
