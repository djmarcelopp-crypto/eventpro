import 'business_reasoning_request.dart';
import 'business_reasoning_result.dart';
import 'business_reasoning_suggestion.dart';

/// Port for deterministic ERP business reasoning (AI-023).
///
/// No LLM, NLP, HTTP, or concrete ERP adapters.
abstract class AssistantBusinessReasoning {
  /// Full evaluation (validate + conflicts + missing + decision + suggestions).
  Future<BusinessReasoningResult> evaluate(BusinessReasoningRequest request);

  /// Structural / required-data validation only.
  Future<BusinessReasoningResult> validate(BusinessReasoningRequest request);

  /// Detect conflicts between commands / flows.
  Future<BusinessReasoningResult> detectConflicts(
    BusinessReasoningRequest request,
  );

  /// Detect missing mandatory information.
  Future<BusinessReasoningResult> detectMissingInformation(
    BusinessReasoningRequest request,
  );

  /// Suggest next non-executing guidance.
  Future<List<BusinessReasoningSuggestion>> suggestNextAction(
    BusinessReasoningRequest request,
  );

  /// Explain the decision (motivo, regras, evidências, confiança).
  Future<List<String>> explainDecision(BusinessReasoningResult result);
}
