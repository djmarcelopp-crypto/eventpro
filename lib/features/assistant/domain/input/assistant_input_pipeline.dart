import 'assistant_input.dart';
import 'assistant_input_normalization_result.dart';
import 'assistant_input_processing_result.dart';

/// Full multimodal pipeline outcome for one intake.
class AssistantInputPipelineResult {
  const AssistantInputPipelineResult({
    required this.input,
    required this.normalization,
    this.processing,
  });

  final AssistantInput input;
  final AssistantInputNormalizationResult normalization;
  final AssistantInputProcessingResult? processing;

  bool get readyForInterpretation => normalization.ready;

  String? get normalizedText => normalization.normalizedText;

  String get inputId => input.id.value;

  String get correlationId => input.effectiveCorrelationId;

  Map<String, Object?> toDeterministicMap() => {
        'inputId': inputId,
        'correlationId': correlationId,
        'readyForInterpretation': readyForInterpretation,
        'normalization': normalization.toDeterministicMap(),
        'processing': processing?.toDeterministicMap(),
      };
}

/// Orchestrates validation → processor resolution → normalization.
abstract class AssistantInputPipeline {
  Future<AssistantInputPipelineResult> run(AssistantInput input);
}
