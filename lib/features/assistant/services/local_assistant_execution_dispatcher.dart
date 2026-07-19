import '../domain/assistant_confirmation_engine.dart';
import '../domain/assistant_execution_dispatcher.dart';
import '../domain/assistant_execution_validator.dart';
import '../models/assistant_confirmation_status.dart';
import '../models/assistant_execution_audit.dart';
import '../models/assistant_execution_decision.dart';
import '../models/assistant_execution_mode.dart';
import '../models/assistant_execution_outcome.dart';
import '../models/assistant_execution_report.dart';
import '../models/assistant_execution_request.dart';
import '../models/assistant_execution_result.dart';
import '../models/assistant_execution_status.dart';
import '../models/assistant_execution_step.dart';
import 'assistant_capabilities.dart';
import 'local_assistant_confirmation_engine.dart';
import 'local_assistant_execution_validator.dart';

/// Dry-run/simulation dispatcher.
///
/// Flow: Validator → Confirmation → Report.
/// Never calls gateways, repositories, or ERP modules.
class LocalAssistantExecutionDispatcher implements AssistantExecutionDispatcher {
  LocalAssistantExecutionDispatcher({
    required AssistantCapabilities capabilities,
    AssistantExecutionValidator? validator,
    AssistantConfirmationEngine? confirmationEngine,
  })  : _capabilities = capabilities,
        _validator = validator ??
            LocalAssistantExecutionValidator(capabilities: capabilities),
        _confirmation =
            confirmationEngine ?? const LocalAssistantConfirmationEngine();

  final AssistantCapabilities _capabilities;
  final AssistantExecutionValidator _validator;
  final AssistantConfirmationEngine _confirmation;

  @override
  AssistantExecutionReport dispatch(AssistantExecutionRequest request) {
    final validation = _validator.validate(request);
    if (!validation.isValid) {
      return _rejectedReport(request, validation.issues);
    }

    final eligible = <AssistantExecutionStep>[];
    final blocked = <AssistantExecutionStep>[];
    final unavailable = <AssistantExecutionStep>[];
    final awaiting = <AssistantExecutionStep>[];
    final simulated = <AssistantExecutionStep>[];
    final skipped = <AssistantExecutionStep>[];
    final results = <AssistantExecutionResult>[];
    final warnings = <String>[];
    var aggregateConfirmation = AssistantConfirmationStatus.notRequired;

    for (final step in request.plan.steps) {
      if (step.isBlocked) {
        blocked.add(step);
        skipped.add(step);
        results.add(
          AssistantExecutionResult(
            stepId: step.id,
            outcome: AssistantExecutionOutcome.skippedBlocked,
            message: step.blockReason ?? 'Passo bloqueado',
          ),
        );
        continue;
      }
      if (step.isUnavailable) {
        unavailable.add(step);
        skipped.add(step);
        results.add(
          AssistantExecutionResult(
            stepId: step.id,
            outcome: AssistantExecutionOutcome.skippedUnavailable,
            message: step.blockReason ?? 'Passo indisponível',
          ),
        );
        continue;
      }

      final confirmation = _confirmation.evaluate(
        step: step,
        confirmedStepIds: request.context.confirmedStepIds,
        requireConfirmationForWrites:
            request.context.policy.requireConfirmationForWrites,
      );

      final needsAwait = confirmation ==
              AssistantConfirmationStatus.requiredMissing ||
          (step.status == AssistantExecutionStatus.awaitingConfirmation &&
              confirmation != AssistantConfirmationStatus.providedValid);

      if (needsAwait) {
        awaiting.add(step);
        skipped.add(step);
        aggregateConfirmation = AssistantConfirmationStatus.requiredMissing;
        results.add(
          AssistantExecutionResult(
            stepId: step.id,
            outcome: AssistantExecutionOutcome.awaitingConfirmation,
            message: 'Aguardando confirmação do usuário (sem execução real)',
          ),
        );
        continue;
      }

      if (confirmation == AssistantConfirmationStatus.providedInvalid) {
        skipped.add(step);
        aggregateConfirmation = AssistantConfirmationStatus.providedInvalid;
        results.add(
          AssistantExecutionResult(
            stepId: step.id,
            outcome: AssistantExecutionOutcome.rejected,
            message: 'Confirmação inválida para o passo',
          ),
        );
        continue;
      }

      eligible.add(step);
      simulated.add(step);
      if (confirmation == AssistantConfirmationStatus.providedValid) {
        aggregateConfirmation = AssistantConfirmationStatus.providedValid;
      }
      results.add(
        AssistantExecutionResult(
          stepId: step.id,
          outcome: AssistantExecutionOutcome.simulated,
          message: request.context.mode == AssistantExecutionMode.simulation
              ? 'Simulado — nenhuma alteração no EventPRO'
              : 'Dry-run — nenhuma alteração no EventPRO',
        ),
      );
    }

    warnings.add(
      'O assistente simulou a execução. Nenhuma alteração foi realizada no EventPRO.',
    );

    final audit = AssistantExecutionAudit(
      timestamp: request.context.timestamp,
      executionToken: request.context.token,
      executionMode: request.context.mode,
      stepIds: request.plan.steps.map((s) => s.id).toList(growable: false),
      confirmationStatus: aggregateConfirmation,
      plannerVersion: request.context.plannerVersion,
      integrationMode: request.context.integrationMode,
      dataSources: request.consultedDataSources,
      decisions: [
        const AssistantExecutionDecision(
          id: 'decision-no-real-execution',
          description: 'Nenhuma operação real foi despachada',
          rationale: 'AI-004 dispatcher produz apenas dry-run/simulation',
        ),
        AssistantExecutionDecision(
          id: 'decision-mode',
          description: 'Modo ${request.context.mode.name}',
          rationale:
              'allowProduction=${request.context.policy.allowProduction}; '
              'writesEnabled=${_capabilities.anyWriteExecutionEnabled}',
        ),
      ],
    );

    return AssistantExecutionReport(
      mode: request.context.mode,
      audit: audit,
      summary:
          'Pipeline controlado (${request.context.mode.name}): '
          '${simulated.length} simulado(s), ${blocked.length} bloqueado(s), '
          '${unavailable.length} indisponível(is), '
          '${awaiting.length} aguardando confirmação. '
          'Nenhuma alteração foi realizada no EventPRO.',
      eligibleSteps: List.unmodifiable(eligible),
      blockedSteps: List.unmodifiable(blocked),
      unavailableSteps: List.unmodifiable(unavailable),
      awaitingConfirmationSteps: List.unmodifiable(awaiting),
      simulatedSteps: List.unmodifiable(simulated),
      skippedSteps: List.unmodifiable(skipped),
      results: List.unmodifiable(results),
      warnings: List.unmodifiable(warnings),
    );
  }

  AssistantExecutionReport _rejectedReport(
    AssistantExecutionRequest request,
    List<String> issues,
  ) {
    final audit = AssistantExecutionAudit(
      timestamp: request.context.timestamp,
      executionToken: request.context.token,
      executionMode: request.context.mode,
      stepIds: request.plan.steps.map((s) => s.id).toList(growable: false),
      confirmationStatus: AssistantConfirmationStatus.providedInvalid,
      plannerVersion: request.context.plannerVersion,
      integrationMode: request.context.integrationMode,
      dataSources: request.consultedDataSources,
      decisions: [
        AssistantExecutionDecision(
          id: 'decision-validation-failed',
          description: 'Request rejeitado pelo validator',
          rationale: issues.join('; '),
        ),
      ],
    );
    return AssistantExecutionReport(
      mode: request.context.mode,
      audit: audit,
      summary: 'Execução rejeitada pela validação. Nenhuma alteração no EventPRO.',
      warnings: [
        ...issues,
        'O assistente simulou a execução. Nenhuma alteração foi realizada no EventPRO.',
      ],
      results: [
        for (final step in request.plan.steps)
          AssistantExecutionResult(
            stepId: step.id,
            outcome: AssistantExecutionOutcome.rejected,
            message: 'Rejeitado na validação',
          ),
      ],
      skippedSteps: request.plan.steps,
    );
  }
}
