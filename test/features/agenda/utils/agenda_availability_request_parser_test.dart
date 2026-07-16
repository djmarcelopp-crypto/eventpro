import 'package:eventpro/features/agenda/models/agenda_availability_intent.dart';
import 'package:eventpro/features/agenda/models/agenda_availability_request.dart';
import 'package:eventpro/features/agenda/utils/agenda_availability_request_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AgendaAvailabilityRequestParser parserAt(DateTime now) {
    return AgendaAvailabilityRequestParser(clock: () => now);
  }

  group('AgendaAvailabilityRequestParser — hoje e amanhã', () {
    test('"Tenho agenda hoje?" resolve para o dia atual', () {
      final parser = parserAt(DateTime(2026, 8, 15, 10, 30));
      final result = parser.parse('Tenho agenda hoje?');

      expect(result.isSuccess, isTrue);
      expect(result.request!.intent, AgendaAvailabilityIntent.today);
      expect(result.request!.query.days, [DateTime(2026, 8, 15)]);
    });

    test('"Como está minha agenda amanhã?" resolve para o dia seguinte', () {
      final parser = parserAt(DateTime(2026, 8, 15, 10, 30));
      final result = parser.parse('Como está minha agenda amanhã?');

      expect(result.isSuccess, isTrue);
      expect(result.request!.intent, AgendaAvailabilityIntent.tomorrow);
      expect(result.request!.query.days, [DateTime(2026, 8, 16)]);
    });
  });

  group('AgendaAvailabilityRequestParser — sábado desta semana', () {
    test('"Tenho disponibilidade sábado?" resolve o sábado da semana atual', () {
      // 2026-08-19 é uma quarta-feira; o sábado desta semana é 2026-08-22.
      final parser = parserAt(DateTime(2026, 8, 19));
      final result = parser.parse('Tenho disponibilidade sábado?');

      expect(result.isSuccess, isTrue);
      expect(result.request!.intent, AgendaAvailabilityIntent.specificDay);
      expect(result.request!.query.days, [DateTime(2026, 8, 22)]);
    });

    test(
      'resolve corretamente mesmo quando o dia da semana consultado já '
      'passou nesta semana',
      () {
        // 2026-08-22 é um sábado; consultar "segunda" deve voltar para o
        // início desta mesma semana (2026-08-17), não para a próxima.
        final parser = parserAt(DateTime(2026, 8, 22));
        final result = parser.parse('Tenho disponibilidade segunda?');

        expect(result.request!.query.days, [DateTime(2026, 8, 17)]);
      },
    );
  });

  group('AgendaAvailabilityRequestParser — semana atual e próxima', () {
    test('"Quais dias desta semana estão livres?" resolve a semana atual', () {
      final parser = parserAt(DateTime(2026, 8, 19));
      final result = parser.parse('Quais dias desta semana estão livres?');

      expect(result.isSuccess, isTrue);
      expect(result.request!.intent, AgendaAvailabilityIntent.currentWeek);
      expect(result.request!.query.rangeStart, DateTime(2026, 8, 17));
      expect(result.request!.query.rangeEnd, DateTime(2026, 8, 23));
    });

    test('"Como está a próxima semana?" resolve a semana seguinte', () {
      final parser = parserAt(DateTime(2026, 8, 19));
      final result = parser.parse('Como está a próxima semana?');

      expect(result.isSuccess, isTrue);
      expect(result.request!.intent, AgendaAvailabilityIntent.nextWeek);
      expect(result.request!.query.rangeStart, DateTime(2026, 8, 24));
      expect(result.request!.query.rangeEnd, DateTime(2026, 8, 30));
    });
  });

  group('AgendaAvailabilityRequestParser — mês atual e mês nomeado', () {
    test('"Como está o mês atual?" resolve o mês corrente', () {
      final parser = parserAt(DateTime(2026, 8, 19));
      final result = parser.parse('Como está o mês atual?');

      expect(result.isSuccess, isTrue);
      expect(result.request!.intent, AgendaAvailabilityIntent.currentMonth);
      expect(result.request!.query.rangeStart, DateTime(2026, 8, 1));
      expect(result.request!.query.rangeEnd, DateTime(2026, 8, 31));
    });

    test('"Como está o mês de agosto?" resolve o mês nomeado no ano de referência', () {
      final parser = parserAt(DateTime(2026, 3, 1));
      final result = parser.parse('Como está o mês de agosto?');

      expect(result.isSuccess, isTrue);
      expect(result.request!.intent, AgendaAvailabilityIntent.namedMonth);
      expect(result.request!.query.rangeStart, DateTime(2026, 8, 1));
      expect(result.request!.query.rangeEnd, DateTime(2026, 8, 31));
    });

    test(
      'mês nomeado usa sempre o ano de referência, mesmo que o mês já '
      'tenha passado',
      () {
        final parser = parserAt(DateTime(2026, 12, 1));
        final result = parser.parse('Como está o mês de janeiro?');

        expect(result.request!.query.rangeStart, DateTime(2026, 1, 1));
        expect(result.request!.query.rangeEnd, DateTime(2026, 1, 31));
      },
    );
  });

  group('AgendaAvailabilityRequestParser — data em dd/MM/yyyy', () {
    test('"Tenho evento no dia 20/08/2026?" resolve a data explícita', () {
      final parser = parserAt(DateTime(2026, 1, 1));
      final result = parser.parse('Tenho evento no dia 20/08/2026?');

      expect(result.isSuccess, isTrue);
      expect(result.request!.intent, AgendaAvailabilityIntent.specificDay);
      expect(result.request!.query.days, [DateTime(2026, 8, 20)]);
    });
  });

  group('AgendaAvailabilityRequestParser — intervalo de datas', () {
    test(
      '"Quais dias estão livres entre 20/08/2026 e 25/08/2026?" resolve o '
      'intervalo',
      () {
        final parser = parserAt(DateTime(2026, 1, 1));
        final result = parser.parse(
          'Quais dias estão livres entre 20/08/2026 e 25/08/2026?',
        );

        expect(result.isSuccess, isTrue);
        expect(result.request!.intent, AgendaAvailabilityIntent.dateRange);
        expect(result.request!.query.rangeStart, DateTime(2026, 8, 20));
        expect(result.request!.query.rangeEnd, DateTime(2026, 8, 25));
      },
    );

    test('funciona mesmo quando as datas aparecem fora de ordem na frase', () {
      final parser = parserAt(DateTime(2026, 1, 1));
      final result = parser.parse(
        'Quais dias entre 25/08/2026 e 20/08/2026 estão livres?',
      );

      expect(result.request!.query.rangeStart, DateTime(2026, 8, 20));
      expect(result.request!.query.rangeEnd, DateTime(2026, 8, 25));
    });
  });

  group('AgendaAvailabilityRequestParser — intervalo de horários', () {
    test(
      '"Tenho horário entre 14h e 18h no dia 20/08/2026?" resolve dia e '
      'horário',
      () {
        final parser = parserAt(DateTime(2026, 1, 1));
        final result = parser.parse(
          'Tenho horário entre 14h e 18h no dia 20/08/2026?',
        );

        expect(result.isSuccess, isTrue);
        expect(result.request!.intent, AgendaAvailabilityIntent.timeRange);
        expect(result.request!.query.days, [DateTime(2026, 8, 20)]);
        expect(result.request!.periodStart, DateTime(2026, 8, 20, 14, 0));
        expect(result.request!.periodEnd, DateTime(2026, 8, 20, 18, 0));
      },
    );

    test('suporta minutos explícitos no horário ("14h30")', () {
      final parser = parserAt(DateTime(2026, 1, 1));
      final result = parser.parse(
        'Tenho horário entre 14h30 e 18h45 no dia 20/08/2026?',
      );

      expect(result.request!.periodStart, DateTime(2026, 8, 20, 14, 30));
      expect(result.request!.periodEnd, DateTime(2026, 8, 20, 18, 45));
    });

    test('horário final antes do inicial retorna erro ambíguo', () {
      final parser = parserAt(DateTime(2026, 1, 1));
      final result = parser.parse(
        'Tenho horário entre 18h e 14h no dia 20/08/2026?',
      );

      expect(result.isSuccess, isFalse);
      expect(result.error!.kind, AgendaAvailabilityParseErrorKind.ambiguous);
    });

    test('intervalo de horário sem dia associado retorna erro não suportado', () {
      final parser = parserAt(DateTime(2026, 1, 1));
      final result = parser.parse('Tenho horário entre 14h e 18h?');

      expect(result.isSuccess, isFalse);
      expect(
        result.error!.kind,
        AgendaAvailabilityParseErrorKind.unsupported,
      );
    });
  });

  group('AgendaAvailabilityRequestParser — frase ambígua', () {
    test('"Tenho agenda hoje ou amanhã?" retorna erro de ambiguidade', () {
      final parser = parserAt(DateTime(2026, 8, 15));
      final result = parser.parse('Tenho agenda hoje ou amanhã?');

      expect(result.isSuccess, isFalse);
      expect(result.error!.kind, AgendaAvailabilityParseErrorKind.ambiguous);
    });

    test('menção a hoje e a um dia da semana ao mesmo tempo é ambígua', () {
      final parser = parserAt(DateTime(2026, 8, 15));
      final result = parser.parse('Tenho agenda hoje ou sábado?');

      expect(result.isSuccess, isFalse);
      expect(result.error!.kind, AgendaAvailabilityParseErrorKind.ambiguous);
    });
  });

  group('AgendaAvailabilityRequestParser — frase não suportada', () {
    test('frase sem nenhuma referência de agenda retorna erro não suportado', () {
      final parser = parserAt(DateTime(2026, 8, 15));
      final result = parser.parse('Qual é a previsão do tempo?');

      expect(result.isSuccess, isFalse);
      expect(
        result.error!.kind,
        AgendaAvailabilityParseErrorKind.unsupported,
      );
    });

    test('pergunta totalmente fora do domínio da Agenda', () {
      final parser = parserAt(DateTime(2026, 8, 15));
      final result = parser.parse('Qual o total de vendas do último trimestre?');

      expect(result.isSuccess, isFalse);
      expect(
        result.error!.kind,
        AgendaAvailabilityParseErrorKind.unsupported,
      );
    });
  });

  group('AgendaAvailabilityRequestParser — virada de mês e ano', () {
    test('"amanhã" cruza o fim do ano corretamente', () {
      final parser = parserAt(DateTime(2026, 12, 31, 23, 0));
      final result = parser.parse('Tenho agenda amanhã?');

      expect(result.isSuccess, isTrue);
      expect(result.request!.query.days, [DateTime(2027, 1, 1)]);
    });

    test('intervalo de datas cruzando virada de mês e ano', () {
      final parser = parserAt(DateTime(2026, 1, 1));
      final result = parser.parse(
        'Quais dias estão livres entre 28/12/2026 e 03/01/2027?',
      );

      expect(result.isSuccess, isTrue);
      expect(result.request!.query.rangeStart, DateTime(2026, 12, 28));
      expect(result.request!.query.rangeEnd, DateTime(2027, 1, 3));
      expect(result.request!.query.days, hasLength(7));
    });

    test('"próxima semana" cruzando a virada do ano', () {
      // 2026-12-28 é uma segunda-feira.
      final parser = parserAt(DateTime(2026, 12, 28));
      final result = parser.parse('Como está a próxima semana?');

      expect(result.isSuccess, isTrue);
      expect(result.request!.query.rangeStart, DateTime(2027, 1, 4));
      expect(result.request!.query.rangeEnd, DateTime(2027, 1, 10));
    });
  });

  group('AgendaAvailabilityRequestParser — relógio injetável', () {
    test('usa DateTime.now por padrão quando nenhum clock é informado', () {
      final parser = AgendaAvailabilityRequestParser();
      final result = parser.parse('Tenho agenda hoje?');

      expect(result.isSuccess, isTrue);
      final today = DateTime.now();
      expect(
        result.request!.query.days.single,
        DateTime(today.year, today.month, today.day),
      );
    });
  });
}
