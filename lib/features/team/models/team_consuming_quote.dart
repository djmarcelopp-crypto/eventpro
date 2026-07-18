import 'team_event_period.dart';

/// A quote that plans to use a roster member in a period.
///
/// DTO only — never persisted as availability state.
class TeamConsumingQuote {
  const TeamConsumingQuote({
    required this.quoteId,
    required this.eventPeriod,
    this.quoteNumber,
    this.eventName,
  });

  final String quoteId;
  final String? quoteNumber;
  final String? eventName;
  final TeamEventPeriod eventPeriod;
}
