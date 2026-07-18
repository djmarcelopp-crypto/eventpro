import 'package:eventpro/features/assistant/models/assistant_entity_type.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_parse_issue_type.dart';
import 'package:eventpro/features/assistant/models/assistant_provenance.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/parsers/local_assistant_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalAssistantParser', () {
    final now = DateTime(2026, 7, 18, 10);
    late LocalAssistantParser parser;

    setUp(() {
      parser = LocalAssistantParser(clock: () => now);
    });

    AssistantRequest request(String text) {
      return AssistantRequest(
        id: 'r1',
        rawText: text,
        locale: 'pt_BR',
        timezone: 'America/Sao_Paulo',
        timestamp: now,
        origin: AssistantInputOrigin.typedText,
      );
    }

    test('extracts event type guests city and services from short text', () {
      final result = parser.parse(
        request(
          'Preciso de som e iluminação para um casamento de 300 pessoas em Uberlândia.',
        ),
      );

      expect(
        result.entities.any((e) => e.type == AssistantEntityType.eventType),
        isTrue,
      );
      expect(
        result.entities.any(
          (e) =>
              e.type == AssistantEntityType.guestCount &&
              e.normalizedValue == '300',
        ),
        isTrue,
      );
      expect(
        result.entities.any((e) => e.type == AssistantEntityType.city),
        isTrue,
      );
      expect(
        result.entities.any((e) => e.type == AssistantEntityType.service),
        isTrue,
      );
      expect(
        result.issues.any(
          (i) =>
              i.type == AssistantParseIssueType.missing &&
              i.entityType == AssistantEntityType.date,
        ),
        isTrue,
      );
    });

    test('parses absolute and relative dates with injectable clock', () {
      final absolute = parser.parse(request('Evento em 18/09/2026'));
      expect(
        absolute.entities.any((e) => e.normalizedValue == '2026-09-18'),
        isTrue,
      );

      final relative = parser.parse(request('Evento amanhã'));
      expect(
        relative.entities.any((e) => e.normalizedValue == '2026-07-19'),
        isTrue,
      );

      final short = parser.parse(request('Festa dia 10/01'));
      final date = short.entities.firstWhere(
        (e) => e.type == AssistantEntityType.date,
      );
      expect(date.normalizedValue, '2027-01-10');
      expect(date.provenance, AssistantProvenance.inferred);
    });

    test('parses time ranges and guest thousand separators', () {
      final result = parser.parse(
        request('Show das 18h às 23h para aproximadamente 1.000 pessoas'),
      );
      expect(
        result.entities.any(
          (e) =>
              e.type == AssistantEntityType.startTime &&
              e.normalizedValue == '18:00',
        ),
        isTrue,
      );
      expect(
        result.entities.any(
          (e) =>
              e.type == AssistantEntityType.endTime &&
              e.normalizedValue == '23:00',
        ),
        isTrue,
      );
      expect(
        result.entities.any(
          (e) =>
              e.type == AssistantEntityType.guestCount &&
              e.normalizedValue == '1000',
        ),
        isTrue,
      );
    });

    test('flags ambiguous guest ranges and conflicting dates', () {
      final range = parser.parse(
        request('Casamento entre 200 e 300 pessoas'),
      );
      expect(
        range.issues.any((i) => i.type == AssistantParseIssueType.ambiguous),
        isTrue,
      );

      final conflict = parser.parse(
        request('Evento em 18/09/2026 e também em 20/09/2026'),
      );
      expect(
        conflict.issues.any(
          (i) => i.type == AssistantParseIssueType.conflicting,
        ),
        isTrue,
      );
    });

    test('handles accents case and long text', () {
      final result = parser.parse(
        request(
          'PRECISO DE ILUMINAÇÃO E PAINEL DE LED PARA UMA FORMATURA '
          'NO CENTER CONVENTION COM CERCA DE 80 CONVIDADOS.',
        ),
      );
      expect(
        result.entities.any((e) => e.type == AssistantEntityType.eventType),
        isTrue,
      );
      expect(
        result.entities.any((e) => e.type == AssistantEntityType.equipment),
        isTrue,
      );
      expect(
        result.entities.any(
          (e) =>
              e.type == AssistantEntityType.guestCount &&
              e.normalizedValue == '80',
        ),
        isTrue,
      );
    });
  });
}
