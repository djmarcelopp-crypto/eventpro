/// Severity / category of a reasoning issue.
enum BusinessReasoningIssueSeverity {
  info,
  warning,
  error,
  blocker,
}

enum BusinessReasoningIssueCode {
  clientMissing,
  clientAmbiguous,
  clientNotFound,
  eventMissing,
  eventNotFound,
  quoteClosed,
  contractCancelled,
  requiredDataMissing,
  pendingDependency,
  invalidFlow,
  commandConflict,
  insufficientInformation,
}

/// Structured issue found by Business Reasoning.
class BusinessReasoningIssue {
  const BusinessReasoningIssue({
    required this.code,
    required this.message,
    this.severity = BusinessReasoningIssueSeverity.warning,
    this.evidence = const [],
    this.ruleId,
  });

  final BusinessReasoningIssueCode code;
  final String message;
  final BusinessReasoningIssueSeverity severity;
  final List<String> evidence;
  final String? ruleId;

  Map<String, Object?> toDeterministicMap() => {
        'code': code.name,
        'message': message,
        'severity': severity.name,
        'evidence': evidence,
        'ruleId': ruleId,
      };
}
