import 'package:eventpro/features/agenda/models/agenda_availability_response.dart';
import 'package:eventpro/features/agenda/models/agenda_occupancy.dart';
import 'package:eventpro/features/agenda/utils/agenda_availability_assistant_service.dart';
import 'package:eventpro/features/agenda/utils/agenda_availability_request_parser.dart';
import 'package:flutter_test/flutter_test.dart';

/// CP-F hardening: exercises the full deterministic pipeline
/// (frase → parser → analyzer/query service → formatter) end-to-end,
/// through `AgendaAvailabilityAssistantService.ask`, without touching
/// Flutter/Riverpod/persistence. Complements the unit tests already
/// covering each stage in isolation (CP-A/B/C/D) with scenarios that only
/// make sense when the whole chain runs together: relative dates against
/// an injected clock, month/year rollover, midnight-crossing occupancies,
/// determinism and absence of side effects.
AgendaOccupancy _occupancy({
  required String id,
  required DateTime start,
  required DateTime end,
}) {
  return AgendaOccupancy(
    id: id,
    kind: AgendaOccupancyKind.block,
    title: 'Ocupação $id',
    start: start,
    end: end,
    sourceBlockId: id,
  );
}

AgendaAvailabilityAssistantService _assistantAt(DateTime now) {
  return AgendaAvailabilityAssistantService(
    parser: AgendaAvailabilityRequestParser(clock: () => now),
  );
}

void main() {
  group('Fluxo completo — datas relativas com relógio injetável', () {
    test('"amanhã" na virada do ano avança para o dia 1º de janeiro seguinte', () {
      final service = _assistantAt(DateTime(2026, 12, 31));
      final response = service.ask(
        phrase: 'Tenho agenda amanhã?',
        occupancies: const [],
      );

      expect(response.message, 'Sua agenda está livre em 01/01/2027.');
    });

    test('"hoje" reflete exatamente a data do relógio injetado', () {
      final service = _assistantAt(DateTime(2026, 2, 28));
      final response = service.ask(
        phrase: 'Tenho agenda hoje?',
        occupancies: const [],
      );

      expect(response.message, 'Sua agenda está livre em 28/02/2026.');
    });
  });

  group('Fluxo completo — virada de mês e de ano', () {
    test('"próxima semana" na virada do ano resume o período corretamente', () {
      final service = _assistantAt(DateTime(2026, 12, 28));
      final response = service.ask(
        phrase: 'Como está a próxima semana?',
        occupancies: const [],
      );

      expect(response.message, 'Na próxima semana: 7 dias livres.');
    });

    test(
      'mês nomeado sem ano sempre resolve para o ano do relógio injetado '
      '(regra aprovada em CP-C)',
      () {
        final serviceIn2026 = _assistantAt(DateTime(2026, 1, 1));
        final responseIn2026 = serviceIn2026.ask(
          phrase: 'Como está o mês de dezembro?',
          occupancies: const [],
        );
        expect(responseIn2026.message, 'Em dezembro: 31 dias livres.');

        final serviceIn2030 = _assistantAt(DateTime(2030, 1, 1));
        final responseIn2030 = serviceIn2030.ask(
          phrase: 'Como está o mês de dezembro?',
          occupancies: const [],
        );
        expect(responseIn2030.message, 'Em dezembro: 31 dias livres.');
      },
    );
  });

  group('Fluxo completo — intervalos atravessando a meia-noite', () {
    test(
      'ocupação atravessando a meia-noite é parcial no dia anterior e no '
      'dia seguinte',
      () {
        final service = _assistantAt(DateTime(2026, 1, 1));
        final overnight = _occupancy(
          id: 'overnight',
          start: DateTime(2026, 8, 20, 22, 0),
          end: DateTime(2026, 8, 21, 2, 0),
        );

        final dayOne = service.ask(
          phrase: 'Tenho evento no dia 20/08/2026?',
          occupancies: [overnight],
        );
        expect(
          dayOne.message,
          'Sua agenda está parcialmente ocupada em 20/08/2026. '
          'Existe 1 ocupação.',
        );

        final dayTwo = service.ask(
          phrase: 'Tenho evento no dia 21/08/2026?',
          occupancies: [overnight],
        );
        expect(
          dayTwo.message,
          'Sua agenda está parcialmente ocupada em 21/08/2026. '
          'Existe 1 ocupação.',
        );
      },
    );

    test(
      'semana com ocupação atravessando a meia-noite conta 1 dia parcial '
      'em cada lado da virada',
      () {
        final monday = DateTime(2026, 8, 17);
        final service = _assistantAt(monday);
        final overnight = _occupancy(
          id: 'overnight',
          start: DateTime(2026, 8, 19, 22, 0),
          end: DateTime(2026, 8, 20, 2, 0),
        );

        final response = service.ask(
          phrase: 'Quais dias desta semana estão livres?',
          occupancies: [overnight],
        );

        expect(
          response.message,
          'Nesta semana: 5 dias livres e 2 parcialmente ocupados.',
        );
      },
    );
  });

  group('Fluxo completo — conflitos e pluralização', () {
    test('conflito único usa singular e conflito múltiplo usa plural', () {
      final service = _assistantAt(DateTime(2026, 1, 1));

      final single = service.ask(
        phrase: 'Tenho evento no dia 20/08/2026?',
        occupancies: [
          _occupancy(
            id: 'a',
            start: DateTime(2026, 8, 20, 8, 0),
            end: DateTime(2026, 8, 20, 12, 0),
          ),
          _occupancy(
            id: 'b',
            start: DateTime(2026, 8, 20, 10, 0),
            end: DateTime(2026, 8, 20, 14, 0),
          ),
        ],
      );
      expect(single.message, contains('1 conflito.'));

      final multiple = service.ask(
        phrase: 'Tenho evento no dia 20/08/2026?',
        occupancies: [
          _occupancy(
            id: 'a',
            start: DateTime(2026, 8, 20, 8, 0),
            end: DateTime(2026, 8, 20, 12, 0),
          ),
          _occupancy(
            id: 'b',
            start: DateTime(2026, 8, 20, 10, 0),
            end: DateTime(2026, 8, 20, 14, 0),
          ),
          _occupancy(
            id: 'c',
            start: DateTime(2026, 8, 20, 11, 0),
            end: DateTime(2026, 8, 20, 15, 0),
          ),
        ],
      );
      expect(multiple.message, contains('conflitos.'));
    });
  });

  group('Fluxo completo — frases ambíguas e não suportadas', () {
    test('frase ambígua não expõe nenhum dado de disponibilidade', () {
      final service = _assistantAt(DateTime(2026, 8, 17));
      final response = service.ask(
        phrase: 'Tenho agenda hoje ou amanhã?',
        occupancies: const [],
      );

      expect(response.kind, AgendaAvailabilityResponseKind.ambiguous);
      expect(response.isError, isTrue);
      expect(response.message, isNot(contains('Sua agenda está')));
      expect(response.message, isNot(matches(RegExp(r'\d{2}/\d{2}/\d{4}'))));
    });

    test('frase não suportada não expõe nenhum dado de disponibilidade', () {
      final service = _assistantAt(DateTime(2026, 8, 17));
      final response = service.ask(
        phrase: 'Qual é a previsão do tempo?',
        occupancies: const [],
      );

      expect(response.kind, AgendaAvailabilityResponseKind.unsupported);
      expect(response.isError, isTrue);
      expect(response.message, isNot(contains('Sua agenda está')));
      expect(response.message, isNot(matches(RegExp(r'\d{2}/\d{2}/\d{4}'))));
    });
  });

  group('Fluxo completo — determinismo e ausência de efeitos colaterais', () {
    test('duas execuções idênticas produzem exatamente a mesma resposta', () {
      final service = _assistantAt(DateTime(2026, 8, 17));
      final occupancies = [
        _occupancy(
          id: 'a',
          start: DateTime(2026, 8, 18, 9, 0),
          end: DateTime(2026, 8, 18, 11, 0),
        ),
      ];

      final first = service.ask(
        phrase: 'Como está minha agenda no dia 18/08/2026?',
        occupancies: occupancies,
      );
      final second = service.ask(
        phrase: 'Como está minha agenda no dia 18/08/2026?',
        occupancies: occupancies,
      );

      expect(first.message, second.message);
      expect(first.kind, second.kind);
    });

    test('a consulta não altera a lista de ocupações recebida', () {
      final service = _assistantAt(DateTime(2026, 8, 17));
      final original = [
        _occupancy(
          id: 'a',
          start: DateTime(2026, 8, 18, 9, 0),
          end: DateTime(2026, 8, 18, 11, 0),
        ),
      ];
      final idsBefore = original.map((o) => o.id).toList();
      final startsBefore = original.map((o) => o.start).toList();
      final endsBefore = original.map((o) => o.end).toList();

      service.ask(
        phrase: 'Como está minha agenda no dia 18/08/2026?',
        occupancies: original,
      );
      service.ask(
        phrase: 'Quais dias desta semana estão livres?',
        occupancies: original,
      );

      expect(original.map((o) => o.id).toList(), idsBefore);
      expect(original.map((o) => o.start).toList(), startsBefore);
      expect(original.map((o) => o.end).toList(), endsBefore);
    });
  });
}
