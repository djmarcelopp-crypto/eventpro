import 'package:eventpro/features/agenda/models/agenda_availability_response.dart';
import 'package:eventpro/features/agenda/models/agenda_occupancy.dart';
import 'package:eventpro/features/agenda/utils/agenda_availability_assistant_service.dart';
import 'package:eventpro/features/agenda/utils/agenda_availability_request_parser.dart';
import 'package:flutter_test/flutter_test.dart';

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

AgendaAvailabilityAssistantService assistantAt(DateTime now) {
  return AgendaAvailabilityAssistantService(
    parser: AgendaAvailabilityRequestParser(clock: () => now),
  );
}

void main() {
  group('AgendaAvailabilityAssistantService — dia livre', () {
    test('"Tenho agenda hoje?" sem ocupações responde que está livre', () {
      final service = assistantAt(DateTime(2026, 8, 20));
      final response = service.ask(phrase: 'Tenho agenda hoje?', occupancies: const []);

      expect(response.kind, AgendaAvailabilityResponseKind.success);
      expect(response.message, 'Sua agenda está livre em 20/08/2026.');
    });
  });

  group('AgendaAvailabilityAssistantService — dia parcial', () {
    test('uma ocupação parcial responde parcialmente ocupada e detalha a contagem', () {
      final service = assistantAt(DateTime(2026, 1, 1));
      final response = service.ask(
        phrase: 'Tenho evento no dia 20/08/2026?',
        occupancies: [
          _occupancy(
            id: 'block-1',
            start: DateTime(2026, 8, 20, 8, 0),
            end: DateTime(2026, 8, 20, 12, 0),
          ),
        ],
      );

      expect(
        response.message,
        'Sua agenda está parcialmente ocupada em 20/08/2026. '
        'Existe 1 ocupação.',
      );
    });
  });

  group('AgendaAvailabilityAssistantService — dia ocupado', () {
    test('ocupação cobrindo o dia inteiro responde totalmente ocupada', () {
      final service = assistantAt(DateTime(2026, 1, 1));
      final response = service.ask(
        phrase: 'Tenho evento no dia 20/08/2026?',
        occupancies: [
          _occupancy(
            id: 'block-1',
            start: DateTime(2026, 8, 20),
            end: DateTime(2026, 8, 21),
          ),
        ],
      );

      expect(
        response.message,
        'Sua agenda está totalmente ocupada em 20/08/2026. '
        'Existe 1 ocupação.',
      );
    });
  });

  group('AgendaAvailabilityAssistantService — conflitos', () {
    test('duas ocupações sobrepostas geram a frase de conflito no plural', () {
      final service = assistantAt(DateTime(2026, 1, 1));
      final response = service.ask(
        phrase: 'Tenho evento no dia 20/08/2026?',
        occupancies: [
          _occupancy(
            id: 'block-1',
            start: DateTime(2026, 8, 20, 8, 0),
            end: DateTime(2026, 8, 20, 14, 0),
          ),
          _occupancy(
            id: 'block-2',
            start: DateTime(2026, 8, 20, 10, 0),
            end: DateTime(2026, 8, 20, 16, 0),
          ),
        ],
      );

      expect(
        response.message,
        'Sua agenda está parcialmente ocupada em 20/08/2026. '
        'Existem 2 ocupações e 1 conflito.',
      );
    });
  });

  group('AgendaAvailabilityAssistantService — semana', () {
    test('semana com dias livres, parciais e ocupados resume corretamente', () {
      final monday = DateTime(2026, 8, 17);
      final service = assistantAt(monday);

      final response = service.ask(
        phrase: 'Quais dias desta semana estão livres?',
        occupancies: [
          _occupancy(
            id: 'tuesday',
            start: DateTime(2026, 8, 18, 8, 0),
            end: DateTime(2026, 8, 18, 12, 0),
          ),
          _occupancy(
            id: 'wednesday',
            start: DateTime(2026, 8, 19),
            end: DateTime(2026, 8, 20),
          ),
          _occupancy(
            id: 'thursday',
            start: DateTime(2026, 8, 20, 18, 0),
            end: DateTime(2026, 8, 20, 23, 0),
          ),
        ],
      );

      expect(
        response.message,
        'Nesta semana: 4 dias livres, 2 parcialmente ocupados e 1 ocupado.',
      );
    });

    test('"próxima semana" usa o rótulo correto', () {
      final service = assistantAt(DateTime(2026, 8, 17));
      final response = service.ask(
        phrase: 'Como está a próxima semana?',
        occupancies: const [],
      );

      expect(response.message, 'Na próxima semana: 7 dias livres.');
    });
  });

  group('AgendaAvailabilityAssistantService — mês', () {
    test('mês atual sem ocupações', () {
      final service = assistantAt(DateTime(2026, 8, 1));
      final response = service.ask(
        phrase: 'Como está o mês atual?',
        occupancies: const [],
      );

      expect(response.message, 'Neste mês: 31 dias livres.');
    });

    test('mês nomeado usa o nome do mês por extenso', () {
      final service = assistantAt(DateTime(2026, 1, 1));
      final response = service.ask(
        phrase: 'Como está o mês de agosto?',
        occupancies: const [],
      );

      expect(response.message, 'Em agosto: 31 dias livres.');
    });
  });

  group('AgendaAvailabilityAssistantService — intervalo personalizado', () {
    test('intervalo de datas usa o rótulo de período', () {
      final service = assistantAt(DateTime(2026, 1, 1));
      final response = service.ask(
        phrase: 'Quais dias estão livres entre 20/08/2026 e 22/08/2026?',
        occupancies: [
          _occupancy(
            id: 'block-1',
            start: DateTime(2026, 8, 21),
            end: DateTime(2026, 8, 22),
          ),
        ],
      );

      expect(
        response.message,
        'No período de 20/08/2026 a 22/08/2026: 2 dias livres e 1 ocupado.',
      );
    });
  });

  group('AgendaAvailabilityAssistantService — datas e horários formatados', () {
    test('intervalo de horário formata dia e horas corretamente', () {
      final service = assistantAt(DateTime(2026, 1, 1));
      final response = service.ask(
        phrase: 'Tenho horário entre 14h e 18h no dia 05/09/2026?',
        occupancies: const [],
      );

      expect(
        response.message,
        'Sua agenda está livre entre 14:00 e 18:00 em 05/09/2026.',
      );
    });

    test('data de um único dígito é formatada com zero à esquerda', () {
      final service = assistantAt(DateTime(2026, 1, 1));
      final response = service.ask(
        phrase: 'Tenho evento no dia 05/01/2026?',
        occupancies: const [],
      );

      expect(response.message, 'Sua agenda está livre em 05/01/2026.');
    });
  });

  group('AgendaAvailabilityAssistantService — frase ambígua', () {
    test('retorna resposta de erro pedindo reformulação', () {
      final service = assistantAt(DateTime(2026, 8, 15));
      final response = service.ask(
        phrase: 'Tenho agenda hoje ou amanhã?',
        occupancies: const [],
      );

      expect(response.kind, AgendaAvailabilityResponseKind.ambiguous);
      expect(response.isError, isTrue);
      expect(response.message, contains('reformular'));
    });
  });

  group('AgendaAvailabilityAssistantService — frase não suportada', () {
    test('retorna resposta de erro explicando o que é suportado', () {
      final service = assistantAt(DateTime(2026, 8, 15));
      final response = service.ask(
        phrase: 'Qual é a previsão do tempo?',
        occupancies: const [],
      );

      expect(response.kind, AgendaAvailabilityResponseKind.unsupported);
      expect(response.isError, isTrue);
      expect(response.message, isNotEmpty);
    });
  });
}
