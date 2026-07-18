import 'package:eventpro/features/team/models/quote_team_member.dart';

/// Domain contract for persisting [QuoteTeamMember] link rows.
abstract class QuoteTeamRepository {
  Future<List<QuoteTeamMember>> listAll();

  Future<QuoteTeamMember?> findById(String id);

  /// Lines for a given quote, ordered by [QuoteTeamMember.createdAt].
  Future<List<QuoteTeamMember>> listByQuoteId(String quoteId);

  Future<void> insert(QuoteTeamMember item);

  Future<void> update(QuoteTeamMember item);

  Future<void> delete(String id);
}
