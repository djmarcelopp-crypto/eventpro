import 'assistant_input_attachment.dart';

/// Content payload of an input — text and/or attachment reference.
class AssistantInputContent {
  const AssistantInputContent({
    this.text,
    this.attachment,
    this.normalizedText,
  });

  /// Raw or typed textual content when available.
  final String? text;

  /// Safe attachment reference (image/audio/document).
  final AssistantInputAttachment? attachment;

  /// Text already normalized for interpretation (optional pre-fill).
  final String? normalizedText;

  bool get hasText => text != null && text!.trim().isNotEmpty;

  bool get hasAttachment => attachment != null && attachment!.hasReference;

  Map<String, Object?> toDeterministicMap() => {
        'text': text,
        'attachment': attachment?.toDeterministicMap(),
        'normalizedText': normalizedText,
      };
}
