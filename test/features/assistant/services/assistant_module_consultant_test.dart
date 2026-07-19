import 'package:eventpro/features/assistant/adapters/in_memory_agenda_gateway.dart';
import 'package:eventpro/features/assistant/adapters/in_memory_client_gateway.dart';
import 'package:eventpro/features/assistant/adapters/local_assistant_gateway.dart';
import 'package:eventpro/features/assistant/domain/gateway/client_gateway.dart';
import 'package:eventpro/features/assistant/models/assistant_confidence.dart';
import 'package:eventpro/features/assistant/models/assistant_confirmation_policy.dart';
import 'package:eventpro/features/assistant/models/assistant_event_draft.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_plan.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_status.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_step.dart';
import 'package:eventpro/features/assistant/models/assistant_integration_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_intent.dart';
import 'package:eventpro/features/assistant/models/assistant_intent_type.dart';
import 'package:eventpro/features/assistant/models/assistant_module_availability.dart';
import 'package:eventpro/features/assistant/models/assistant_module_capability.dart';
import 'package:eventpro/features/assistant/models/assistant_module_data_source.dart';
import 'package:eventpro/features/assistant/models/assistant_module_request.dart';
import 'package:eventpro/features/assistant/models/assistant_module_response.dart';
import 'package:eventpro/features/assistant/models/assistant_module_target.dart';
import 'package:eventpro/features/assistant/models/assistant_response.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/assistant_module_consultant.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AssistantModuleConsultant', () {
    AssistantResponse clientResponse({String? clientName = 'João'}) {
      return AssistantResponse(
        requestId: 'req-1',
        rawText: 'Procure o cliente João',
        primaryIntent: AssistantIntent(
          type: AssistantIntentType.searchClient,
          confidence: AssistantConfidence.fromScore(0.9),
        ),
        overallConfidence: AssistantConfidence.fromScore(0.9),
        friendlyMessage: 'msg',
        eventDraft: AssistantEventDraft(clientName: clientName),
      );
    }

    AssistantExecutionPlan clientPlan({
      AssistantExecutionStatus status = AssistantExecutionStatus.ready,
    }) {
      return AssistantExecutionPlan(
        id: 'plan-1',
        requestId: 'req-1',
        overallStatus: status,
        steps: [
          AssistantExecutionStep(
            id: 'step-search-client',
            order: 1,
            moduleTarget: AssistantModuleTarget.clients,
            intendedAction: 'searchClient',
            description: 'Buscar Cliente',
            status: status,
            confirmationPolicy: AssistantConfirmationPolicy.none,
          ),
        ],
      );
    }

    LocalAssistantGateway clientGateway() => LocalAssistantGateway(
          clients: InMemoryClientGateway(
            seed: const [
              InMemoryClientRecord(
                identifier: 'cli-joao',
                displayName: 'João Pereira',
              ),
            ],
          ),
        );

    test('consults when plan+execute+gateway aligned and tags inMemory', () {
      final consultant = AssistantModuleConsultant(
        capabilities: AssistantCapabilities.localReadIntegration(),
        gateway: clientGateway(),
      );

      final outcome = consultant.consult(
        response: clientResponse(),
        plan: clientPlan(),
      );

      expect(outcome.consultedModules, [AssistantModuleCapability.searchClient]);
      expect(outcome.results.single.result?.found, isTrue);
      expect(outcome.results.single.result?.displayName, 'João Pereira');
      expect(
        outcome.results.single.dataSource,
        AssistantModuleDataSource.inMemory,
      );
      expect(outcome.results.single.result?.isErpData, isFalse);
      expect(outcome.unavailableModules, isEmpty);
    });

    test('capability true without gateway → unavailable', () {
      final consultant = AssistantModuleConsultant(
        capabilities: AssistantCapabilities.localReadIntegration(),
      );

      final outcome = consultant.consult(
        response: clientResponse(),
        plan: clientPlan(),
      );

      expect(outcome.results, isEmpty);
      expect(
        outcome.unavailableModules,
        contains(AssistantModuleCapability.searchClient),
      );
      expect(
        outcome.plan.steps.single.status,
        AssistantExecutionStatus.unavailable,
      );
    });

    test('gateway present with capability false → unavailable', () {
      final consultant = AssistantModuleConsultant(
        capabilities: AssistantCapabilities.localDefaults(),
        gateway: clientGateway(),
      );

      final outcome = consultant.consult(
        response: clientResponse(),
        plan: clientPlan(),
      );

      expect(outcome.results, isEmpty);
      expect(
        outcome.unavailableModules,
        contains(AssistantModuleCapability.searchClient),
      );
    });

    test('gateway registered for another module → unavailable', () {
      final consultant = AssistantModuleConsultant(
        capabilities: AssistantCapabilities.localReadIntegration(),
        gateway: LocalAssistantGateway(
          agenda: InMemoryAgendaGateway(),
        ),
      );

      final outcome = consultant.consult(
        response: clientResponse(),
        plan: clientPlan(),
      );

      expect(outcome.results, isEmpty);
      expect(
        outcome.unavailableModules,
        contains(AssistantModuleCapability.searchClient),
      );
    });

    test('invalid request returns structured error without adapter hit', () {
      var calls = 0;
      final consultant = AssistantModuleConsultant(
        capabilities: AssistantCapabilities.localReadIntegration(),
        gateway: LocalAssistantGateway(
          clients: _CountingClientGateway(() => calls++),
        ),
      );

      final outcome = consultant.consult(
        response: clientResponse(clientName: null),
        plan: clientPlan(), // ready but no name → invalid before call
      );

      // Step with empty name is typically blocked by planner; when forced ready:
      expect(calls, 0);
      expect(outcome.results.single.error?.code, 'invalid_request');
      expect(
        outcome.results.single.availability,
        AssistantModuleAvailability.error,
      );
    });

    test('adapter exception becomes AssistantModuleError', () {
      final consultant = AssistantModuleConsultant(
        capabilities: AssistantCapabilities.localReadIntegration(),
        gateway: LocalAssistantGateway(clients: _ThrowingClientGateway()),
      );

      final outcome = consultant.consult(
        response: clientResponse(),
        plan: clientPlan(),
      );

      expect(
        outcome.results.single.availability,
        AssistantModuleAvailability.error,
      );
      expect(outcome.results.single.error, isNotNull);
      expect(outcome.warnings, isNotEmpty);
    });

    test('adapter structured miss still consulted with inMemory source', () {
      final consultant = AssistantModuleConsultant(
        capabilities: AssistantCapabilities.localReadIntegration(),
        gateway: LocalAssistantGateway(
          clients: InMemoryClientGateway(
            seed: const [
              InMemoryClientRecord(identifier: 'x', displayName: 'Maria'),
            ],
          ),
        ),
      );

      final outcome = consultant.consult(
        response: clientResponse(clientName: 'João'),
        plan: clientPlan(),
      );

      expect(outcome.consultedModules, [AssistantModuleCapability.searchClient]);
      expect(outcome.results.single.result?.found, isFalse);
      expect(
        outcome.results.single.dataSource,
        AssistantModuleDataSource.inMemory,
      );
    });

    test('localDefaults never consults adapters', () {
      var calls = 0;
      final consultant = AssistantModuleConsultant(
        capabilities: AssistantCapabilities.localDefaults(),
        gateway: LocalAssistantGateway(
          clients: _CountingClientGateway(() => calls++),
        ),
      );

      consultant.consult(response: clientResponse(), plan: clientPlan());
      expect(calls, 0);
      expect(
        AssistantCapabilities.localDefaults().integrationMode,
        AssistantIntegrationMode.none,
      );
    });

    test('consultation is deterministic and does not mutate drafts', () {
      const draft = AssistantEventDraft(clientName: 'João');
      final base = AssistantResponse(
        requestId: 'req-1',
        rawText: 'Procure o cliente João',
        primaryIntent: AssistantIntent(
          type: AssistantIntentType.searchClient,
          confidence: AssistantConfidence.fromScore(0.9),
        ),
        overallConfidence: AssistantConfidence.fromScore(0.9),
        friendlyMessage: 'msg',
        eventDraft: draft,
      );
      final consultant = AssistantModuleConsultant(
        capabilities: AssistantCapabilities.localReadIntegration(),
        gateway: clientGateway(),
      );

      final a = consultant.consult(response: base, plan: clientPlan());
      final b = consultant.consult(response: base, plan: clientPlan());
      expect(a.results, b.results);
      expect(identical(base.eventDraft, draft), isTrue);
      expect(base.eventDraft?.clientName, 'João');
      expect(
        AssistantCapabilities.localReadIntegration().canExecuteCreateEvent,
        isFalse,
      );
    });

    test('read integration profile never enables writes', () {
      final caps = AssistantCapabilities.localReadIntegration();
      expect(caps.integrationMode, AssistantIntegrationMode.inMemory);
      expect(caps.canExecuteClientSearch, isTrue);
      expect(caps.canExecuteCreateEvent, isFalse);
      expect(caps.canExecuteCreateQuote, isFalse);
      expect(caps.canPlanLookupQuote, isFalse);
      expect(caps.canExecuteLookupQuote, isFalse);
      expect(caps.claimsErpIntegration, isFalse);
    });

    test('failure in one module does not drop another success', () {
      final plan = AssistantExecutionPlan(
        id: 'plan-multi',
        requestId: 'req-1',
        overallStatus: AssistantExecutionStatus.ready,
        steps: const [
          AssistantExecutionStep(
            id: 'step-search-client',
            order: 1,
            moduleTarget: AssistantModuleTarget.clients,
            intendedAction: 'searchClient',
            description: 'Buscar Cliente',
            status: AssistantExecutionStatus.ready,
          ),
          AssistantExecutionStep(
            id: 'step-check-availability',
            order: 2,
            moduleTarget: AssistantModuleTarget.agenda,
            intendedAction: 'checkAvailability',
            description: 'Consultar Disponibilidade',
            status: AssistantExecutionStatus.ready,
          ),
        ],
      );
      final response = AssistantResponse(
        requestId: 'req-1',
        rawText: 'texto',
        primaryIntent: AssistantIntent(
          type: AssistantIntentType.searchClient,
          confidence: AssistantConfidence.fromScore(0.9),
        ),
        overallConfidence: AssistantConfidence.fromScore(0.9),
        friendlyMessage: 'msg',
        eventDraft: AssistantEventDraft(
          clientName: 'João',
          date: DateTime(2026, 9, 18),
        ),
      );
      final consultant = AssistantModuleConsultant(
        capabilities: AssistantCapabilities.localReadIntegration(),
        gateway: LocalAssistantGateway(
          clients: InMemoryClientGateway(
            seed: const [
              InMemoryClientRecord(
                identifier: 'cli-joao',
                displayName: 'João Pereira',
              ),
            ],
          ),
          agenda: _ThrowingAgendaGateway(),
        ),
      );

      final outcome = consultant.consult(response: response, plan: plan);
      expect(
        outcome.results.any(
          (r) =>
              r.capability == AssistantModuleCapability.searchClient &&
              r.result?.found == true,
        ),
        isTrue,
      );
      expect(
        outcome.results.any(
          (r) =>
              r.capability == AssistantModuleCapability.checkAvailability &&
              r.error != null,
        ),
        isTrue,
      );
    });
  });
}

class _ThrowingClientGateway implements ClientGateway {
  @override
  AssistantModuleResponse searchClient(AssistantModuleRequest request) {
    throw StateError('simulated adapter crash');
  }
}

class _CountingClientGateway implements ClientGateway {
  _CountingClientGateway(this.onCall);

  final void Function() onCall;

  @override
  AssistantModuleResponse searchClient(AssistantModuleRequest request) {
    onCall();
    return InMemoryClientGateway().searchClient(request);
  }
}

class _ThrowingAgendaGateway extends InMemoryAgendaGateway {
  @override
  AssistantModuleResponse checkAvailability(AssistantModuleRequest request) {
    throw StateError('agenda boom');
  }
}
