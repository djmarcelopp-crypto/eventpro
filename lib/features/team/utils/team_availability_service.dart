import '../../quotes/data/repositories/quote_repository.dart';
import '../../quotes/models/quote.dart';
import '../data/repositories/quote_team_repository.dart';
import '../data/repositories/team_member_repository.dart';
import '../models/team_availability.dart';
import '../models/team_availability_summary.dart';
import '../models/team_event_period.dart';
import 'team_availability_calculator.dart';

/// Loads roster and quote links, then delegates to
/// [TeamAvailabilityCalculator].
///
/// Does **not** persist availability or change [TeamMember.status].
class TeamAvailabilityService {
  TeamAvailabilityService({
    required this._memberRepository,
    required this._quoteTeamRepository,
    required this._quoteRepository,
  });

  final TeamMemberRepository _memberRepository;
  final QuoteTeamRepository _quoteTeamRepository;
  final QuoteRepository _quoteRepository;

  Future<List<TeamAvailability>> listAll({
    TeamEventPeriod? queryPeriod,
  }) async {
    final members = await _memberRepository.listAll();
    final quoteTeamMembers = await _quoteTeamRepository.listAll();
    final quotes = await _quoteRepository.listAll();
    return TeamAvailabilityCalculator.calculateAll(
      members: members,
      quoteTeamMembers: quoteTeamMembers,
      quotes: quotes,
      queryPeriod: queryPeriod,
    );
  }

  Future<TeamAvailability?> forMember(
    String teamMemberId, {
    TeamEventPeriod? queryPeriod,
  }) async {
    final member = await _memberRepository.findById(teamMemberId);
    if (member == null) {
      return null;
    }
    final quoteTeamMembers = await _quoteTeamRepository.listAll();
    final quotes = await _quoteRepository.listAll();
    return TeamAvailabilityCalculator.calculateForMember(
      member: member,
      quoteTeamMembers: quoteTeamMembers,
      quotesById: <String, Quote>{
        for (final quote in quotes) quote.id: quote,
      },
      queryPeriod: queryPeriod,
    );
  }

  Future<TeamAvailabilitySummary> summary({
    TeamEventPeriod? queryPeriod,
  }) async {
    final items = await listAll(queryPeriod: queryPeriod);
    return TeamAvailabilityCalculator.summarize(items);
  }
}
