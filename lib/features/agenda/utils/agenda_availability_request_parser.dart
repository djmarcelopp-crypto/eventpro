import '../models/agenda_availability_intent.dart';
import '../models/agenda_availability_request.dart';
import '../models/agenda_query.dart';

/// Deterministic, rule-based interpreter for simple Portuguese availability
/// questions (e.g. "Tenho agenda hoje?"). No LLM, no AI, no network — plain
/// keyword/regex matching, resolved into an `AgendaQuery` (CP-B). This class
/// holds no availability logic of its own; it only recognizes *which*
/// period is being asked about.
///
/// No Flutter, Riverpod, SQLite, DAO, Repository or UI dependency — pure
/// Dart, same as `AgendaAvailabilityAnalyzer` and
/// `AgendaAvailabilityQueryService`.
class AgendaAvailabilityRequestParser {
  AgendaAvailabilityRequestParser({DateTime Function()? clock})
    : clock = clock ?? DateTime.now;

  /// Injectable clock — defaults to [DateTime.now], overridable in tests.
  final DateTime Function() clock;

  static const _accentedChars = 'áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇ';
  static const _plainChars = 'aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC';

  static final _datePattern = RegExp(r'(\d{1,2})/(\d{1,2})/(\d{4})');
  static final _timeRangePattern = RegExp(
    r'(?:entre|das)\s+(\d{1,2})h(\d{1,2})?\s*(?:e|as|ate)\s+(\d{1,2})h(\d{1,2})?',
  );

  static const _weekdayNames = {
    'domingo': DateTime.sunday,
    'segunda': DateTime.monday,
    'terca': DateTime.tuesday,
    'quarta': DateTime.wednesday,
    'quinta': DateTime.thursday,
    'sexta': DateTime.friday,
    'sabado': DateTime.saturday,
  };

  static const _monthNames = {
    'janeiro': 1,
    'fevereiro': 2,
    'marco': 3,
    'abril': 4,
    'maio': 5,
    'junho': 6,
    'julho': 7,
    'agosto': 8,
    'setembro': 9,
    'outubro': 10,
    'novembro': 11,
    'dezembro': 12,
  };

  /// Parses [phrase] into a structured [AgendaAvailabilityRequest], or a
  /// structured [AgendaAvailabilityParseError] when the phrase is ambiguous
  /// or not supported.
  AgendaAvailabilityParseResult parse(String phrase) {
    final normalized = _normalize(phrase);
    final now = clock();

    final explicitDates = _datePattern
        .allMatches(normalized)
        .map(_parseDateMatch)
        .toList();

    if (explicitDates.length >= 2) {
      final sorted = [...explicitDates]..sort();
      return AgendaAvailabilityParseResult.success(
        AgendaAvailabilityRequest(
          intent: AgendaAvailabilityIntent.dateRange,
          query: AgendaQuery.dateRange(start: sorted.first, end: sorted.last),
        ),
      );
    }

    final hasHoje = normalized.contains('hoje');
    final hasAmanha = normalized.contains('amanha');
    final weekday = _findWeekday(normalized);

    final daySignalCount = [
      hasHoje,
      hasAmanha,
      weekday != null,
      explicitDates.length == 1,
    ].where((signal) => signal).length;

    if (daySignalCount > 1) {
      return AgendaAvailabilityParseResult.failure(
        const AgendaAvailabilityParseError(
          kind: AgendaAvailabilityParseErrorKind.ambiguous,
          message:
              'A frase menciona mais de uma referência de dia conflitante '
              '(ex.: "hoje" e "amanhã" na mesma pergunta).',
        ),
      );
    }

    DateTime? singleDay;
    if (explicitDates.length == 1) {
      singleDay = explicitDates.single;
    } else if (hasHoje) {
      singleDay = _civilDate(now);
    } else if (hasAmanha) {
      singleDay = _civilDate(now).add(const Duration(days: 1));
    } else if (weekday != null) {
      singleDay = _resolveWeekdayDate(
        weekday.weekday,
        now,
        nextWeek: weekday.isNextWeek,
      );
    }

    final timeRange = _extractTimeRange(normalized);
    if (timeRange != null) {
      if (singleDay == null) {
        return AgendaAvailabilityParseResult.failure(
          const AgendaAvailabilityParseError(
            kind: AgendaAvailabilityParseErrorKind.unsupported,
            message: 'Intervalo de horário informado sem um dia associado.',
          ),
        );
      }

      final periodStart = DateTime(
        singleDay.year,
        singleDay.month,
        singleDay.day,
        timeRange.startHour,
        timeRange.startMinute,
      );
      final periodEnd = DateTime(
        singleDay.year,
        singleDay.month,
        singleDay.day,
        timeRange.endHour,
        timeRange.endMinute,
      );

      if (!periodEnd.isAfter(periodStart)) {
        return AgendaAvailabilityParseResult.failure(
          const AgendaAvailabilityParseError(
            kind: AgendaAvailabilityParseErrorKind.ambiguous,
            message: 'O horário final deve ser depois do horário inicial.',
          ),
        );
      }

      return AgendaAvailabilityParseResult.success(
        AgendaAvailabilityRequest(
          intent: AgendaAvailabilityIntent.timeRange,
          query: AgendaQuery.day(singleDay),
          periodStart: periodStart,
          periodEnd: periodEnd,
        ),
      );
    }

    if (explicitDates.length == 1) {
      return AgendaAvailabilityParseResult.success(
        AgendaAvailabilityRequest(
          intent: AgendaAvailabilityIntent.specificDay,
          query: AgendaQuery.day(singleDay!),
        ),
      );
    }
    if (hasHoje) {
      return AgendaAvailabilityParseResult.success(
        AgendaAvailabilityRequest(
          intent: AgendaAvailabilityIntent.today,
          query: AgendaQuery.day(singleDay!),
        ),
      );
    }
    if (hasAmanha) {
      return AgendaAvailabilityParseResult.success(
        AgendaAvailabilityRequest(
          intent: AgendaAvailabilityIntent.tomorrow,
          query: AgendaQuery.day(singleDay!),
        ),
      );
    }
    if (weekday != null) {
      return AgendaAvailabilityParseResult.success(
        AgendaAvailabilityRequest(
          intent: AgendaAvailabilityIntent.specificDay,
          query: AgendaQuery.day(singleDay!),
        ),
      );
    }

    final hasNextWeek =
        normalized.contains('proxima semana') ||
        normalized.contains('semana que vem') ||
        normalized.contains('semana seguinte');
    if (hasNextWeek) {
      return AgendaAvailabilityParseResult.success(
        AgendaAvailabilityRequest(
          intent: AgendaAvailabilityIntent.nextWeek,
          query: AgendaQuery.week(now.add(const Duration(days: 7))),
        ),
      );
    }
    if (normalized.contains('semana')) {
      return AgendaAvailabilityParseResult.success(
        AgendaAvailabilityRequest(
          intent: AgendaAvailabilityIntent.currentWeek,
          query: AgendaQuery.week(now),
        ),
      );
    }

    final hasCurrentMonth =
        normalized.contains('mes atual') || normalized.contains('este mes');
    if (hasCurrentMonth) {
      return AgendaAvailabilityParseResult.success(
        AgendaAvailabilityRequest(
          intent: AgendaAvailabilityIntent.currentMonth,
          query: AgendaQuery.month(now),
        ),
      );
    }

    final month = _findMonth(normalized);
    if (month != null) {
      return AgendaAvailabilityParseResult.success(
        AgendaAvailabilityRequest(
          intent: AgendaAvailabilityIntent.namedMonth,
          query: AgendaQuery.month(DateTime(now.year, month, 1)),
        ),
      );
    }

    return AgendaAvailabilityParseResult.failure(
      const AgendaAvailabilityParseError(
        kind: AgendaAvailabilityParseErrorKind.unsupported,
        message: 'Não foi possível identificar um período de agenda na frase.',
      ),
    );
  }

  static String _normalize(String input) {
    final lower = input.toLowerCase();
    final buffer = StringBuffer();
    for (final rune in lower.runes) {
      final char = String.fromCharCode(rune);
      final index = _accentedChars.indexOf(char);
      buffer.write(index == -1 ? char : _plainChars[index]);
    }
    return buffer.toString();
  }

  static DateTime _civilDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime _parseDateMatch(RegExpMatch match) {
    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final year = int.parse(match.group(3)!);
    return DateTime(year, month, day);
  }

  static ({int weekday, bool isNextWeek})? _findWeekday(String normalized) {
    for (final entry in _weekdayNames.entries) {
      if (normalized.contains(entry.key)) {
        final isNextWeek =
            normalized.contains('proximo') || normalized.contains('proxima');
        return (weekday: entry.value, isNextWeek: isNextWeek);
      }
    }
    return null;
  }

  static int? _findMonth(String normalized) {
    for (final entry in _monthNames.entries) {
      if (normalized.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  static DateTime _resolveWeekdayDate(
    int targetWeekday,
    DateTime now, {
    required bool nextWeek,
  }) {
    final civilNow = _civilDate(now);
    var delta = targetWeekday - civilNow.weekday;
    if (nextWeek) {
      delta += 7;
    }
    return civilNow.add(Duration(days: delta));
  }

  static ({int startHour, int startMinute, int endHour, int endMinute})?
  _extractTimeRange(String normalized) {
    final match = _timeRangePattern.firstMatch(normalized);
    if (match == null) {
      return null;
    }

    return (
      startHour: int.parse(match.group(1)!),
      startMinute: match.group(2) == null ? 0 : int.parse(match.group(2)!),
      endHour: int.parse(match.group(3)!),
      endMinute: match.group(4) == null ? 0 : int.parse(match.group(4)!),
    );
  }
}
