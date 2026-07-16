import 'package:eventpro/features/agenda/models/agenda_availability_intent.dart';
import 'package:eventpro/features/agenda/models/agenda_availability_request.dart';
import 'package:eventpro/features/agenda/models/agenda_availability_response.dart';
import 'package:eventpro/features/agenda/models/agenda_availability_result.dart';
import 'package:eventpro/features/agenda/models/agenda_occupancy.dart';
import 'package:eventpro/features/agenda/models/agenda_query_result.dart';
import 'package:eventpro/features/agenda/utils/agenda_availability_response_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

AgendaOccupancy _occupancy(String id) {
  return AgendaOccupancy(
    id: id,
    kind: AgendaOccupancyKind.block,
    title: 'Ocupação $id',
    start: DateTime(2026, 8, 20, 8, 0),
    end: DateTime(2026, 8, 20, 10, 0),
    sourceBlockId: id,
  );
}

AgendaQueryResult _periodResult({
  required int freeDays,
  required int partialDays,
  required int busyDays,
  DateTime? periodStart,
  DateTime? periodEnd,
  List<AgendaOccupancyConflict> conflicts = const [],
}) {
  return AgendaQueryResult(
    periodStart: periodStart ?? DateTime(2026, 8, 17),
    periodEnd: periodEnd ?? DateTime(2026, 8, 24),
    availability: AgendaAvailabilityStatus.partial,
    dailyResults: const [],
    conflicts: conflicts,
    summary: AgendaAvailabilitySummary(
      freeDays: freeDays,
      partialDays: partialDays,
      busyDays: busyDays,
    ),
  );
}

void main() {
  group('AgendaAvailabilityResponseFormatter.formatDay — singular/plural', () {
    test('uma única ocupação usa singular', () {
      final result = AgendaAvailabilityResult(
        status: AgendaAvailabilityStatus.partial,
        reason: 'irrelevante para o teste',
        occupancies: [_occupancy('a')],
        freeIntervals: const [],
        conflicts: const [],
      );

      final response = AgendaAvailabilityResponseFormatter.formatDay(
        date: DateTime(2026, 8, 20),
        result: result,
      );

      expect(response.message, contains('Existe 1 ocupação.'));
    });

    test('múltiplas ocupações usam plural', () {
      final result = AgendaAvailabilityResult(
        status: AgendaAvailabilityStatus.partial,
        reason: 'irrelevante para o teste',
        occupancies: [_occupancy('a'), _occupancy('b'), _occupancy('c')],
        freeIntervals: const [],
        conflicts: const [],
      );

      final response = AgendaAvailabilityResponseFormatter.formatDay(
        date: DateTime(2026, 8, 20),
        result: result,
      );

      expect(response.message, contains('Existem 3 ocupações.'));
    });

    test('nenhuma ocupação não gera frase de detalhe', () {
      const result = AgendaAvailabilityResult(
        status: AgendaAvailabilityStatus.free,
        reason: 'irrelevante para o teste',
        occupancies: [],
        freeIntervals: [],
        conflicts: [],
      );

      final response = AgendaAvailabilityResponseFormatter.formatDay(
        date: DateTime(2026, 8, 20),
        result: result,
      );

      expect(response.message, 'Sua agenda está livre em 20/08/2026.');
    });

    test('um único conflito usa singular mesmo com múltiplas ocupações', () {
      final a = _occupancy('a');
      final b = _occupancy('b');
      final result = AgendaAvailabilityResult(
        status: AgendaAvailabilityStatus.partial,
        reason: 'irrelevante para o teste',
        occupancies: [a, b],
        freeIntervals: const [],
        conflicts: [AgendaOccupancyConflict(first: a, second: b)],
      );

      final response = AgendaAvailabilityResponseFormatter.formatDay(
        date: DateTime(2026, 8, 20),
        result: result,
      );

      expect(response.message, contains('Existem 2 ocupações e 1 conflito.'));
    });
  });

  group('AgendaAvailabilityResponseFormatter.formatPeriod — ordenação', () {
    test('a ordem das cláusulas é sempre livre, parcial, ocupado', () {
      final response = AgendaAvailabilityResponseFormatter.formatPeriod(
        intent: AgendaAvailabilityIntent.currentWeek,
        result: _periodResult(freeDays: 4, partialDays: 2, busyDays: 1),
      );

      expect(
        response.message,
        'Nesta semana: 4 dias livres, 2 parcialmente ocupados e 1 ocupado.',
      );
    });

    test('somente um status presente não usa vírgula nem "e"', () {
      final response = AgendaAvailabilityResponseFormatter.formatPeriod(
        intent: AgendaAvailabilityIntent.currentWeek,
        result: _periodResult(freeDays: 7, partialDays: 0, busyDays: 0),
      );

      expect(response.message, 'Nesta semana: 7 dias livres.');
    });

    test('dois status presentes usam apenas "e", sem vírgula', () {
      final response = AgendaAvailabilityResponseFormatter.formatPeriod(
        intent: AgendaAvailabilityIntent.currentWeek,
        result: _periodResult(freeDays: 4, partialDays: 0, busyDays: 3),
      );

      expect(response.message, 'Nesta semana: 4 dias livres e 3 ocupados.');
    });
  });

  group('AgendaAvailabilityResponseFormatter.formatPeriod — singular/plural', () {
    test('um único dia livre usa singular', () {
      final response = AgendaAvailabilityResponseFormatter.formatPeriod(
        intent: AgendaAvailabilityIntent.currentWeek,
        result: _periodResult(freeDays: 1, partialDays: 0, busyDays: 0),
      );

      expect(response.message, 'Nesta semana: 1 dia livre.');
    });

    test('um único dia parcial usa singular', () {
      final response = AgendaAvailabilityResponseFormatter.formatPeriod(
        intent: AgendaAvailabilityIntent.currentWeek,
        result: _periodResult(freeDays: 0, partialDays: 1, busyDays: 0),
      );

      expect(response.message, 'Nesta semana: 1 parcialmente ocupado.');
    });

    test('um único dia ocupado usa singular', () {
      final response = AgendaAvailabilityResponseFormatter.formatPeriod(
        intent: AgendaAvailabilityIntent.currentWeek,
        result: _periodResult(freeDays: 0, partialDays: 0, busyDays: 1),
      );

      expect(response.message, 'Nesta semana: 1 ocupado.');
    });

    test('um único conflito no período usa singular', () {
      final a = _occupancy('a');
      final b = _occupancy('b');
      final response = AgendaAvailabilityResponseFormatter.formatPeriod(
        intent: AgendaAvailabilityIntent.currentWeek,
        result: _periodResult(
          freeDays: 6,
          partialDays: 1,
          busyDays: 0,
          conflicts: [AgendaOccupancyConflict(first: a, second: b)],
        ),
      );

      expect(response.message, contains('Existe 1 conflito no período consultado.'));
    });

    test('múltiplos conflitos no período usam plural', () {
      final a = _occupancy('a');
      final b = _occupancy('b');
      final c = _occupancy('c');
      final response = AgendaAvailabilityResponseFormatter.formatPeriod(
        intent: AgendaAvailabilityIntent.currentWeek,
        result: _periodResult(
          freeDays: 5,
          partialDays: 2,
          busyDays: 0,
          conflicts: [
            AgendaOccupancyConflict(first: a, second: b),
            AgendaOccupancyConflict(first: b, second: c),
          ],
        ),
      );

      expect(
        response.message,
        contains('Existem 2 conflitos no período consultado.'),
      );
    });
  });

  group('AgendaAvailabilityResponseFormatter.formatPeriod — rótulos de período', () {
    test('mês nomeado em dezembro usa o nome do mês corretamente', () {
      final response = AgendaAvailabilityResponseFormatter.formatPeriod(
        intent: AgendaAvailabilityIntent.namedMonth,
        result: _periodResult(
          freeDays: 31,
          partialDays: 0,
          busyDays: 0,
          periodStart: DateTime(2026, 12, 1),
          periodEnd: DateTime(2027, 1, 1),
        ),
      );

      expect(response.message, 'Em dezembro: 31 dias livres.');
    });

    test('intervalo de datas mostra a data final inclusiva correta', () {
      final response = AgendaAvailabilityResponseFormatter.formatPeriod(
        intent: AgendaAvailabilityIntent.dateRange,
        result: _periodResult(
          freeDays: 3,
          partialDays: 0,
          busyDays: 0,
          periodStart: DateTime(2026, 8, 20),
          periodEnd: DateTime(2026, 8, 23),
        ),
      );

      expect(
        response.message,
        'No período de 20/08/2026 a 22/08/2026: 3 dias livres.',
      );
    });
  });

  group('AgendaAvailabilityResponseFormatter.formatError', () {
    test('erro ambíguo pede reformulação e usa o kind correto', () {
      final response = AgendaAvailabilityResponseFormatter.formatError(
        const AgendaAvailabilityParseError(
          kind: AgendaAvailabilityParseErrorKind.ambiguous,
          message: 'mensagem técnica interna',
        ),
      );

      expect(response.kind, AgendaAvailabilityResponseKind.ambiguous);
      expect(response.isError, isTrue);
      expect(response.message, contains('reformular'));
    });

    test('erro não suportado explica o que é suportado e usa o kind correto', () {
      final response = AgendaAvailabilityResponseFormatter.formatError(
        const AgendaAvailabilityParseError(
          kind: AgendaAvailabilityParseErrorKind.unsupported,
          message: 'mensagem técnica interna',
        ),
      );

      expect(response.kind, AgendaAvailabilityResponseKind.unsupported);
      expect(response.isError, isTrue);
      expect(response.message, isNotEmpty);
    });
  });
}
