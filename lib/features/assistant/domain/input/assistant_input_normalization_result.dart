import 'assistant_input.dart';
import 'assistant_input_content.dart';
import 'assistant_input_normalization_status.dart';

/// Soft issue / message from normalization (never an ERP error).
class AssistantInputMessage {
  const AssistantInputMessage({
    required this.code,
    required this.message,
  });

  static const missingText = 'missing_text';
  static const missingAttachment = 'missing_attachment';
  static const invalidMime = 'invalid_mime';
  static const invalidReference = 'invalid_reference';
  static const requiresSpecializedProcessing =
      'requires_specialized_processing';
  static const unsupportedType = 'unsupported_type';
  static const processorMissing = 'processor_missing';
  static const processorFailed = 'processor_failed';

  final String code;
  final String message;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
      };
}

/// Result of normalizing an [AssistantInput] — never invents media content.
class AssistantInputNormalizationResult {
  const AssistantInputNormalizationResult({
    required this.inputId,
    required this.correlationId,
    required this.status,
    this.input,
    this.normalizedContent,
    this.messages = const [],
  });

  final String inputId;
  final String correlationId;
  final AssistantInputNormalizationStatus status;
  final AssistantInput? input;
  final AssistantInputContent? normalizedContent;
  final List<AssistantInputMessage> messages;

  bool get ready => status.isReady;

  String? get normalizedText =>
      normalizedContent?.normalizedText ?? normalizedContent?.text;

  Map<String, Object?> toDeterministicMap() => {
        'inputId': inputId,
        'correlationId': correlationId,
        'status': status.name,
        'ready': ready,
        'normalizedContent': normalizedContent?.toDeterministicMap(),
        'messages': messages.map((m) => m.toDeterministicMap()).toList(),
      };
}
