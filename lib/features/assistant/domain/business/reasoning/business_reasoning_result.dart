import 'business_reasoning_decision.dart';
import 'business_reasoning_issue.dart';
import 'business_reasoning_metadata.dart';
import 'business_reasoning_request.dart';
import 'business_reasoning_suggestion.dart';

/// Aggregate result of Business Reasoning (AI-023).
class BusinessReasoningResult {
  const BusinessReasoningResult({
    required this.requestId,
    required this.request,
    required this.decision,
    this.issues = const [],
    this.suggestions = const [],
    this.explanations = const [],
    this.metadata = const BusinessReasoningMetadata(),
  });

  final String requestId;
  final BusinessReasoningRequest request;
  final BusinessReasoningDecision decision;
  final List<BusinessReasoningIssue> issues;
  final List<BusinessReasoningSuggestion> suggestions;

  /// Human-readable explanation lines (motivo + regras + evidências).
  final List<String> explanations;
  final BusinessReasoningMetadata metadata;

  bool get canProceed =>
      decision.kind == BusinessReasoningDecisionKind.proceed;

  bool get isBlocked =>
      decision.kind == BusinessReasoningDecisionKind.block;

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'request': request.toDeterministicMap(),
        'decision': decision.toDeterministicMap(),
        'issues': issues.map((i) => i.toDeterministicMap()).toList(),
        'suggestions':
            suggestions.map((s) => s.toDeterministicMap()).toList(),
        'explanations': explanations,
        'metadata': metadata.toDeterministicMap(),
      };
}
