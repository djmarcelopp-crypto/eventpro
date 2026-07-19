import '../../domain/policy/assistant_production_write_policy.dart';
import '../../models/assistant_production_write_policy_context.dart';
import '../../models/assistant_production_write_policy_decision.dart';
import '../../models/assistant_write_entity_state.dart';
import '../../models/assistant_write_failure.dart';
import '../../models/assistant_write_failure_code.dart';
import '../../models/assistant_write_operation.dart';
import '../../models/assistant_write_target.dart';

/// Placeholder — never active. Documents future event writes as blocked.
class EventProductionPolicy implements AssistantProductionWritePolicy {
  const EventProductionPolicy();

  @override
  String get name => 'EventProductionPolicy';

  @override
  bool get isActive => false;

  @override
  bool matches({
    required AssistantWriteOperation operation,
    required AssistantWriteTarget target,
    required AssistantWriteEntityState requestedState,
  }) {
    return target == AssistantWriteTarget.event;
  }

  @override
  AssistantProductionWritePolicyDecision evaluate(
    AssistantProductionWritePolicyContext context,
  ) {
    return AssistantProductionWritePolicyDecision.deny(
      policyName: name,
      failure: const AssistantWriteFailure(
        code: AssistantWriteFailureCode.productionNotAllowed,
        message: 'EventProductionPolicy é placeholder bloqueado',
      ),
    );
  }
}

/// Placeholder — never active. Documents future customer writes as blocked.
class CustomerProductionPolicy implements AssistantProductionWritePolicy {
  const CustomerProductionPolicy();

  @override
  String get name => 'CustomerProductionPolicy';

  @override
  bool get isActive => false;

  @override
  bool matches({
    required AssistantWriteOperation operation,
    required AssistantWriteTarget target,
    required AssistantWriteEntityState requestedState,
  }) {
    return target == AssistantWriteTarget.client;
  }

  @override
  AssistantProductionWritePolicyDecision evaluate(
    AssistantProductionWritePolicyContext context,
  ) {
    return AssistantProductionWritePolicyDecision.deny(
      policyName: name,
      failure: const AssistantWriteFailure(
        code: AssistantWriteFailureCode.productionNotAllowed,
        message: 'CustomerProductionPolicy é placeholder bloqueado',
      ),
    );
  }
}
