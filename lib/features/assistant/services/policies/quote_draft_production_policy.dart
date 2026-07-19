import '../../domain/policy/assistant_production_write_policy.dart';
import '../../models/assistant_execution_mode.dart';
import '../../models/assistant_production_write_policy_context.dart';
import '../../models/assistant_production_write_policy_decision.dart';
import '../../models/assistant_write_authorization_status.dart';
import '../../models/assistant_write_entity_state.dart';
import '../../models/assistant_write_failure.dart';
import '../../models/assistant_write_failure_code.dart';
import '../../models/assistant_write_operation.dart';
import '../../models/assistant_write_target.dart';

/// Sole active production policy in AI-007: create quote draft only.
class QuoteDraftProductionPolicy implements AssistantProductionWritePolicy {
  const QuoteDraftProductionPolicy({
    this.approvedAdapterName = 'QuoteAssistantWriteAdapter',
  });

  final String approvedAdapterName;

  @override
  String get name => 'QuoteDraftProductionPolicy';

  @override
  bool get isActive => true;

  @override
  bool matches({
    required AssistantWriteOperation operation,
    required AssistantWriteTarget target,
    required AssistantWriteEntityState requestedState,
  }) {
    return operation == AssistantWriteOperation.create &&
        target == AssistantWriteTarget.quote &&
        requestedState == AssistantWriteEntityState.draft;
  }

  @override
  AssistantProductionWritePolicyDecision evaluate(
    AssistantProductionWritePolicyContext context,
  ) {
    final request = context.request;
    final exec = context.executionContext;

    if (exec.mode != AssistantExecutionMode.production) {
      return AssistantProductionWritePolicyDecision.deny(
        policyName: name,
        failure: const AssistantWriteFailure(
          code: AssistantWriteFailureCode.productionNotAllowed,
          message: 'Policy de production exige mode=production',
        ),
      );
    }
    if (!matches(
      operation: request.operation,
      target: request.target,
      requestedState: request.requestedState,
    )) {
      return AssistantProductionWritePolicyDecision.deny(
        policyName: name,
        failure: const AssistantWriteFailure(
          code: AssistantWriteFailureCode.unsupportedOperation,
          message: 'Policy permite apenas create quote draft',
        ),
      );
    }
    if (request.idempotencyKey == null || !request.idempotencyKey!.isValid) {
      return AssistantProductionWritePolicyDecision.deny(
        policyName: name,
        failure: const AssistantWriteFailure(
          code: AssistantWriteFailureCode.missingIdempotencyKey,
          message: 'Idempotency key obrigatória',
        ),
      );
    }
    if (context.authorizationStatus ==
            AssistantWriteAuthorizationStatus.denied ||
        context.authorizationStatus ==
            AssistantWriteAuthorizationStatus.insufficientPrivileges) {
      return AssistantProductionWritePolicyDecision.deny(
        policyName: name,
        failure: const AssistantWriteFailure(
          code: AssistantWriteFailureCode.authorizationDenied,
          message: 'Autorização negada',
        ),
      );
    }
    if (!context.preparation.writeValidation.valid) {
      return AssistantProductionWritePolicyDecision.deny(
        policyName: name,
        failure: const AssistantWriteFailure(
          code: AssistantWriteFailureCode.validationDenied,
          message: 'Validação negada',
        ),
      );
    }
    if (exec.policy.requireConfirmationForWrites &&
        !context.confirmationSatisfied) {
      return AssistantProductionWritePolicyDecision.deny(
        policyName: name,
        failure: const AssistantWriteFailure(
          code: AssistantWriteFailureCode.confirmationRequired,
          message: 'Confirmação obrigatória ausente',
        ),
      );
    }
    if (!context.adapterAvailable) {
      return AssistantProductionWritePolicyDecision.deny(
        policyName: name,
        failure: const AssistantWriteFailure(
          code: AssistantWriteFailureCode.adapterUnavailable,
          message: 'Adapter indisponível',
        ),
      );
    }
    if (context.adapterName.isNotEmpty &&
        context.adapterName != approvedAdapterName) {
      return AssistantProductionWritePolicyDecision.deny(
        policyName: name,
        failure: AssistantWriteFailure(
          code: AssistantWriteFailureCode.adapterUnavailable,
          message: 'Adapter não aprovado: ${context.adapterName}',
        ),
      );
    }
    return AssistantProductionWritePolicyDecision.allow(name);
  }
}
