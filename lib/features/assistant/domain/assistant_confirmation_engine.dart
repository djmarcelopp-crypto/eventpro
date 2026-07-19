import '../models/assistant_confirmation_status.dart';
import '../models/assistant_execution_step.dart';

/// Decides confirmation sufficiency — never executes commands.
abstract class AssistantConfirmationEngine {
  AssistantConfirmationStatus evaluate({
    required AssistantExecutionStep step,
    required Set<String> confirmedStepIds,
    required bool requireConfirmationForWrites,
  });
}
