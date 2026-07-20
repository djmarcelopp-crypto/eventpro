import 'assistant_input.dart';
import 'assistant_input_normalization_result.dart';

/// Validates and normalizes multimodal inputs — never runs OCR/STT/vision.
abstract class AssistantInputNormalizer {
  AssistantInputNormalizationResult normalize(AssistantInput input);
}
