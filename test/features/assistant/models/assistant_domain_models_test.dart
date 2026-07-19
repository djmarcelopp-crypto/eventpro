import 'package:eventpro/features/assistant/models/assistant_action.dart';
import 'package:eventpro/features/assistant/models/assistant_action_type.dart';
import 'package:eventpro/features/assistant/models/assistant_confidence.dart';
import 'package:eventpro/features/assistant/models/assistant_confidence_level.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_entity.dart';
import 'package:eventpro/features/assistant/models/assistant_entity_type.dart';
import 'package:eventpro/features/assistant/models/assistant_event_draft.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_intent.dart';
import 'package:eventpro/features/assistant/models/assistant_intent_type.dart';
import 'package:eventpro/features/assistant/models/assistant_provenance.dart';
import 'package:eventpro/features/assistant/models/assistant_quote_draft.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/models/assistant_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Assistant domain models', () {
    final now = DateTime(2026, 7, 18, 12);

    test('AssistantConfidence.fromScore maps deterministic bands', () {
      expect(
        AssistantConfidence.fromScore(0.9).level,
        AssistantConfidenceLevel.high,
      );
      expect(
        AssistantConfidence.fromScore(0.5).level,
        AssistantConfidenceLevel.medium,
      );
      expect(
        AssistantConfidence.fromScore(0.2).level,
        AssistantConfidenceLevel.low,
      );
      expect(AssistantConfidence.fromScore(2).score, 1.0);
      expect(AssistantConfidence.fromScore(-1).score, 0.0);
    });

    test('AssistantRequest is immutable with equality and copyWith', () {
      final request = AssistantRequest(
        id: 'req-1',
        rawText: 'Casamento em Uberlândia',
        locale: 'pt_BR',
        timezone: 'America/Campo_Grande',
        timestamp: now,
        origin: AssistantInputOrigin.typedText,
        context: const AssistantContext(sessionId: 's1'),
      );

      final copy = request.copyWith(rawText: 'Outro texto');
      expect(copy.rawText, 'Outro texto');
      expect(copy.id, request.id);
      expect(request == copy, isFalse);
      expect(
        request,
        AssistantRequest(
          id: 'req-1',
          rawText: 'Casamento em Uberlândia',
          locale: 'pt_BR',
          timezone: 'America/Campo_Grande',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
          context: const AssistantContext(sessionId: 's1'),
        ),
      );
    });

    test('AssistantEntity and drafts support provenance', () {
      final entity = AssistantEntity(
        type: AssistantEntityType.city,
        rawValue: 'Uberlândia',
        normalizedValue: 'Uberlândia',
        provenance: AssistantProvenance.extracted,
        confidence: AssistantConfidence.fromScore(0.9, evidences: ['em X']),
      );
      expect(entity.copyWith(rawValue: 'Goiânia').rawValue, 'Goiânia');

      const eventDraft = AssistantEventDraft(
        eventType: 'casamento',
        guestCount: 300,
        city: 'Uberlândia',
        fieldProvenance: {
          'eventType': AssistantProvenance.extracted,
          'guestCount': AssistantProvenance.extracted,
          'city': AssistantProvenance.extracted,
        },
      );
      expect(eventDraft.hasEssentialGaps, isTrue);

      const quoteDraft = AssistantQuoteDraft(
        serviceKeywords: ['som', 'iluminação'],
      );
      expect(quoteDraft.isEmpty, isFalse);
    });

    test('AssistantResponse aggregates intents actions and drafts', () {
      final intent = AssistantIntent(
        type: AssistantIntentType.createQuote,
        confidence: AssistantConfidence.fromScore(0.8),
        evidences: const ['orçamento implícito'],
      );
      final response = AssistantResponse(
        requestId: 'req-1',
        rawText: 'texto',
        primaryIntent: intent,
        overallConfidence: AssistantConfidence.fromScore(0.7),
        friendlyMessage: 'Entendi um possível orçamento.',
        actions: const [
          AssistantAction(
            type: AssistantActionType.reviewDraft,
            available: true,
            label: 'Revisar rascunho',
          ),
          AssistantAction(
            type: AssistantActionType.createQuote,
            available: false,
            label: 'Criar orçamento',
            blockedReason: 'Data ausente',
          ),
        ],
      );

      expect(response.actions.where((a) => a.available), hasLength(1));
      expect(response.executionPlan, isNull);
      expect(response.blockedSteps, isEmpty);
      expect(
        response.copyWith(friendlyMessage: 'ok').friendlyMessage,
        'ok',
      );
    });

    test('input origin and intent enums expose multimodal-ready values', () {
      expect(AssistantInputOrigin.values, contains(AssistantInputOrigin.audioTranscript));
      expect(AssistantInputOrigin.values, contains(AssistantInputOrigin.whatsappConversation));
      expect(AssistantIntentType.values, contains(AssistantIntentType.checkAvailability));
      expect(AssistantIntentType.values, contains(AssistantIntentType.unknown));
    });
  });
}
