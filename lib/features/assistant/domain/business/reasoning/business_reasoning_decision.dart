import 'business_reasoning_confidence.dart';
import 'business_reasoning_issue.dart';

/// Outcome kind of a reasoning evaluation.
enum BusinessReasoningDecisionKind {
  proceed,
  block,
  askUser,
  resolveAmbiguity,
  satisfyDependency,
  confirmRisk,
}

/// Immutable decision with explainability fields (AI-023 / CP-7).
class BusinessReasoningDecision {
  const BusinessReasoningDecision({
    required this.kind,
    required this.reason,
    required this.confidence,
    this.appliedRules = const [],
    this.evidence = const [],
    this.issues = const [],
  });

  final BusinessReasoningDecisionKind kind;
  final String reason;
  final BusinessReasoningConfidence confidence;
  final List<String> appliedRules;
  final List<String> evidence;
  final List<BusinessReasoningIssue> issues;

  Map<String, Object?> toDeterministicMap() => {
        'kind': kind.name,
        'reason': reason,
        'confidence': confidence.toDeterministicMap(),
        'appliedRules': appliedRules,
        'evidence': evidence,
        'issues': issues.map((i) => i.toDeterministicMap()).toList(),
      };
}
