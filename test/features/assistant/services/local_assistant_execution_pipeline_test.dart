import 'package:eventpro/features/assistant/models/assistant_confirmation_policy.dart';
import 'package:eventpro/features/assistant/models/assistant_confirmation_status.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_context.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_outcome.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_plan.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_request.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_status.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_step.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_token.dart';
import 'package:eventpro/features/assistant/models/assistant_integration_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_module_target.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_confirmation_engine.dart';
import 'package:eventpro/features/assistant/services/local_assistant_execution_dispatcher.dart';
import 'package:eventpro/features/assistant/services/local_assistant_execution_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-004 validator confirmation dispatcher', () {
    final caps = AssistantCapabilities.localDefaults();
    final validator = LocalAssistantExecutionValidator(capabilities: caps);
    const confirmation = LocalAssistantConfirmationEngine();
    final dispatcher = LocalAssistantExecutionDispatcher(capabilities: caps);

    AssistantExecutionRequest request({
      AssistantExecutionMode mode = AssistantExecutionMode.dryRun,
      Set<String> confirmed = const {},
      List<AssistantExecutionStep>? steps,
    }) {
      return AssistantExecutionRequest(
        id: 'exec-1',
        context: AssistantExecutionContext(
          requestId: 'req-1',
          token: const AssistantExecutionToken('tok-1'),
          mode: mode,
          integrationMode: AssistantIntegrationMode.none,
          timestamp: DateTime(2026, 7, 19, 12),
          confirmedStepIds: confirmed,
        ),
        plan: AssistantExecutionPlan(
          id: 'plan-1',
          requestId: 'req-1',
          overallStatus: AssistantExecutionStatus.blocked,
          steps: steps ??
              const [
                AssistantExecutionStep(
                  id: 'step-create-event',
                  order: 1,
                  moduleTarget: AssistantModuleTarget.events,
                  intendedAction: 'createEvent',
                  description: 'Criar Evento',
                  status: AssistantExecutionStatus.blocked,
                  confirmationPolicy:
                      AssistantConfirmationPolicy.requiredBeforeWrite,
                  blockReason: 'Data ausente',
                ),
                AssistantExecutionStep(
                  id: 'step-check-schedule',
                  order: 2,
                  moduleTarget: AssistantModuleTarget.agenda,
                  intendedAction: 'checkSchedule',
                  description: 'Consultar Agenda',
                  status: AssistantExecutionStatus.unavailable,
                  blockReason: 'Executor indisponível',
                ),
              ],
        ),
      );
    }

    test('validator rejects production mode', () {
      final result = validator.validate(
        request(mode: AssistantExecutionMode.production),
      );
      expect(result.isValid, isFalse);
      expect(result.issues.join(' '), contains('production'));
    });

    test('confirmation engine separates required missing and valid', () {
      const step = AssistantExecutionStep(
        id: 'step-create-event',
        order: 1,
        moduleTarget: AssistantModuleTarget.events,
        intendedAction: 'createEvent',
        description: 'Criar Evento',
        status: AssistantExecutionStatus.awaitingConfirmation,
        confirmationPolicy: AssistantConfirmationPolicy.requiredBeforeWrite,
      );
      expect(
        confirmation.evaluate(
          step: step,
          confirmedStepIds: const {},
          requireConfirmationForWrites: true,
        ),
        AssistantConfirmationStatus.requiredMissing,
      );
      expect(
        confirmation.evaluate(
          step: step,
          confirmedStepIds: const {'step-create-event'},
          requireConfirmationForWrites: true,
        ),
        AssistantConfirmationStatus.providedValid,
      );
    });

    test('dispatcher dry-run never mutates and classifies steps', () {
      final report = dispatcher.dispatch(request());
      expect(report.mutatedErp, isFalse);
      expect(report.mode, AssistantExecutionMode.dryRun);
      expect(report.blockedSteps, hasLength(1));
      expect(report.unavailableSteps, hasLength(1));
      expect(report.simulatedSteps, isEmpty);
      expect(
        report.results.every(
          (r) =>
              r.outcome == AssistantExecutionOutcome.skippedBlocked ||
              r.outcome == AssistantExecutionOutcome.skippedUnavailable,
        ),
        isTrue,
      );
      expect(
        report.warnings.any((w) => w.contains('Nenhuma alteração')),
        isTrue,
      );
      expect(report.audit.executionToken.value, 'tok-1');
    });

    test('dispatcher simulates ready read step without gateway calls', () {
      final report = dispatcher.dispatch(
        request(
          steps: const [
            AssistantExecutionStep(
              id: 'step-check-schedule',
              order: 1,
              moduleTarget: AssistantModuleTarget.agenda,
              intendedAction: 'checkSchedule',
              description: 'Consultar Agenda',
              status: AssistantExecutionStatus.ready,
            ),
          ],
        ),
      );
      expect(report.simulatedSteps, hasLength(1));
      expect(report.results.single.outcome, AssistantExecutionOutcome.simulated);
      expect(report.eligibleSteps, hasLength(1));
    });

    test('write step with confirmation still only simulates', () {
      final report = dispatcher.dispatch(
        request(
          confirmed: const {'step-create-event'},
          steps: const [
            AssistantExecutionStep(
              id: 'step-create-event',
              order: 1,
              moduleTarget: AssistantModuleTarget.events,
              intendedAction: 'createEvent',
              description: 'Criar Evento',
              status: AssistantExecutionStatus.awaitingConfirmation,
              confirmationPolicy:
                  AssistantConfirmationPolicy.requiredBeforeWrite,
            ),
          ],
        ),
      );
      expect(report.simulatedSteps, hasLength(1));
      expect(report.results.single.outcome, AssistantExecutionOutcome.simulated);
      expect(report.mutatedErp, isFalse);
      expect(
        report.audit.confirmationStatus,
        AssistantConfirmationStatus.providedValid,
      );
    });
  });
}
