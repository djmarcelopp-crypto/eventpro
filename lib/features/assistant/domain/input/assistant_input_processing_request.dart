import 'assistant_input.dart';
import 'assistant_input_processor_id.dart';

/// Request to a specialized multimodal processor.
class AssistantInputProcessingRequest {
  const AssistantInputProcessingRequest({
    required this.input,
    this.processorId,
  });

  final AssistantInput input;
  final AssistantInputProcessorId? processorId;

  Map<String, Object?> toDeterministicMap() => {
        'inputId': input.id.value,
        'type': input.type.name,
        'processorId': processorId?.value,
        'correlationId': input.effectiveCorrelationId,
      };
}
