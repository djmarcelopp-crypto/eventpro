import 'assistant_input_content.dart';
import 'assistant_input_processing_status.dart';
import 'assistant_input_processor_id.dart';

/// Result of optional specialized processing — never invents media content.
class AssistantInputProcessingResult {
  const AssistantInputProcessingResult({
    required this.inputId,
    required this.correlationId,
    required this.status,
    this.processorId,
    this.content,
    this.message,
  });

  final String inputId;
  final String correlationId;
  final AssistantInputProcessingStatus status;
  final AssistantInputProcessorId? processorId;
  final AssistantInputContent? content;
  final String? message;

  Map<String, Object?> toDeterministicMap() => {
        'inputId': inputId,
        'correlationId': correlationId,
        'status': status.name,
        'processorId': processorId?.value,
        'content': content?.toDeterministicMap(),
        'message': message,
      };
}
