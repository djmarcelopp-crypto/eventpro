import '../../models/assistant_production_write_policy_context.dart';
import '../../models/assistant_production_write_policy_decision.dart';
import '../../models/assistant_write_entity_state.dart';
import '../../models/assistant_write_operation.dart';
import '../../models/assistant_write_target.dart';

/// Explicit production write authorization policy (default deny).
abstract class AssistantProductionWritePolicy {
  String get name;

  bool get isActive;

  /// Whether this policy owns the given operation/target/state triple.
  bool matches({
    required AssistantWriteOperation operation,
    required AssistantWriteTarget target,
    required AssistantWriteEntityState requestedState,
  });

  AssistantProductionWritePolicyDecision evaluate(
    AssistantProductionWritePolicyContext context,
  );
}
