import '../domain/input/assistant_input.dart';
import '../domain/input/assistant_input_content.dart';
import '../domain/input/assistant_input_normalization_result.dart';
import '../domain/input/assistant_input_normalization_status.dart';
import '../domain/input/assistant_input_normalizer.dart';
import '../domain/input/assistant_input_pipeline.dart';
import '../domain/input/assistant_input_processing_request.dart';
import '../domain/input/assistant_input_processing_result.dart';
import '../domain/input/assistant_input_processing_status.dart';
import '../domain/input/assistant_input_processor_registry.dart';
import '../domain/input/assistant_input_type.dart';
import 'local_assistant_input_normalizer.dart';
import 'local_assistant_input_processor_registry.dart';

/// Local multimodal pipeline — never invents OCR/STT content.
class LocalAssistantInputPipeline implements AssistantInputPipeline {
  LocalAssistantInputPipeline({
    AssistantInputNormalizer? normalizer,
    AssistantInputProcessorRegistry? processorRegistry,
  })  : _normalizer = normalizer ?? const LocalAssistantInputNormalizer(),
        _processors = processorRegistry ??
            LocalAssistantInputProcessorRegistry.defaults();

  final AssistantInputNormalizer _normalizer;
  final AssistantInputProcessorRegistry _processors;

  @override
  Future<AssistantInputPipelineResult> run(AssistantInput input) async {
    AssistantInputProcessingResult? processing;
    var working = input;

    if (input.type == AssistantInputType.text) {
      final processor = _processors.findByType(AssistantInputType.text);
      if (processor != null) {
        processing = await processor.process(
          AssistantInputProcessingRequest(input: input, processorId: processor.id),
        );
        if (processing.status == AssistantInputProcessingStatus.failed) {
          return AssistantInputPipelineResult(
            input: input,
            processing: processing,
            normalization: AssistantInputNormalizationResult(
              inputId: input.id.value,
              correlationId: input.effectiveCorrelationId,
              status: AssistantInputNormalizationStatus.failed,
              input: input,
              messages: [
                AssistantInputMessage(
                  code: AssistantInputMessage.processorFailed,
                  message: processing.message ?? 'Processor failed.',
                ),
              ],
            ),
          );
        }
        if (processing.status == AssistantInputProcessingStatus.completed &&
            processing.content != null) {
          working = AssistantInput(
            id: input.id,
            type: input.type,
            content: processing.content!,
            metadata: input.metadata,
            receivedAt: input.receivedAt,
            status: input.status,
            correlationId: input.correlationId,
          );
        }
        // skipped / unsupported → continue to Normalizer for validation.
      }
    } else {
      // Media: try processor by type / mime; absence → requiresProcessing later.
      final mime = input.content.attachment?.mimeType;
      final processor = _processors.findByType(input.type) ??
          (mime != null ? _processors.findByMimeType(mime) : null);
      if (processor != null) {
        processing = await processor.process(
          AssistantInputProcessingRequest(
            input: input,
            processorId: processor.id,
          ),
        );
        if (processing.status == AssistantInputProcessingStatus.completed &&
            processing.content != null &&
            (processing.content!.normalizedText ?? processing.content!.text)
                    ?.trim()
                    .isNotEmpty ==
                true) {
          // Specialized processor produced text — normalize as text content.
          working = AssistantInput(
            id: input.id,
            type: AssistantInputType.text,
            content: AssistantInputContent(
              text: processing.content!.normalizedText ??
                  processing.content!.text,
              normalizedText: processing.content!.normalizedText ??
                  processing.content!.text,
              attachment: input.content.attachment,
            ),
            metadata: input.metadata,
            receivedAt: input.receivedAt,
            correlationId: input.correlationId,
          );
        } else if (processing.status ==
            AssistantInputProcessingStatus.failed) {
          return AssistantInputPipelineResult(
            input: input,
            processing: processing,
            normalization: AssistantInputNormalizationResult(
              inputId: input.id.value,
              correlationId: input.effectiveCorrelationId,
              status: AssistantInputNormalizationStatus.failed,
              input: input,
              messages: [
                AssistantInputMessage(
                  code: AssistantInputMessage.processorFailed,
                  message: processing.message ?? 'Processor failed.',
                ),
              ],
            ),
          );
        }
      } else {
        processing = AssistantInputProcessingResult(
          inputId: input.id.value,
          correlationId: input.effectiveCorrelationId,
          status: AssistantInputProcessingStatus.unavailable,
          message: 'Nenhum processor registrado para ${input.type.name}.',
        );
      }
    }

    final normalization = _normalizer.normalize(working);
    return AssistantInputPipelineResult(
      input: input,
      processing: processing,
      normalization: normalization,
    );
  }
}
