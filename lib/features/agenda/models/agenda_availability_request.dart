import 'agenda_availability_intent.dart';
import 'agenda_query.dart';

/// Structured, successfully parsed availability question.
class AgendaAvailabilityRequest {
  const AgendaAvailabilityRequest({
    required this.intent,
    required this.query,
    this.periodStart,
    this.periodEnd,
  });

  final AgendaAvailabilityIntent intent;

  /// The resolved query (day / date range / week / month), ready to be
  /// handed to `AgendaAvailabilityQueryService.run` or, when [periodStart]
  /// and [periodEnd] are set, to `AgendaAvailabilityAnalyzer.analyze`
  /// directly for that single day.
  final AgendaQuery query;

  /// Only set for [AgendaAvailabilityIntent.timeRange] — narrows [query]'s
  /// single day to a specific time-of-day interval.
  final DateTime? periodStart;
  final DateTime? periodEnd;
}

/// Reason why `AgendaAvailabilityRequestParser` could not resolve a phrase
/// into an [AgendaAvailabilityRequest].
enum AgendaAvailabilityParseErrorKind { ambiguous, unsupported }

/// Structured parse failure — never a thrown exception, always a returned
/// value (see [AgendaAvailabilityParseResult]).
class AgendaAvailabilityParseError {
  const AgendaAvailabilityParseError({
    required this.kind,
    required this.message,
  });

  final AgendaAvailabilityParseErrorKind kind;

  /// Technical, non-localized explanation. Not meant to be presented as-is
  /// in the UI.
  final String message;
}

/// Outcome of `AgendaAvailabilityRequestParser.parse` — exactly one of
/// [request] or [error] is set.
class AgendaAvailabilityParseResult {
  const AgendaAvailabilityParseResult._({this.request, this.error});

  factory AgendaAvailabilityParseResult.success(
    AgendaAvailabilityRequest request,
  ) {
    return AgendaAvailabilityParseResult._(request: request);
  }

  factory AgendaAvailabilityParseResult.failure(
    AgendaAvailabilityParseError error,
  ) {
    return AgendaAvailabilityParseResult._(error: error);
  }

  final AgendaAvailabilityRequest? request;
  final AgendaAvailabilityParseError? error;

  bool get isSuccess => request != null;
}
