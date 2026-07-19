import '../domain/assistant_confirmation_engine.dart';
import '../models/assistant_confirmation_policy.dart';
import '../models/assistant_confirmation_status.dart';
import '../models/assistant_execution_step.dart';

/// Confirmation gate — never triggers ERP commands.
class LocalAssistantConfirmationEngine implements AssistantConfirmationEngine {
  const LocalAssistantConfirmationEngine();

  @override
  AssistantConfirmationStatus evaluate({
    required AssistantExecutionStep step,
    required Set<String> confirmedStepIds,
    required bool requireConfirmationForWrites,
  }) {
    final needsConfirmation = step.requiresConfirmation ||
        (requireConfirmationForWrites &&
            step.confirmationPolicy ==
                AssistantConfirmationPolicy.requiredBeforeWrite);

    if (!needsConfirmation &&
        step.confirmationPolicy == AssistantConfirmationPolicy.none) {
      return AssistantConfirmationStatus.notRequired;
    }

    if (!needsConfirmation) {
      return AssistantConfirmationStatus.notRequired;
    }

    if (!confirmedStepIds.contains(step.id)) {
      return AssistantConfirmationStatus.requiredMissing;
    }

    // Confirmation tokens are step-id membership only in AI-004.
    // Invalid if step is blocked/unavailable (cannot confirm a non-runnable step).
    if (step.isBlocked || step.isUnavailable) {
      return AssistantConfirmationStatus.providedInvalid;
    }

    return AssistantConfirmationStatus.providedValid;
  }
}
