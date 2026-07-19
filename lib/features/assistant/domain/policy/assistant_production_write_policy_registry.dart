import '../../models/assistant_production_write_policy_context.dart';
import '../../models/assistant_production_write_policy_decision.dart';
import '../../models/assistant_write_entity_state.dart';
import '../../models/assistant_write_failure.dart';
import '../../models/assistant_write_failure_code.dart';
import '../../models/assistant_write_operation.dart';
import '../../models/assistant_write_target.dart';
import 'assistant_production_write_policy.dart';

/// Registry of production write policies — default deny, unique match.
class AssistantProductionWritePolicyRegistry {
  AssistantProductionWritePolicyRegistry(List<AssistantProductionWritePolicy> policies)
      : _policies = List.unmodifiable(policies) {
    _assertNoActiveDuplicates();
  }

  final List<AssistantProductionWritePolicy> _policies;

  List<AssistantProductionWritePolicy> get policies => _policies;

  List<AssistantProductionWritePolicy> get activePolicies =>
      _policies.where((p) => p.isActive).toList(growable: false);

  AssistantProductionWritePolicyDecision resolve(
    AssistantProductionWritePolicyContext context,
  ) {
    final matches = activePolicies
        .where(
          (p) => p.matches(
            operation: context.request.operation,
            target: context.request.target,
            requestedState: context.request.requestedState,
          ),
        )
        .toList(growable: false);

    if (matches.isEmpty) {
      return AssistantProductionWritePolicyDecision.deny(
        policyName: 'none',
        failure: const AssistantWriteFailure(
          code: AssistantWriteFailureCode.productionNotAllowed,
          message: 'Nenhuma policy de production ativa para a operação',
        ),
      );
    }
    if (matches.length > 1) {
      return AssistantProductionWritePolicyDecision.deny(
        policyName: 'registry',
        failure: AssistantWriteFailure(
          code: AssistantWriteFailureCode.productionNotAllowed,
          message:
              'Policies ativas duplicadas: ${matches.map((m) => m.name).join(', ')}',
        ),
      );
    }
    return matches.single.evaluate(context);
  }

  void _assertNoActiveDuplicates() {
    final seen = <String>{};
    for (final policy in activePolicies) {
      for (final operation in AssistantWriteOperation.values) {
        for (final target in AssistantWriteTarget.values) {
          for (final state in AssistantWriteEntityState.values) {
            if (!policy.matches(
              operation: operation,
              target: target,
              requestedState: state,
            )) {
              continue;
            }
            final key = '${operation.name}/${target.name}/${state.name}';
            if (!seen.add(key)) {
              throw StateError(
                'Policy ativa duplicada para $key (${policy.name})',
              );
            }
          }
        }
      }
    }
  }
}
