import 'assistant_input_processing_request.dart';
import 'assistant_input_processing_result.dart';
import 'assistant_input_processor_id.dart';
import 'assistant_input_type.dart';

/// Extension point for future OCR / STT / vision / document extractors.
///
/// Implementations must not invent content when they cannot process.
abstract class AssistantInputProcessor {
  AssistantInputProcessorId get id;

  Set<AssistantInputType> get supportedTypes;

  /// Mime types this processor claims (empty = any for its types).
  Set<String> get supportedMimeTypes;

  Future<AssistantInputProcessingResult> process(
    AssistantInputProcessingRequest request,
  );
}
