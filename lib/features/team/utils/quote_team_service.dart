import 'package:eventpro/features/quotes/data/repositories/quote_repository.dart';
import 'package:uuid/uuid.dart';

import '../data/repositories/quote_team_repository.dart';
import '../data/repositories/team_member_repository.dart';
import '../data/repositories/team_role_repository.dart';
import '../models/quote_team_delete_result.dart';
import '../models/quote_team_member.dart';
import '../models/quote_team_summary.dart';
import '../models/quote_team_write_result.dart';
import '../models/team_member_status.dart';

/// Coordinates linking roster members to quotes with rate/role snapshots.
///
/// Does **not** create schedules, check-ins, payroll, or mutate roster status.
class QuoteTeamService {
  QuoteTeamService({
    required this._quoteTeamRepository,
    required this._teamMemberRepository,
    required this._teamRoleRepository,
    required this._quoteRepository,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();

  final QuoteTeamRepository _quoteTeamRepository;
  final TeamMemberRepository _teamMemberRepository;
  final TeamRoleRepository _teamRoleRepository;
  final QuoteRepository _quoteRepository;
  final DateTime Function() _clock;

  /// Adds [teamMemberId] to [quoteId], snapshotting role and daily rate.
  Future<QuoteTeamWriteResult> add({
    required String quoteId,
    required String teamMemberId,
    String? notes,
  }) async {
    final quote = await _quoteRepository.findById(quoteId);
    if (quote == null) {
      return QuoteTeamWriteResult.quoteNotFound();
    }

    final member = await _teamMemberRepository.findById(teamMemberId);
    if (member == null) {
      return QuoteTeamWriteResult.memberNotFound();
    }
    if (member.status != TeamMemberStatus.active) {
      return QuoteTeamWriteResult.memberInactive();
    }

    final role = await _teamRoleRepository.findById(member.roleId);
    if (role == null) {
      return QuoteTeamWriteResult.roleNotFound();
    }
    if (!role.active) {
      return QuoteTeamWriteResult.roleInactive();
    }

    final existingLines =
        await _quoteTeamRepository.listByQuoteId(quoteId);
    final duplicate = existingLines.any(
      (line) => line.teamMemberId == teamMemberId,
    );
    if (duplicate) {
      return QuoteTeamWriteResult.duplicateMember();
    }

    final now = _clock();
    final trimmedNotes = notes?.trim();
    final item = QuoteTeamMember(
      id: _uuid.v7(),
      quoteId: quoteId,
      teamMemberId: teamMemberId,
      roleId: member.roleId,
      dailyRate: member.dailyRate,
      notes: (trimmedNotes == null || trimmedNotes.isEmpty)
          ? null
          : trimmedNotes,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _quoteTeamRepository.insert(item);
      return QuoteTeamWriteResult.success(item);
    } catch (_) {
      return QuoteTeamWriteResult.failure();
    }
  }

  Future<QuoteTeamDeleteResult> remove(String id) async {
    final existing = await _quoteTeamRepository.findById(id);
    if (existing == null) {
      return const QuoteTeamDeleteResult(
        status: QuoteTeamDeleteStatus.notFound,
      );
    }

    try {
      await _quoteTeamRepository.delete(id);
      return const QuoteTeamDeleteResult(
        status: QuoteTeamDeleteStatus.deleted,
      );
    } catch (_) {
      return const QuoteTeamDeleteResult(
        status: QuoteTeamDeleteStatus.failure,
      );
    }
  }

  Future<List<QuoteTeamMember>> listForQuote(String quoteId) {
    return _quoteTeamRepository.listByQuoteId(quoteId);
  }

  Future<QuoteTeamSummary> summaryForQuote(String quoteId) async {
    final items = await _quoteTeamRepository.listByQuoteId(quoteId);
    return QuoteTeamSummary(quoteId: quoteId, items: items);
  }

  /// Sum of snapshotted daily rates (cents) for [quoteId].
  Future<int> totalCostCentsForQuote(String quoteId) async {
    final summary = await summaryForQuote(quoteId);
    return summary.totalCostCents;
  }
}
