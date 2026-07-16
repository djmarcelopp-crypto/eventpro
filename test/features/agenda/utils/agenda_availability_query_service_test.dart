import 'package:eventpro/features/agenda/models/agenda_availability_result.dart';
import 'package:eventpro/features/agenda/models/agenda_occupancy.dart';
import 'package:eventpro/features/agenda/models/agenda_query.dart';
import 'package:eventpro/features/agenda/utils/agenda_availability_query_service.dart';
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

void main() {
  group('AgendaQuery — construção do intervalo de dias', () {
    test('day resolve um único dia', () {
      final query = AgendaQuery.day(DateTime(2026, 8, 15, 13, 0));

      expect(query.days, [DateTime(2026, 8, 15)]);
    });

    test('dateRange resolve dias inclusivos entre start e end', () {
      final query = AgendaQuery.dateRange(
        start: DateTime(2026, 8, 15),
        end: DateTime(2026, 8, 17),
      );

      expect(query.days, [
        DateTime(2026, 8, 15),
        DateTime(2026, 8, 16),
        DateTime(2026, 8, 17),
      ]);
    });

    test('dateRange com end anterior a start lança ArgumentError', () {
      expect(
        () => AgendaQuery.dateRange(
          start: DateTime(2026, 8, 17),
          end: DateTime(2026, 8, 15),
        ),
        throwsArgumentError,
      );
    });

    test('week resolve de segunda a domingo contendo a data', () {
      // 2026-08-19 é uma quarta-feira.
      final query = AgendaQuery.week(DateTime(2026, 8, 19));

      expect(query.days, hasLength(7));
      expect(query.days.first, DateTime(2026, 8, 17)); // segunda
      expect(query.days.last, DateTime(2026, 8, 23)); // domingo
    });

    test('month resolve todos os dias do mês contendo a data', () {
      final query = AgendaQuery.month(DateTime(2026, 2, 10));

      expect(query.days, hasLength(28));
      expect(query.days.first, DateTime(2026, 2, 1));
      expect(query.days.last, DateTime(2026, 2, 28));
    });

    test('month lida corretamente com dezembro', () {
      final query = AgendaQuery.month(DateTime(2026, 12, 5));

      expect(query.days, hasLength(31));
      expect(query.days.last, DateTime(2026, 12, 31));
    });
  });

  group('AgendaAvailabilityQueryService — consulta diária', () {
    test('um único dia livre retorna availability free e um resultado diário', () {
      final result = AgendaAvailabilityQueryService.run(
        query: AgendaQuery.day(DateTime(2026, 8, 15)),
        occupancies: const [],
      );

      expect(result.availability, AgendaAvailabilityStatus.free);
      expect(result.dailyResults, hasLength(1));
      expect(result.dailyResults.single.date, DateTime(2026, 8, 15));
      expect(result.dailyResults.single.status, AgendaAvailabilityStatus.free);
      expect(result.summary.freeDays, 1);
      expect(result.summary.partialDays, 0);
      expect(result.summary.busyDays, 0);
      expect(result.periodStart, DateTime(2026, 8, 15));
      expect(result.periodEnd, DateTime(2026, 8, 16));
    });
  });

  group('AgendaAvailabilityQueryService — intervalo personalizado', () {
    test('intervalo de 3 dias com uma ocupação em apenas um dia', () {
      final result = AgendaAvailabilityQueryService.run(
        query: AgendaQuery.dateRange(
          start: DateTime(2026, 8, 15),
          end: DateTime(2026, 8, 17),
        ),
        occupancies: [
          _occupancy(
            id: 'block-16',
            start: DateTime(2026, 8, 16, 8, 0),
            end: DateTime(2026, 8, 16, 20, 0),
          ),
        ],
      );

      expect(result.dailyResults, hasLength(3));
      expect(result.dailyResults[0].status, AgendaAvailabilityStatus.free);
      expect(result.dailyResults[1].status, AgendaAvailabilityStatus.partial);
      expect(result.dailyResults[2].status, AgendaAvailabilityStatus.free);
      expect(result.availability, AgendaAvailabilityStatus.partial);
      expect(result.summary.freeDays, 2);
      expect(result.summary.partialDays, 1);
      expect(result.summary.busyDays, 0);
    });
  });

  group('AgendaAvailabilityQueryService — consulta semanal', () {
    test(
      'semana com 4 dias livres, 2 parciais e 1 ocupado resume corretamente',
      () {
        final monday = DateTime(2026, 8, 17);

        final result = AgendaAvailabilityQueryService.run(
          query: AgendaQuery.week(monday),
          occupancies: [
            // Terça (18) — parcial.
            _occupancy(
              id: 'tuesday',
              start: DateTime(2026, 8, 18, 8, 0),
              end: DateTime(2026, 8, 18, 12, 0),
            ),
            // Quarta (19) — ocupado o dia inteiro.
            _occupancy(
              id: 'wednesday',
              start: DateTime(2026, 8, 19),
              end: DateTime(2026, 8, 20),
            ),
            // Quinta (20) — parcial.
            _occupancy(
              id: 'thursday',
              start: DateTime(2026, 8, 20, 18, 0),
              end: DateTime(2026, 8, 20, 23, 0),
            ),
          ],
        );

        expect(result.dailyResults, hasLength(7));
        expect(result.summary.freeDays, 4);
        expect(result.summary.partialDays, 2);
        expect(result.summary.busyDays, 1);
        expect(result.availability, AgendaAvailabilityStatus.partial);

        expect(
          result.dailyResults.map((d) => d.date).toList(),
          List.generate(7, (i) => monday.add(Duration(days: i))),
        );
      },
    );
  });

  group('AgendaAvailabilityQueryService — consulta mensal', () {
    test('mês inteiro sem ocupações retorna availability free', () {
      final result = AgendaAvailabilityQueryService.run(
        query: AgendaQuery.month(DateTime(2026, 8, 1)),
        occupancies: const [],
      );

      expect(result.dailyResults, hasLength(31));
      expect(result.availability, AgendaAvailabilityStatus.free);
      expect(result.summary.freeDays, 31);
    });
  });

  group('AgendaAvailabilityQueryService — período vazio', () {
    test('sem ocupações, todos os dias são livres', () {
      final result = AgendaAvailabilityQueryService.run(
        query: AgendaQuery.dateRange(
          start: DateTime(2026, 8, 15),
          end: DateTime(2026, 8, 19),
        ),
        occupancies: const [],
      );

      expect(result.availability, AgendaAvailabilityStatus.free);
      expect(result.summary.freeDays, 5);
      expect(result.conflicts, isEmpty);
    });
  });

  group('AgendaAvailabilityQueryService — período totalmente ocupado', () {
    test('ocupação cobrindo todos os dias do período retorna busy', () {
      final result = AgendaAvailabilityQueryService.run(
        query: AgendaQuery.dateRange(
          start: DateTime(2026, 8, 15),
          end: DateTime(2026, 8, 17),
        ),
        occupancies: [
          _occupancy(
            id: 'long-event',
            start: DateTime(2026, 8, 15),
            end: DateTime(2026, 8, 18),
          ),
        ],
      );

      expect(result.availability, AgendaAvailabilityStatus.busy);
      expect(result.summary.busyDays, 3);
      expect(result.summary.freeDays, 0);
      expect(result.summary.partialDays, 0);
    });
  });

  group(
    'AgendaAvailabilityQueryService — período parcialmente ocupado',
    () {
      test('mistura de dias livres, parciais e ocupados retorna partial', () {
        final result = AgendaAvailabilityQueryService.run(
          query: AgendaQuery.dateRange(
            start: DateTime(2026, 8, 15),
            end: DateTime(2026, 8, 16),
          ),
          occupancies: [
            _occupancy(
              id: 'evening',
              start: DateTime(2026, 8, 15, 20, 0),
              end: DateTime(2026, 8, 15, 22, 0),
            ),
          ],
        );

        expect(result.availability, AgendaAvailabilityStatus.partial);
        expect(result.summary.freeDays, 1);
        expect(result.summary.partialDays, 1);
      });
    },
  );

  group('AgendaAvailabilityQueryService — ordenação cronológica', () {
    test('dailyResults segue a ordem cronológica dos dias consultados', () {
      final result = AgendaAvailabilityQueryService.run(
        query: AgendaQuery.dateRange(
          start: DateTime(2026, 8, 15),
          end: DateTime(2026, 8, 20),
        ),
        occupancies: const [],
      );

      final dates = result.dailyResults.map((d) => d.date).toList();
      for (var i = 1; i < dates.length; i++) {
        expect(dates[i].isAfter(dates[i - 1]), isTrue);
      }
    });
  });

  group('AgendaAvailabilityQueryService — conflitos agregados', () {
    test(
      'conflito que se estende por vários dias é reportado uma única vez',
      () {
        final first = _occupancy(
          id: 'first',
          start: DateTime(2026, 8, 15, 8, 0),
          end: DateTime(2026, 8, 17, 8, 0),
        );
        final second = _occupancy(
          id: 'second',
          start: DateTime(2026, 8, 16, 8, 0),
          end: DateTime(2026, 8, 18, 8, 0),
        );

        final result = AgendaAvailabilityQueryService.run(
          query: AgendaQuery.dateRange(
            start: DateTime(2026, 8, 15),
            end: DateTime(2026, 8, 18),
          ),
          occupancies: [first, second],
        );

        expect(result.conflicts, hasLength(1));
        expect(result.conflicts.single.first.id, 'first');
        expect(result.conflicts.single.second.id, 'second');
      },
    );

    test('conflitos distintos em dias diferentes são todos reportados', () {
      final blockA1 = _occupancy(
        id: 'a1',
        start: DateTime(2026, 8, 15, 8, 0),
        end: DateTime(2026, 8, 15, 12, 0),
      );
      final blockA2 = _occupancy(
        id: 'a2',
        start: DateTime(2026, 8, 15, 10, 0),
        end: DateTime(2026, 8, 15, 14, 0),
      );
      final blockB1 = _occupancy(
        id: 'b1',
        start: DateTime(2026, 8, 16, 8, 0),
        end: DateTime(2026, 8, 16, 12, 0),
      );
      final blockB2 = _occupancy(
        id: 'b2',
        start: DateTime(2026, 8, 16, 10, 0),
        end: DateTime(2026, 8, 16, 14, 0),
      );

      final result = AgendaAvailabilityQueryService.run(
        query: AgendaQuery.dateRange(
          start: DateTime(2026, 8, 15),
          end: DateTime(2026, 8, 16),
        ),
        occupancies: [blockA1, blockA2, blockB1, blockB2],
      );

      expect(result.conflicts, hasLength(2));
    });

    test('sem sobreposição entre ocupações não há conflitos agregados', () {
      final result = AgendaAvailabilityQueryService.run(
        query: AgendaQuery.dateRange(
          start: DateTime(2026, 8, 15),
          end: DateTime(2026, 8, 16),
        ),
        occupancies: [
          _occupancy(
            id: 'morning',
            start: DateTime(2026, 8, 15, 8, 0),
            end: DateTime(2026, 8, 15, 10, 0),
          ),
          _occupancy(
            id: 'evening',
            start: DateTime(2026, 8, 16, 18, 0),
            end: DateTime(2026, 8, 16, 20, 0),
          ),
        ],
      );

      expect(result.conflicts, isEmpty);
    });
  });
}
