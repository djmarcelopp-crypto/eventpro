import 'package:eventpro/features/assistant/models/assistant_confirmation_policy.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_decision.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_plan.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_requirement.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_risk.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_status.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_step.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_warning.dart';
import 'package:eventpro/features/assistant/models/assistant_module_target.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AssistantExecutionPlan domain', () {
    test('step exposes order module confirmation and blocked state', () {
      const step = AssistantExecutionStep(
        id: 'step-create-event',
        order: 1,
        moduleTarget: AssistantModuleTarget.events,
        intendedAction: 'createEvent',
        description: 'Criar Evento',
        status: AssistantExecutionStatus.blocked,
        preconditions: [
          AssistantExecutionRequirement(
            id: 'req-date',
            description: 'Data do evento informada',
            satisfied: false,
          ),
        ],
        risks: [
          AssistantExecutionRisk(
            id: 'risk-write',
            description: 'Escrita no módulo de eventos',
            severity: 'high',
          ),
        ],
        confirmationPolicy: AssistantConfirmationPolicy.requiredBeforeWrite,
        blockReason: 'Data ausente',
      );

      expect(step.isBlocked, isTrue);
      expect(step.isReady, isFalse);
      expect(step.requiresConfirmation, isTrue);
      expect(step.dependencyStepIds, isEmpty);
      expect(
        step.copyWith(status: AssistantExecutionStatus.ready).isReady,
        isTrue,
      );
    });

    test('plan aggregates blocked ready warnings and decisions', () {
      const plan = AssistantExecutionPlan(
        id: 'plan-1',
        requestId: 'req-1',
        overallStatus: AssistantExecutionStatus.blocked,
        summary: 'Plano bloqueado por informações ausentes',
        steps: [
          AssistantExecutionStep(
            id: 's1',
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
            id: 's2',
            order: 2,
            moduleTarget: AssistantModuleTarget.quotes,
            intendedAction: 'createQuote',
            description: 'Criar Orçamento',
            status: AssistantExecutionStatus.blocked,
            dependencyStepIds: ['s1'],
            confirmationPolicy:
                AssistantConfirmationPolicy.requiredBeforeWrite,
            blockReason: 'Dependência não satisfeita',
          ),
          AssistantExecutionStep(
            id: 's3',
            order: 3,
            moduleTarget: AssistantModuleTarget.agenda,
            intendedAction: 'checkAvailability',
            description: 'Consultar Disponibilidade',
            status: AssistantExecutionStatus.blocked,
            blockReason: 'Data ausente',
          ),
        ],
        decisions: [
          AssistantExecutionDecision(
            id: 'd1',
            description: 'Não executar nenhuma etapa',
            rationale: 'AI-002 apenas planeja',
          ),
        ],
        warnings: [
          AssistantExecutionWarning(
            id: 'w1',
            message: 'Nenhuma operação real será realizada',
          ),
        ],
      );

      expect(plan.steps, hasLength(3));
      expect(plan.blockedSteps, hasLength(3));
      expect(plan.readySteps, isEmpty);
      expect(plan.stepsRequiringConfirmation, hasLength(2));
      expect(plan.hasBlockedSteps, isTrue);
      expect(plan.steps.map((s) => s.order).toList(), [1, 2, 3]);
      expect(plan.decisions.single.id, 'd1');
      expect(plan.warnings.single.message, contains('Nenhuma operação'));
    });

    test('module target and confirmation policy enums are stable', () {
      expect(
        AssistantModuleTarget.values,
        containsAll([
          AssistantModuleTarget.events,
          AssistantModuleTarget.quotes,
          AssistantModuleTarget.agenda,
          AssistantModuleTarget.inventory,
          AssistantModuleTarget.finance,
        ]),
      );
      expect(
        AssistantConfirmationPolicy.values,
        contains(AssistantConfirmationPolicy.requiredBeforeWrite),
      );
      expect(
        AssistantExecutionStatus.values,
        containsAll([
          AssistantExecutionStatus.blocked,
          AssistantExecutionStatus.unavailable,
          AssistantExecutionStatus.awaitingConfirmation,
          AssistantExecutionStatus.ready,
        ]),
      );
    });

    test('unavailable step is distinct from blocked and ready', () {
      const step = AssistantExecutionStep(
        id: 's-unavail',
        order: 1,
        moduleTarget: AssistantModuleTarget.events,
        intendedAction: 'createEvent',
        description: 'Criar Evento',
        status: AssistantExecutionStatus.unavailable,
        confirmationPolicy: AssistantConfirmationPolicy.requiredBeforeWrite,
        blockReason: 'Executor indisponível: canExecuteCreateEvent=false',
      );
      expect(step.isUnavailable, isTrue);
      expect(step.isBlocked, isFalse);
      expect(step.isReady, isFalse);

      const plan = AssistantExecutionPlan(
        id: 'p',
        requestId: 'r',
        overallStatus: AssistantExecutionStatus.unavailable,
        steps: [step],
      );
      expect(plan.unavailableSteps, hasLength(1));
      expect(plan.hasExecutableReadySteps, isFalse);
    });
  });
}
