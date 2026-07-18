import 'package:eventpro/features/agenda/models/agenda_availability_result.dart';
import 'package:eventpro/features/agenda/models/agenda_occupancy.dart';
import 'package:eventpro/features/agenda/utils/agenda_availability_analyzer.dart';
import 'package:flutter_test/flutter_test.dart';

AgendaOccupancy _occupancy({
  required String id,
  DateTime? start,
  DateTime? end,
  AgendaOccupancyKind kind = AgendaOccupancyKind.block,
}) {
  return AgendaOccupancy(
    id: id,
    kind: kind,
    title: 'Ocupação $id',
    start: start ?? DateTime(2026, 8, 15, 8, 0),
    end: end ?? DateTime(2026, 8, 15, 12, 0),
    sourceBlockId: kind == AgendaOccupancyKind.block ? id : null,
    sourceQuoteId: kind == AgendaOccupancyKind.block ? null : id,
  );
}

void main() {
  final saturday = DateTime(2026, 8, 15);
  final sunday = DateTime(2026, 8, 16);
  final dayStart = DateTime(2026, 8, 15);
  final dayEnd = DateTime(2026, 8, 16);

  group('AgendaAvailabilityAnalyzer — agenda livre', () {
    test('sem ocupações retorna free e o dia inteiro como intervalo livre', () {
      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        occupancies: const [],
      );

      expect(result.status, AgendaAvailabilityStatus.free);
      expect(result.occupancies, isEmpty);
      expect(result.conflicts, isEmpty);
      expect(result.freeIntervals, [
        isA<AgendaFreeInterval>()
            .having((i) => i.start, 'start', dayStart)
            .having((i) => i.end, 'end', dayEnd),
      ]);
      expect(result.reason, isNotEmpty);
    });

    test('ocupações fora da data consultada são ignoradas', () {
      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        occupancies: [
          _occupancy(
            id: 'other-day',
            start: DateTime(2026, 8, 20, 8, 0),
            end: DateTime(2026, 8, 20, 10, 0),
          ),
        ],
      );

      expect(result.status, AgendaAvailabilityStatus.free);
      expect(result.occupancies, isEmpty);
    });
  });

  group('AgendaAvailabilityAnalyzer — agenda totalmente ocupada', () {
    test('uma única ocupação cobrindo o dia inteiro retorna busy', () {
      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        occupancies: [
          _occupancy(id: 'full-day', start: dayStart, end: dayEnd),
        ],
      );

      expect(result.status, AgendaAvailabilityStatus.busy);
      expect(result.freeIntervals, isEmpty);
      expect(result.occupancies, hasLength(1));
    });

    test(
      'múltiplas ocupações adjacentes cobrindo o dia inteiro retornam busy '
      'sem intervalo livre artificial na borda',
      () {
        final result = AgendaAvailabilityAnalyzer.analyze(
          date: saturday,
          occupancies: [
            _occupancy(
              id: 'morning',
              start: dayStart,
              end: DateTime(2026, 8, 15, 12, 0),
            ),
            _occupancy(
              id: 'afternoon',
              start: DateTime(2026, 8, 15, 12, 0),
              end: dayEnd,
            ),
          ],
        );

        expect(result.status, AgendaAvailabilityStatus.busy);
        expect(result.freeIntervals, isEmpty);
      },
    );
  });

  group('AgendaAvailabilityAnalyzer — agenda parcialmente ocupada', () {
    test('uma ocupação cobrindo parte do dia retorna partial', () {
      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        occupancies: [
          _occupancy(
            id: 'morning',
            start: DateTime(2026, 8, 15, 8, 0),
            end: DateTime(2026, 8, 15, 12, 0),
          ),
        ],
      );

      expect(result.status, AgendaAvailabilityStatus.partial);
      expect(result.freeIntervals, [
        isA<AgendaFreeInterval>()
            .having((i) => i.start, 'start', dayStart)
            .having((i) => i.end, 'end', DateTime(2026, 8, 15, 8, 0)),
        isA<AgendaFreeInterval>()
            .having((i) => i.start, 'start', DateTime(2026, 8, 15, 12, 0))
            .having((i) => i.end, 'end', dayEnd),
      ]);
    });

    test('múltiplas ocupações espalhadas geram múltiplos intervalos livres', () {
      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        occupancies: [
          _occupancy(
            id: 'morning',
            start: DateTime(2026, 8, 15, 8, 0),
            end: DateTime(2026, 8, 15, 10, 0),
          ),
          _occupancy(
            id: 'afternoon',
            start: DateTime(2026, 8, 15, 14, 0),
            end: DateTime(2026, 8, 15, 16, 0),
          ),
          _occupancy(
            id: 'evening',
            start: DateTime(2026, 8, 15, 20, 0),
            end: DateTime(2026, 8, 15, 22, 0),
          ),
        ],
      );

      expect(result.status, AgendaAvailabilityStatus.partial);
      expect(result.occupancies, hasLength(3));
      expect(result.freeIntervals, hasLength(4));
      expect(result.freeIntervals[0].start, dayStart);
      expect(result.freeIntervals[0].end, DateTime(2026, 8, 15, 8, 0));
      expect(result.freeIntervals.last.end, dayEnd);
    });
  });

  group('AgendaAvailabilityAnalyzer — ordenação', () {
    test('occupancies do resultado são ordenadas por início independente '
        'da ordem de entrada', () {
      final late = _occupancy(
        id: 'late',
        start: DateTime(2026, 8, 15, 20, 0),
        end: DateTime(2026, 8, 15, 22, 0),
      );
      final early = _occupancy(
        id: 'early',
        start: DateTime(2026, 8, 15, 8, 0),
        end: DateTime(2026, 8, 15, 10, 0),
      );
      final middle = _occupancy(
        id: 'middle',
        start: DateTime(2026, 8, 15, 14, 0),
        end: DateTime(2026, 8, 15, 16, 0),
      );

      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        occupancies: [late, middle, early],
      );

      expect(
        result.occupancies.map((o) => o.id).toList(),
        ['early', 'middle', 'late'],
      );
    });
  });

  group('AgendaAvailabilityAnalyzer — conflitos entre ocupações', () {
    test('duas ocupações sobrepostas geram um conflito', () {
      final first = _occupancy(
        id: 'first',
        start: DateTime(2026, 8, 15, 8, 0),
        end: DateTime(2026, 8, 15, 12, 0),
      );
      final second = _occupancy(
        id: 'second',
        start: DateTime(2026, 8, 15, 10, 0),
        end: DateTime(2026, 8, 15, 14, 0),
      );

      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        occupancies: [first, second],
      );

      expect(result.conflicts, hasLength(1));
      expect(result.conflicts.single.first.id, 'first');
      expect(result.conflicts.single.second.id, 'second');
    });

    test('ocupações que apenas tocam na borda não geram conflito', () {
      final first = _occupancy(
        id: 'first',
        start: DateTime(2026, 8, 15, 8, 0),
        end: DateTime(2026, 8, 15, 12, 0),
      );
      final second = _occupancy(
        id: 'second',
        start: DateTime(2026, 8, 15, 12, 0),
        end: DateTime(2026, 8, 15, 16, 0),
      );

      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        occupancies: [first, second],
      );

      expect(result.conflicts, isEmpty);
    });

    test('três ocupações sobrepostas entre si geram três pares de conflito', () {
      final a = _occupancy(
        id: 'a',
        start: DateTime(2026, 8, 15, 8, 0),
        end: DateTime(2026, 8, 15, 12, 0),
      );
      final b = _occupancy(
        id: 'b',
        start: DateTime(2026, 8, 15, 9, 0),
        end: DateTime(2026, 8, 15, 13, 0),
      );
      final c = _occupancy(
        id: 'c',
        start: DateTime(2026, 8, 15, 10, 0),
        end: DateTime(2026, 8, 15, 14, 0),
      );

      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        occupancies: [a, b, c],
      );

      expect(result.conflicts, hasLength(3));
    });

    test('sem sobreposição entre ocupações não há conflito', () {
      final morning = _occupancy(
        id: 'morning',
        start: DateTime(2026, 8, 15, 8, 0),
        end: DateTime(2026, 8, 15, 10, 0),
      );
      final evening = _occupancy(
        id: 'evening',
        start: DateTime(2026, 8, 15, 18, 0),
        end: DateTime(2026, 8, 15, 20, 0),
      );

      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        occupancies: [morning, evening],
      );

      expect(result.conflicts, isEmpty);
    });
  });

  group('AgendaAvailabilityAnalyzer — consulta por intervalo específico', () {
    test('busy quando a ocupação cobre exatamente o intervalo consultado', () {
      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        periodStart: DateTime(2026, 8, 15, 18, 0),
        periodEnd: DateTime(2026, 8, 15, 22, 0),
        occupancies: [
          _occupancy(
            id: 'event',
            start: DateTime(2026, 8, 15, 18, 0),
            end: DateTime(2026, 8, 15, 22, 0),
          ),
        ],
      );

      expect(result.status, AgendaAvailabilityStatus.busy);
    });

    test(
      'ocupação fora do intervalo consultado (mas na mesma data) é ignorada',
      () {
        final result = AgendaAvailabilityAnalyzer.analyze(
          date: saturday,
          periodStart: DateTime(2026, 8, 15, 18, 0),
          periodEnd: DateTime(2026, 8, 15, 22, 0),
          occupancies: [
            _occupancy(
              id: 'morning',
              start: DateTime(2026, 8, 15, 8, 0),
              end: DateTime(2026, 8, 15, 10, 0),
            ),
          ],
        );

        expect(result.status, AgendaAvailabilityStatus.free);
        expect(result.occupancies, isEmpty);
      },
    );

    test(
      'ocupação parcialmente dentro do intervalo é recortada nos intervalos '
      'livres, mas mantém start/end originais em occupancies',
      () {
        final occupancy = _occupancy(
          id: 'overlap-start',
          start: DateTime(2026, 8, 15, 16, 0),
          end: DateTime(2026, 8, 15, 19, 0),
        );

        final result = AgendaAvailabilityAnalyzer.analyze(
          date: saturday,
          periodStart: DateTime(2026, 8, 15, 18, 0),
          periodEnd: DateTime(2026, 8, 15, 22, 0),
          occupancies: [occupancy],
        );

        expect(result.status, AgendaAvailabilityStatus.partial);
        expect(result.occupancies.single.start, DateTime(2026, 8, 15, 16, 0));
        expect(result.occupancies.single.end, DateTime(2026, 8, 15, 19, 0));
        expect(result.freeIntervals, [
          isA<AgendaFreeInterval>()
              .having((i) => i.start, 'start', DateTime(2026, 8, 15, 19, 0))
              .having((i) => i.end, 'end', DateTime(2026, 8, 15, 22, 0)),
        ]);
      },
    );

    test('exige periodStart e periodEnd juntos ou nenhum dos dois', () {
      expect(
        () => AgendaAvailabilityAnalyzer.analyze(
          date: saturday,
          periodStart: DateTime(2026, 8, 15, 18, 0),
          occupancies: const [],
        ),
        throwsArgumentError,
      );
    });

    test('exige que periodEnd seja posterior a periodStart', () {
      expect(
        () => AgendaAvailabilityAnalyzer.analyze(
          date: saturday,
          periodStart: DateTime(2026, 8, 15, 22, 0),
          periodEnd: DateTime(2026, 8, 15, 18, 0),
          occupancies: const [],
        ),
        throwsArgumentError,
      );
    });
  });

  group('AgendaAvailabilityAnalyzer — horários nas bordas', () {
    test('ocupação que termina exatamente no início do período consultado '
        'não é considerada relevante', () {
      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        periodStart: DateTime(2026, 8, 15, 18, 0),
        periodEnd: DateTime(2026, 8, 15, 22, 0),
        occupancies: [
          _occupancy(
            id: 'before',
            start: DateTime(2026, 8, 15, 14, 0),
            end: DateTime(2026, 8, 15, 18, 0),
          ),
        ],
      );

      expect(result.status, AgendaAvailabilityStatus.free);
      expect(result.occupancies, isEmpty);
    });

    test('ocupação que começa exatamente no fim do período consultado '
        'não é considerada relevante', () {
      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        periodStart: DateTime(2026, 8, 15, 18, 0),
        periodEnd: DateTime(2026, 8, 15, 22, 0),
        occupancies: [
          _occupancy(
            id: 'after',
            start: DateTime(2026, 8, 15, 22, 0),
            end: DateTime(2026, 8, 15, 23, 0),
          ),
        ],
      );

      expect(result.status, AgendaAvailabilityStatus.free);
      expect(result.occupancies, isEmpty);
    });

    test('ocupação que toca exatamente o início do período é considerada '
        'relevante e cobre desde o início', () {
      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        periodStart: DateTime(2026, 8, 15, 18, 0),
        periodEnd: DateTime(2026, 8, 15, 22, 0),
        occupancies: [
          _occupancy(
            id: 'starts-at-boundary',
            start: DateTime(2026, 8, 15, 18, 0),
            end: DateTime(2026, 8, 15, 20, 0),
          ),
        ],
      );

      expect(result.status, AgendaAvailabilityStatus.partial);
      expect(result.occupancies, hasLength(1));
      expect(result.freeIntervals.single.start, DateTime(2026, 8, 15, 20, 0));
    });
  });

  group('AgendaAvailabilityAnalyzer — evento atravessando a meia-noite', () {
    test(
      'ocupação iniciada no dia anterior e terminando dentro da data '
      'consultada é recortada a partir do início do dia',
      () {
        final result = AgendaAvailabilityAnalyzer.analyze(
          date: sunday,
          occupancies: [
            _occupancy(
              id: 'crosses-into-sunday',
              start: DateTime(2026, 8, 15, 22, 0),
              end: DateTime(2026, 8, 16, 2, 0),
            ),
          ],
        );

        expect(result.status, AgendaAvailabilityStatus.partial);
        expect(result.occupancies, hasLength(1));
        expect(result.freeIntervals.single.start, DateTime(2026, 8, 16, 2, 0));
        expect(result.freeIntervals.single.end, DateTime(2026, 8, 17));
      },
    );

    test(
      'ocupação iniciada na data consultada e terminando no dia seguinte é '
      'recortada até o fim do dia',
      () {
        final result = AgendaAvailabilityAnalyzer.analyze(
          date: saturday,
          occupancies: [
            _occupancy(
              id: 'crosses-into-sunday',
              start: DateTime(2026, 8, 15, 22, 0),
              end: DateTime(2026, 8, 16, 2, 0),
            ),
          ],
        );

        expect(result.status, AgendaAvailabilityStatus.partial);
        expect(result.freeIntervals.first.end, DateTime(2026, 8, 15, 22, 0));
      },
    );

    test('consulta por intervalo que atravessa a meia-noite funciona '
        'corretamente', () {
      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        periodStart: DateTime(2026, 8, 15, 22, 0),
        periodEnd: DateTime(2026, 8, 16, 2, 0),
        occupancies: [
          _occupancy(
            id: 'overnight-event',
            start: DateTime(2026, 8, 15, 22, 0),
            end: DateTime(2026, 8, 16, 2, 0),
          ),
        ],
      );

      expect(result.status, AgendaAvailabilityStatus.busy);
    });
  });

  group('AgendaAvailabilityAnalyzer — consulta por dia inteiro', () {
    test('sem periodStart/periodEnd, o período é a data consultada completa', () {
      final result = AgendaAvailabilityAnalyzer.analyze(
        date: saturday,
        occupancies: const [],
      );

      expect(result.freeIntervals.single.start, dayStart);
      expect(result.freeIntervals.single.end, dayEnd);
    });

    test('ignora o horário informado em date, considerando somente a data '
        'civil', () {
      final result = AgendaAvailabilityAnalyzer.analyze(
        date: DateTime(2026, 8, 15, 13, 45),
        occupancies: const [],
      );

      expect(result.freeIntervals.single.start, dayStart);
      expect(result.freeIntervals.single.end, dayEnd);
    });
  });
}
