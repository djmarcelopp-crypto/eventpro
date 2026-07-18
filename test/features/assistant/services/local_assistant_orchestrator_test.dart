import 'package:eventpro/features/assistant/models/assistant_action_type.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_intent_type.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
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
    });
  });
}
