import '../models/agenda_availability_intent.dart';
import '../models/agenda_availability_request.dart';
import '../models/agenda_availability_response.dart';
import '../models/agenda_availability_result.dart';
import '../models/agenda_query_result.dart';

/// Turns already-computed structured results (`AgendaAvailabilityResult`
/// from `AgendaAvailabilityAnalyzer`, `AgendaQueryResult` from
/// `AgendaAvailabilityQueryService`, or a parse error from
/// `AgendaAvailabilityRequestParser`) into a deterministic, PT-BR
/// [AgendaAvailabilityResponse]. No availability rule is computed or
/// re-derived here — only text composition over data that already exists.
abstract class AgendaAvailabilityResponseFormatter {
  static const _monthNames = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];

  /// Formats the result of a single-day (or single time-window) query:
  /// [AgendaAvailabilityIntent.today], [AgendaAvailabilityIntent.tomorrow],
  /// [AgendaAvailabilityIntent.specificDay] or
  /// [AgendaAvailabilityIntent.timeRange].
  static AgendaAvailabilityResponse formatDay({
    required DateTime date,
    required AgendaAvailabilityResult result,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) {
    final statusPhrase = switch (result.status) {
      AgendaAvailabilityStatus.free => 'livre',
      AgendaAvailabilityStatus.partial => 'parcialmente ocupada',
      AgendaAvailabilityStatus.busy => 'totalmente ocupada',
    };

    final buffer = StringBuffer();
    if (periodStart != null && periodEnd != null) {
      buffer.write(
        'Sua agenda está $statusPhrase entre ${_formatTime(periodStart)} e '
        '${_formatTime(periodEnd)} em ${_formatDate(date)}.',
      );
    } else {
      buffer.write('Sua agenda está $statusPhrase em ${_formatDate(date)}.');
    }

    final detail = _occupancyAndConflictSentence(
      occupancyCount: result.occupancies.length,
      conflictCount: result.conflicts.length,
    );
    if (detail != null) {
      buffer.write(' $detail');
    }

    return AgendaAvailabilityResponse(
      kind: AgendaAvailabilityResponseKind.success,
      message: buffer.toString(),
    );
  }

  /// Formats the result of a multi-day query: [AgendaAvailabilityIntent.currentWeek],
  /// [AgendaAvailabilityIntent.nextWeek], [AgendaAvailabilityIntent.currentMonth],
  /// [AgendaAvailabilityIntent.namedMonth] or [AgendaAvailabilityIntent.dateRange].
  static AgendaAvailabilityResponse formatPeriod({
    required AgendaAvailabilityIntent intent,
    required AgendaQueryResult result,
  }) {
    final summary = result.summary;
    final clauses = <String>[];

    if (summary.freeDays > 0) {
      clauses.add(
        '${summary.freeDays} ${_pluralize(summary.freeDays, 'dia livre', 'dias livres')}',
      );
    }
    if (summary.partialDays > 0) {
      clauses.add(
        '${summary.partialDays} ${_pluralize(summary.partialDays, 'parcialmente ocupado', 'parcialmente ocupados')}',
      );
    }
    if (summary.busyDays > 0) {
      clauses.add(
        '${summary.busyDays} ${_pluralize(summary.busyDays, 'ocupado', 'ocupados')}',
      );
    }

    final buffer = StringBuffer(
      '${_periodLabel(intent, result)}: ${_joinWithAnd(clauses)}.',
    );

    if (result.conflicts.isNotEmpty) {
      final count = result.conflicts.length;
      final verb = _pluralize(count, 'Existe', 'Existem');
      final word = _pluralize(count, 'conflito', 'conflitos');
      buffer.write(' $verb $count $word no período consultado.');
    }

    return AgendaAvailabilityResponse(
      kind: AgendaAvailabilityResponseKind.success,
      message: buffer.toString(),
    );
  }

  /// Formats a structured parse failure into a clear request to rephrase.
  static AgendaAvailabilityResponse formatError(
    AgendaAvailabilityParseError error,
  ) {
    switch (error.kind) {
      case AgendaAvailabilityParseErrorKind.ambiguous:
        return const AgendaAvailabilityResponse(
          kind: AgendaAvailabilityResponseKind.ambiguous,
          message:
              'Não entendi exatamente o que você quis perguntar — a frase '
              'tem mais de uma interpretação possível. Pode reformular de '
              'forma mais específica (ex.: "Tenho agenda livre no sábado?")?',
        );
      case AgendaAvailabilityParseErrorKind.unsupported:
        return const AgendaAvailabilityResponse(
          kind: AgendaAvailabilityResponseKind.unsupported,
          message:
              'Ainda não sei responder esse tipo de pergunta sobre a agenda. '
              'Tente perguntar sobre um dia, uma semana, um mês ou um '
              'intervalo de datas específico.',
        );
    }
  }

  static String? _occupancyAndConflictSentence({
    required int occupancyCount,
    required int conflictCount,
  }) {
    if (occupancyCount == 0) {
      return null;
    }

    final existVerb = _pluralize(occupancyCount, 'Existe', 'Existem');
    final occupancyWord = _pluralize(occupancyCount, 'ocupação', 'ocupações');

    if (conflictCount == 0) {
      return '$existVerb $occupancyCount $occupancyWord.';
    }

    final conflictWord = _pluralize(conflictCount, 'conflito', 'conflitos');
    return '$existVerb $occupancyCount $occupancyWord e $conflictCount '
        '$conflictWord.';
  }

  static String _periodLabel(
    AgendaAvailabilityIntent intent,
    AgendaQueryResult result,
  ) {
    switch (intent) {
      case AgendaAvailabilityIntent.currentWeek:
        return 'Nesta semana';
      case AgendaAvailabilityIntent.nextWeek:
        return 'Na próxima semana';
      case AgendaAvailabilityIntent.currentMonth:
        return 'Neste mês';
      case AgendaAvailabilityIntent.namedMonth:
        return 'Em ${_monthNames[result.periodStart.month - 1]}';
      case AgendaAvailabilityIntent.dateRange:
        final lastDay = result.periodEnd.subtract(const Duration(days: 1));
        return 'No período de ${_formatDate(result.periodStart)} a '
            '${_formatDate(lastDay)}';
      case AgendaAvailabilityIntent.today:
      case AgendaAvailabilityIntent.tomorrow:
      case AgendaAvailabilityIntent.specificDay:
      case AgendaAvailabilityIntent.timeRange:
        throw ArgumentError(
          'intent $intent is a single-day intent; use formatDay instead',
        );
    }
  }

  static String _joinWithAnd(List<String> parts) {
    if (parts.isEmpty) {
      return 'nenhum dado disponível';
    }
    if (parts.length == 1) {
      return parts.single;
    }
    final head = parts.sublist(0, parts.length - 1).join(', ');
    return '$head e ${parts.last}';
  }

  static String _pluralize(int count, String singular, String plural) {
    return count == 1 ? singular : plural;
  }

  static String _two(int value) => value.toString().padLeft(2, '0');

  static String _formatDate(DateTime date) {
    return '${_two(date.day)}/${_two(date.month)}/${date.year}';
  }

  static String _formatTime(DateTime date) {
    return '${_two(date.hour)}:${_two(date.minute)}';
  }
}
