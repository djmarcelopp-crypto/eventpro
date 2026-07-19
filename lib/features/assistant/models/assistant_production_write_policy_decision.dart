import 'assistant_write_failure.dart';

/// Decision from a production write policy evaluation.
class AssistantProductionWritePolicyDecision {
  const AssistantProductionWritePolicyDecision({
    required this.allowed,
    required this.policyName,
    this.failure,
    this.reason = '',
  });

  final bool allowed;
  final String policyName;
  final AssistantWriteFailure? failure;
  final String reason;

  factory AssistantProductionWritePolicyDecision.allow(String policyName) {
    return AssistantProductionWritePolicyDecision(
      allowed: true,
      policyName: policyName,
      reason: 'Permitido por $policyName',
    );
  }

  factory AssistantProductionWritePolicyDecision.deny({
    required String policyName,
    required AssistantWriteFailure failure,
  }) {
    return AssistantProductionWritePolicyDecision(
      allowed: false,
      policyName: policyName,
      failure: failure,
      reason: failure.message,
    );
  }
}
