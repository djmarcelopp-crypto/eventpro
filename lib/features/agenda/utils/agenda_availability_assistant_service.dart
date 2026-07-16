import '../models/agenda_availability_intent.dart';
import '../models/agenda_availability_response.dart';
import '../models/agenda_occupancy.dart';
import 'agenda_availability_analyzer.dart';
import 'agenda_availability_query_service.dart';
import 'agenda_availability_request_parser.dart';
import 'agenda_availability_response_formatter.dart';

/// Orchestrates the full deterministic pipeline of the Agenda Inteligente
/// (still no AI/LLM): parses a Portuguese phrase
/// ([AgendaAvailabilityRequestParser]), resolves the underlying
/// availability data ([AgendaAvailabilityAnalyzer] /
/// [AgendaAvailabilityQueryService]), and formats a PT-BR response
/// ([AgendaAvailabilityResponseFormatter]). Holds no availability or
/// parsing rule of its own — purely wires the CP-A/B/C outputs together.
class AgendaAvailabilityAssistantService {
  AgendaAvailabilityAssistantService({required this.parser});

  /// Owns the injectable clock used to resolve relative phrases
  /// ("hoje", "amanhã", "esta semana"...).
  final AgendaAvailabilityRequestParser parser;

  AgendaAvailabilityResponse ask({
    required String phrase,
    required List<AgendaOccupancy> occupancies,
  }) {
    final parseResult = parser.parse(phrase);
    if (!parseResult.isSuccess) {
      return AgendaAvailabilityResponseFormatter.formatError(
        parseResult.error!,
      );
    }

    final request = parseResult.request!;

    switch (request.intent) {
      case AgendaAvailabilityIntent.today:
      case AgendaAvailabilityIntent.tomorrow:
      case AgendaAvailabilityIntent.specificDay:
        final date = request.query.rangeStart;
        final result = AgendaAvailabilityAnalyzer.analyze(
          date: date,
          occupancies: occupancies,
        );
        return AgendaAvailabilityResponseFormatter.formatDay(
          date: date,
          result: result,
        );

      case AgendaAvailabilityIntent.timeRange:
        final date = request.query.rangeStart;
        final result = AgendaAvailabilityAnalyzer.analyze(
          date: date,
          occupancies: occupancies,
          periodStart: request.periodStart,
          periodEnd: request.periodEnd,
        );
        return AgendaAvailabilityResponseFormatter.formatDay(
          date: date,
          result: result,
          periodStart: request.periodStart,
          periodEnd: request.periodEnd,
        );

      case AgendaAvailabilityIntent.currentWeek:
      case AgendaAvailabilityIntent.nextWeek:
      case AgendaAvailabilityIntent.currentMonth:
      case AgendaAvailabilityIntent.namedMonth:
      case AgendaAvailabilityIntent.dateRange:
        final result = AgendaAvailabilityQueryService.run(
          query: request.query,
          occupancies: occupancies,
        );
        return AgendaAvailabilityResponseFormatter.formatPeriod(
          intent: request.intent,
          result: result,
        );
    }
  }
}
