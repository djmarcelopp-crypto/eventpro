import '../../quotes/models/quote.dart';
import '../../quotes/models/quote_status.dart';
import '../models/quote_team_member.dart';
import '../models/team_availability.dart';
import '../models/team_availability_summary.dart';
import '../models/team_consuming_quote.dart';
import '../models/team_event_period.dart';
import '../models/team_member.dart';
import '../models/team_schedule_conflict.dart';
import 'team_event_period_resolver.dart';

class _Assignment {
  const _Assignment({
    required this.quote,
    required this.period,
  });

  final Quote quote;
  final TeamEventPeriod period;
}

/// Pure calculator for dynamic team availability.
///
/// Uses [QuoteTeamMember] links and quote event periods. Does **not** persist
/// results or mutate [TeamMember.status].
abstract class TeamAvailabilityCalculator {
  /// Quote statuses that occupy a member for overlapping periods.
  static const consumingStatuses = <QuoteStatus>{
    QuoteStatus.draft,
    QuoteStatus.sent,
    QuoteStatus.approved,
  };

  static const partialOverlapReason =
      'Sobreposição parcial de período com outro orçamento';
  static const totalOverlapReason =
      'Sobreposição total de período com outro orçamento';

  static TeamAvailabilitySummary summarize(List<TeamAvailability> items) {
    return TeamAvailabilitySummary.fromItems(items);
  }

  static List<TeamAvailability> calculateAll({
    required List<TeamMember> members,
    required List<QuoteTeamMember> quoteTeamMembers,
    required List<Quote> quotes,
    TeamEventPeriod? queryPeriod,
  }) {
    final quotesById = <String, Quote>{
      for (final quote in quotes) quote.id: quote,
    };

    return [
      for (final member in members)
        calculateForMember(
          member: member,
          quoteTeamMembers: quoteTeamMembers,
          quotesById: quotesById,
          queryPeriod: queryPeriod,
        ),
    ];
  }

  static TeamAvailability calculateForMember({
    required TeamMember member,
    required List<QuoteTeamMember> quoteTeamMembers,
    required Map<String, Quote> quotesById,
    TeamEventPeriod? queryPeriod,
  }) {
    final assignments = <_Assignment>[];

    for (final line in quoteTeamMembers) {
      if (line.teamMemberId != member.id) {
        continue;
      }
      final quote = quotesById[line.quoteId];
      if (quote == null) {
        continue;
      }
      if (!consumingStatuses.contains(quote.status)) {
        continue;
      }
      final period = TeamEventPeriodResolver.resolve(quote.eventSnapshot);
      if (period == null) {
        continue;
      }
      assignments.add(_Assignment(quote: quote, period: period));
    }

    assignments.sort((a, b) => a.period.start.compareTo(b.period.start));

    final consumingQuotes = [
      for (final assignment in assignments)
        TeamConsumingQuote(
          quoteId: assignment.quote.id,
          quoteNumber: assignment.quote.number,
          eventName: assignment.quote.eventSnapshot.name,
          eventPeriod: assignment.period,
        ),
    ];

    final conflicts = <TeamScheduleConflict>[];
    for (var i = 0; i < assignments.length; i++) {
      for (var j = i + 1; j < assignments.length; j++) {
        final first = assignments[i];
        final second = assignments[j];
        if (!_periodsOverlap(first.period, second.period)) {
          continue;
        }
        final reason = _overlapReason(first.period, second.period);
        conflicts.add(
          TeamScheduleConflict(
            teamMemberId: member.id,
            quoteId: first.quote.id,
            eventPeriod: first.period,
            reason: reason,
          ),
        );
        conflicts.add(
          TeamScheduleConflict(
            teamMemberId: member.id,
            quoteId: second.quote.id,
            eventPeriod: second.period,
            reason: reason,
          ),
        );
      }
    }

    final relevantAssignments = queryPeriod == null
        ? assignments
        : [
            for (final assignment in assignments)
              if (_periodsOverlap(assignment.period, queryPeriod)) assignment,
          ];

    final status = relevantAssignments.isEmpty
        ? TeamAvailabilityStatus.available
        : TeamAvailabilityStatus.unavailable;

    return TeamAvailability(
      teamMemberId: member.id,
      status: status,
      consumingQuotes: List<TeamConsumingQuote>.unmodifiable(consumingQuotes),
      conflicts: List<TeamScheduleConflict>.unmodifiable(conflicts),
    );
  }

  static bool _periodsOverlap(
    TeamEventPeriod first,
    TeamEventPeriod second,
  ) {
    return first.start.isBefore(second.end) && second.start.isBefore(first.end);
  }

  /// Total overlap when one period contains the other (or they are equal);
  /// otherwise partial.
  static String _overlapReason(
    TeamEventPeriod first,
    TeamEventPeriod second,
  ) {
    final firstContainsSecond = !first.start.isAfter(second.start) &&
        !first.end.isBefore(second.end);
    final secondContainsFirst = !second.start.isAfter(first.start) &&
        !second.end.isBefore(first.end);
    if (firstContainsSecond || secondContainsFirst) {
      return totalOverlapReason;
    }
    return partialOverlapReason;
  }
}
