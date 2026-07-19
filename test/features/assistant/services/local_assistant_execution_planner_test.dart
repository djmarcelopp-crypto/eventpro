import 'package:eventpro/features/assistant/models/assistant_action.dart';
import 'package:eventpro/features/assistant/models/assistant_action_type.dart';
import 'package:eventpro/features/assistant/models/assistant_confidence.dart';
import 'package:eventpro/features/assistant/models/assistant_confirmation_policy.dart';
import 'package:eventpro/features/assistant/models/assistant_entity.dart';
import 'package:eventpro/features/assistant/models/assistant_entity_type.dart';
import 'package:eventpro/features/assistant/models/assistant_event_draft.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_status.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_intent.dart';
import 'package:eventpro/features/assistant/models/assistant_intent_type.dart';
import 'package:eventpro/features/assistant/models/assistant_module_target.dart';
import 'package:eventpro/features/assistant/models/assistant_provenance.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/models/assistant_response.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_execution_planner.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalAssistantExecutionPlanner', () {
    final planner = LocalAssistantExecutionPlanner();

    AssistantResponse baseResponse({
      required AssistantIntentType intent,
      AssistantEventDraft? eventDraft,
      List<AssistantEntity> entities = const [],
      String friendlyMessage = 'mensagem amigável com dados falsos dia 99/99',
    }) {
      return AssistantResponse(
        requestId: 'req-plan',
        rawText: 'texto',
        primaryIntent: AssistantIntent(
          type: intent,
          confidence: AssistantConfidence.fromScore(0.8),
          evidences: const ['test'],
        ),
        overallConfidence: AssistantConfidence.fromScore(0.7),
        friendlyMessage: friendlyMessage,
        eventDraft: eventDraft,
        entities: entities,
        actions: const [
          AssistantAction(
            type: AssistantActionType.reviewDraft,
            available: true,
          ),
        ],
      );
    }

    AssistantEventDraft completeDraft() => AssistantEventDraft(
          eventType: 'casamento',
          guestCount: 300,
          city: 'Uberlândia',
          date: DateTime(2026, 9, 18),
          startTime: '18:00',
          endTime: '23:00',
        );

    test('wedding without date yields blocked create event quote availability', () async {
      final response = baseResponse(
        intent: AssistantIntentType.createQuote,
        eventDraft: const AssistantEventDraft(
          eventType: 'casamento',
          guestCount: 300,
          city: 'Uberlândia',
        ),
      );

      final plan = planner.plan(response);

      expect(plan.steps, hasLength(3));
      expect(plan.steps.map((s) => s.order).toList(), [1, 2, 3]);
      expect(plan.steps[0].description, 'Criar Evento');
      expect(plan.steps[0].moduleTarget, AssistantModuleTarget.events);
      expect(plan.steps[0].status, AssistantExecutionStatus.blocked);
      expect(plan.steps[0].blockReason, contains('Data ausente'));
      expect(
        plan.steps[0].confirmationPolicy,
        AssistantConfirmationPolicy.requiredBeforeWrite,
      );

      expect(plan.steps[1].description, 'Criar Orçamento');
      expect(plan.steps[1].dependencyStepIds, contains('step-create-event'));
      expect(plan.steps[1].status, AssistantExecutionStatus.blocked);

      expect(plan.steps[2].description, 'Consultar Disponibilidade');
      expect(plan.steps[2].status, AssistantExecutionStatus.blocked);
      expect(plan.steps[2].blockReason, 'Data ausente');
      expect(plan.overallStatus, AssistantExecutionStatus.blocked);
      expect(plan.summary, contains('Nenhuma operação será executada'));
      expect(plan.readySteps, isEmpty);
    });

    test('complete data without executor yields unavailable not ready', () async {
      final plan = planner.plan(
        baseResponse(
          intent: AssistantIntentType.createQuote,
          eventDraft: completeDraft(),
        ),
      );

      expect(plan.steps.first.status, AssistantExecutionStatus.unavailable);
      expect(
        plan.steps.first.blockReason,
        contains('canExecuteCreateEvent=false'),
      );
      expect(plan.readySteps, isEmpty);
      // Dependents stay blocked while the root step is unavailable.
      expect(plan.overallStatus, AssistantExecutionStatus.blocked);
      expect(plan.hasExecutableReadySteps, isFalse);
      expect(
        plan.steps
            .where((s) => s.requiresConfirmation)
            .every((s) => !s.isReady),
        isTrue,
      );
    });

    test('end-to-end text produces blocked plan for missing date', () async {
      final now = DateTime(2026, 7, 18, 12);
      final orchestrator = LocalAssistantOrchestrator(clock: () => now);
      final interpreted = await orchestrator.handle(
        AssistantRequest(
          id: 'req-demo',
          rawText: 'Preciso de um casamento para 300 pessoas em Uberlândia.',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );

      final plan = planner.plan(interpreted);
      expect(plan.steps.map((s) => s.description).toList(), [
        'Criar Evento',
        'Criar Orçamento',
        'Consultar Disponibilidade',
      ]);
      expect(plan.blockedSteps, hasLength(3));
      expect(plan.readySteps, isEmpty);
      expect(
        plan.steps.any(
          (s) => s.blockReason?.toLowerCase().contains('data') == true,
        ),
        isTrue,
      );
    });

    test('disabled planning capability marks step unavailable', () async {
      final gated = LocalAssistantExecutionPlanner(
        capabilities: const AssistantCapabilities(canPlanCreateEvent: false),
      );
      final plan = gated.plan(
        baseResponse(
          intent: AssistantIntentType.createEvent,
          eventDraft: completeDraft(),
        ),
      );

      expect(plan.steps.first.status, AssistantExecutionStatus.unavailable);
      expect(plan.steps.first.blockReason, contains('canPlanCreateEvent=false'));
      expect(plan.readySteps, isEmpty);
    });

    test('confirmation does not enable execution without executor', () async {
      const caps = AssistantCapabilities();
      final before = LocalAssistantExecutionPlanner(capabilities: caps).plan(
        baseResponse(
          intent: AssistantIntentType.createEvent,
          eventDraft: completeDraft(),
        ),
      );
      final after = LocalAssistantExecutionPlanner(
        capabilities: caps,
        confirmedStepIds: const {'step-create-event'},
      ).plan(
        baseResponse(
          intent: AssistantIntentType.createEvent,
          eventDraft: completeDraft(),
        ),
      );

      expect(caps.canExecuteCreateEvent, isFalse);
      expect(before.steps.first.status, AssistantExecutionStatus.unavailable);
      expect(after.steps.first.status, AssistantExecutionStatus.unavailable);
      expect(after.steps.first.blockReason, contains('Executor indisponível'));
      expect(after.readySteps, isEmpty);
      expect(identical(caps, caps), isTrue);
    });

    test('confirmation with simulated executor only reaches awaiting then ready', () async {
      const caps = AssistantCapabilities(canExecuteCreateEvent: true);
      final pending = LocalAssistantExecutionPlanner(capabilities: caps).plan(
        baseResponse(
          intent: AssistantIntentType.createEvent,
          eventDraft: completeDraft(),
        ),
      );
      expect(
        pending.steps.first.status,
        AssistantExecutionStatus.awaitingConfirmation,
      );
      expect(pending.readySteps, isEmpty);

      final confirmed = LocalAssistantExecutionPlanner(
        capabilities: caps,
        confirmedStepIds: const {'step-create-event'},
      ).plan(
        baseResponse(
          intent: AssistantIntentType.createEvent,
          eventDraft: completeDraft(),
        ),
      );
      expect(confirmed.steps.first.status, AssistantExecutionStatus.ready);
      // Still no module/DB call — status is descriptive only.
      expect(caps.canExecuteCreateQuote, isFalse);
    });

    test('searchClient uses explicit plan/execute capabilities', () async {
      final withName = planner.plan(
        baseResponse(
          intent: AssistantIntentType.searchClient,
          eventDraft: const AssistantEventDraft(clientName: 'Maria'),
          entities: [
            AssistantEntity(
              type: AssistantEntityType.clientName,
              rawValue: 'Maria',
              normalizedValue: 'Maria',
              provenance: AssistantProvenance.extracted,
              confidence: AssistantConfidence.fromScore(0.9),
            ),
          ],
        ),
      );
      expect(withName.steps.single.status, AssistantExecutionStatus.unavailable);
      expect(
        withName.steps.single.blockReason,
        contains('canExecuteClientSearch=false'),
      );

      final noPlan = LocalAssistantExecutionPlanner(
        capabilities: const AssistantCapabilities(canPlanSearchClient: false),
      ).plan(
        baseResponse(
          intent: AssistantIntentType.searchClient,
          eventDraft: const AssistantEventDraft(clientName: 'Maria'),
        ),
      );
      expect(noPlan.steps.single.status, AssistantExecutionStatus.unavailable);
      expect(
        noPlan.steps.single.blockReason,
        contains('canPlanSearchClient=false'),
      );

      final missingName = planner.plan(
        baseResponse(intent: AssistantIntentType.searchClient),
      );
      expect(missingName.steps.single.status, AssistantExecutionStatus.blocked);
      expect(missingName.steps.single.blockReason, 'Nome do cliente ausente');
    });

    test('unknown intent yields empty non-executable plan', () async {
      final plan = planner.plan(
        baseResponse(intent: AssistantIntentType.unknown),
      );
      expect(plan.steps, isEmpty);
      expect(plan.readySteps, isEmpty);
      expect(plan.overallStatus, AssistantExecutionStatus.unavailable);
      expect(plan.summary, contains('Nenhuma ação executável'));
    });

    test('planner ignores friendlyMessage and stays deterministic', () async {
      final a = planner.plan(
        baseResponse(
          intent: AssistantIntentType.createQuote,
          eventDraft: const AssistantEventDraft(
            eventType: 'casamento',
            city: 'Uberlândia',
            guestCount: 300,
          ),
          friendlyMessage: 'Imagine que a data é 18/09/2026 às 20:00',
        ),
      );
      final b = planner.plan(
        baseResponse(
          intent: AssistantIntentType.createQuote,
          eventDraft: const AssistantEventDraft(
            eventType: 'casamento',
            city: 'Uberlândia',
            guestCount: 300,
          ),
          friendlyMessage: 'Texto totalmente diferente sem data',
        ),
      );
      expect(a, b);
      expect(a.steps.first.status, AssistantExecutionStatus.blocked);
      expect(a.steps.first.blockReason, isNot(contains('18/09')));
    });

    test('plan invariants hold for create flow', () async {
      final plan = planner.plan(
        baseResponse(
          intent: AssistantIntentType.createQuote,
          eventDraft: completeDraft(),
        ),
      );
      final ids = plan.steps.map((s) => s.id).toList();
      expect(ids.toSet().length, ids.length);
      final orders = plan.steps.map((s) => s.order).toList();
      expect(orders.toSet().length, orders.length);
      for (final step in plan.steps) {
        expect(step.dependencyStepIds.contains(step.id), isFalse);
        for (final dep in step.dependencyStepIds) {
          expect(ids, contains(dep));
        }
        if (step.intendedAction == 'createEvent' ||
            step.intendedAction == 'createQuote' ||
            step.intendedAction == 'updateEvent') {
          expect(
            step.confirmationPolicy,
            AssistantConfirmationPolicy.requiredBeforeWrite,
          );
        }
      }
      final byId = {for (final s in plan.steps) s.id: s};
      for (final step in plan.steps) {
        for (final depId in step.dependencyStepIds) {
          final dep = byId[depId]!;
          if (dep.isBlocked || dep.isUnavailable) {
            expect(step.isReady, isFalse);
          }
        }
      }
      expect(plan.readySteps, isEmpty);
    });

    test('dependent step is not ready when dependency is unavailable', () async {
      final plan = planner.plan(
        baseResponse(
          intent: AssistantIntentType.createQuote,
          eventDraft: completeDraft(),
        ),
      );
      expect(plan.steps[0].status, AssistantExecutionStatus.unavailable);
      expect(plan.steps[1].isReady, isFalse);
      expect(plan.steps[1].status, AssistantExecutionStatus.blocked);
      expect(plan.steps[1].blockReason, contains('Dependência'));
    });
  });
}
