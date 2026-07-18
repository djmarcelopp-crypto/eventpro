import 'package:eventpro/features/assistant/models/assistant_entity.dart';
import 'package:eventpro/features/assistant/models/assistant_entity_type.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_intent_type.dart';
import 'package:eventpro/features/assistant/models/assistant_parse_result.dart';
import 'package:eventpro/features/assistant/models/assistant_provenance.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/local_assistant_intent_classifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalAssistantIntentClassifier', () {
    final classifier = LocalAssistantIntentClassifier();
    final now = DateTime(2026, 7, 18);

    AssistantRequest req(String text) => AssistantRequest(
          id: 'r1',
          rawText: text,
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.pastedText,
        );

    test('classifies availability schedule client and update intents', () {
      expect(
        classifier
            .classify(
              request: req('Tem equipamento disponível dia 18?'),
              parseResult: const AssistantParseResult(entities: []),
            )
            .first
            .type,
        AssistantIntentType.checkAvailability,
      );
      expect(
        classifier
            .classify(
              request: req('Como está minha agenda no sábado?'),
              parseResult: const AssistantParseResult(entities: []),
            )
            .first
            .type,
        AssistantIntentType.checkSchedule,
      );
      expect(
        classifier
            .classify(
              request: req('Procure o cliente João'),
              parseResult: const AssistantParseResult(entities: []),
            )
            .first
            .type,
        AssistantIntentType.searchClient,
      );
      expect(
        classifier
            .classify(
              request: req('Altere o horário do evento da Maria'),
              parseResult: const AssistantParseResult(entities: []),
            )
            .first
            .type,
        AssistantIntentType.updateEvent,
      );
    });

    test('quote cue beats implicit createEvent', () {
      final intents = classifier.classify(
        request: req('Quero um orçamento para casamento'),
        parseResult: const AssistantParseResult(
          entities: [
            AssistantEntity(
              type: AssistantEntityType.eventType,
              rawValue: 'casamento',
              provenance: AssistantProvenance.extracted,
            ),
          ],
        ),
      );
      expect(intents.first.type, AssistantIntentType.createQuote);
    });

    test('implicit event description yields createQuote with alternative', () {
      final intents = classifier.classify(
        request: req('Casamento para 300 pessoas com som'),
        parseResult: const AssistantParseResult(
          entities: [
            AssistantEntity(
              type: AssistantEntityType.eventType,
              rawValue: 'casamento',
              provenance: AssistantProvenance.extracted,
            ),
            AssistantEntity(
              type: AssistantEntityType.service,
              rawValue: 'som',
              provenance: AssistantProvenance.extracted,
            ),
          ],
        ),
      );
      expect(intents.first.type, AssistantIntentType.createQuote);
      expect(
        intents.any((i) => i.type == AssistantIntentType.createEvent),
        isTrue,
      );
    });

    test('irrelevant text becomes unknown', () {
      final intents = classifier.classify(
        request: req('Bom dia, tudo bem?'),
        parseResult: const AssistantParseResult(entities: []),
      );
      expect(intents.first.type, AssistantIntentType.unknown);
    });
  });
}
