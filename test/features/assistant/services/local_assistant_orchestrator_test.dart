import 'package:eventpro/features/assistant/adapters/in_memory_client_gateway.dart';
import 'package:eventpro/features/assistant/adapters/local_assistant_gateway.dart';
import 'package:eventpro/features/assistant/models/assistant_action_type.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_status.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_intent_type.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_module_capability.dart';
import 'package:eventpro/features/assistant/models/assistant_module_data_source.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalAssistantOrchestrator', () {
    final now = DateTime(2026, 7, 18, 12);
    late LocalAssistantOrchestrator orchestrator;

    setUp(() {
      orchestrator = LocalAssistantOrchestrator(clock: () => now);
    });

    test('builds structured response without creating ERP records', () {
      final response = orchestrator.handle(
        AssistantRequest(
          id: 'req-demo',
          rawText:
              'Preciso de som e iluminação para um casamento de 300 pessoas em Uberlândia.',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );

      expect(response.rawText, contains('casamento'));
      expect(response.primaryIntent.type, AssistantIntentType.createQuote);
      expect(response.eventDraft?.eventType, 'casamento');
      expect(response.eventDraft?.guestCount, 300);
      expect(response.eventDraft?.city, isNotNull);
      expect(response.quoteDraft?.serviceKeywords, contains('som'));
      expect(response.questions, isNotEmpty);
      expect(
        response.questions.any((q) => q.prompt.contains('data')),
        isTrue,
      );
      expect(
        response.actions.any(
          (a) =>
              a.type == AssistantActionType.reviewDraft && a.available == true,
        ),
        isTrue,
      );
      expect(
        response.actions.any(
          (a) =>
              a.type == AssistantActionType.createQuote &&
              a.available == false &&
              a.blockedReason != null,
        ),
        isTrue,
      );
      expect(response.friendlyMessage, contains('Não criei nenhum registro'));
      expect(
        response.friendlyMessage,
        contains(
          'ainda faltam informações antes que qualquer operação possa ser realizada',
        ),
      );
      expect(response.executionReport, isNotNull);
      expect(response.executionMode, AssistantExecutionMode.dryRun);
      expect(
        response.friendlyMessage,
        contains('Nenhuma alteração foi realizada no EventPRO'),
      );
    });

    test('attaches blocked execution plan and next recommended action', () {
      final response = orchestrator.handle(
        AssistantRequest(
          id: 'req-plan',
          rawText: 'Preciso de um casamento para 300 pessoas em Uberlândia.',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );

      expect(response.executionPlan, isNotNull);
      expect(response.executionPlan!.steps, hasLength(3));
      expect(response.blockedSteps, hasLength(3));
      expect(response.readySteps, isEmpty);
      expect(response.executionPlan!.hasExecutableReadySteps, isFalse);
      expect(response.requiredConfirmations, isNotEmpty);
      expect(response.warnings, isNotEmpty);
      expect(
        response.executionPlan!.overallStatus,
        AssistantExecutionStatus.blocked,
      );
      expect(
        response.nextRecommendedAction?.type,
        AssistantActionType.askQuestion,
      );
      expect(
        response.warnings.any(
          (w) => w.message.contains(
            'ainda faltam informações antes que qualquer operação possa ser realizada',
          ),
        ),
        isTrue,
      );
    });

    test('keeps original text and explainable confidence', () {
      const text = 'Tem equipamento disponível dia 18/09/2026?';
      final response = orchestrator.handle(
        AssistantRequest(
          id: 'req-2',
          rawText: text,
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.pastedText,
        ),
      );

      expect(response.rawText, text);
      expect(response.primaryIntent.type, AssistantIntentType.checkAvailability);
      expect(response.overallConfidence.score, greaterThan(0));
      expect(response.overallConfidence.evidences, isNotEmpty);
      expect(response.executionPlan, isNotNull);
      expect(response.readySteps, isEmpty);
      expect(
        response.executionPlan!.steps.single.status,
        AssistantExecutionStatus.unavailable,
      );
    });

    test('final response is immutable via copyWith attachment of plan', () {
      final response = orchestrator.handle(
        AssistantRequest(
          id: 'req-immut',
          rawText: 'Criar evento corporativo em Goiânia',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );
      final mutated = response.copyWith(friendlyMessage: 'outro');
      expect(identical(response, mutated), isFalse);
      expect(response.friendlyMessage, isNot(mutated.friendlyMessage));
      expect(response.executionPlan, isNotNull);
      expect(mutated.executionPlan, response.executionPlan);
      expect(response.readySteps, isEmpty);
    });

    test('read gateway enriches searchClient without mutating ERP data', () {
      final wired = LocalAssistantOrchestrator(
        clock: () => now,
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
        ),
      );

      final response = wired.handle(
        AssistantRequest(
          id: 'req-client',
          rawText: 'Procure o cliente João',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );

      expect(response.primaryIntent.type, AssistantIntentType.searchClient);
      expect(
        response.consultedModules,
        contains(AssistantModuleCapability.searchClient),
      );
      expect(response.moduleResults, isNotEmpty);
      expect(response.moduleResults.single.result?.found, isTrue);
      expect(response.moduleResults.single.result?.displayName, 'João Pereira');
      expect(
        response.moduleResults.single.dataSource,
        AssistantModuleDataSource.inMemory,
      );
      expect(response.hasOnlySimulatedModuleData, isTrue);
      expect(response.moduleDataSources, [AssistantModuleDataSource.inMemory]);
      expect(response.friendlyMessage, contains('Cliente encontrado'));
      expect(
        response.friendlyMessage,
        contains('Nenhuma alteração foi realizada no EventPRO'),
      );
      expect(response.executionReport, isNotNull);
      expect(response.executionAudit, isNotNull);
      expect(response.eventDraft?.clientName, 'João');
      expect(wired.capabilities.canExecuteCreateEvent, isFalse);
      expect(wired.capabilities.canExecuteCreateQuote, isFalse);
      expect(
        response.executionPlan?.steps
            .where((s) => s.intendedAction.startsWith('create'))
            .every((s) => !s.isReady),
        isTrue,
      );
    });

    test('without read capability keeps module unavailable', () {
      final response = orchestrator.handle(
        AssistantRequest(
          id: 'req-client-default',
          rawText: 'Procure o cliente João',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );

      expect(response.primaryIntent.type, AssistantIntentType.searchClient);
      expect(response.moduleResults, isEmpty);
      expect(
        response.unavailableModules,
        contains(AssistantModuleCapability.searchClient),
      );
      expect(response.integrationWarnings, isNotEmpty);
    });
  });
}
