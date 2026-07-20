import '../domain/input/assistant_input_content.dart';
import '../domain/input/assistant_input_processing_request.dart';
import '../domain/input/assistant_input_processing_result.dart';
import '../domain/input/assistant_input_processing_status.dart';
import '../domain/input/assistant_input_processor.dart';
import '../domain/input/assistant_input_processor_id.dart';
import '../domain/input/assistant_input_type.dart';

/// Local text processor — only passes through existing text; never invents.
class LocalAssistantTextInputProcessor implements AssistantInputProcessor {
  const LocalAssistantTextInputProcessor();

  @override
  AssistantInputProcessorId get id => AssistantInputProcessorIds.localText;

  @override
  Set<AssistantInputType> get supportedTypes => const {AssistantInputType.text};

  @override
  Set<String> get supportedMimeTypes => const {'text/plain'};

  @override
  Future<AssistantInputProcessingResult> process(
    AssistantInputProcessingRequest request,
  ) async {
    final input = request.input;
    if (input.type != AssistantInputType.text) {
      return AssistantInputProcessingResult(
        inputId: input.id.value,
        correlationId: input.effectiveCorrelationId,
        status: AssistantInputProcessingStatus.unsupported,
        processorId: id,
        message: 'LocalText processor only handles text.',
      );
    }

    final text = input.content.text ?? input.content.normalizedText;
    if (text == null || text.trim().isEmpty) {
      // Leave validation to the Normalizer (invalid), do not mark as failed.
      return AssistantInputProcessingResult(
        inputId: input.id.value,
        correlationId: input.effectiveCorrelationId,
        status: AssistantInputProcessingStatus.skipped,
        processorId: id,
        message: 'Text processor: empty content; deferred to normalizer.',
      );
    }

    return AssistantInputProcessingResult(
      inputId: input.id.value,
      correlationId: input.effectiveCorrelationId,
      status: AssistantInputProcessingStatus.completed,
      processorId: id,
      content: AssistantInputContent(text: text, normalizedText: text.trim()),
    );
  }
}
