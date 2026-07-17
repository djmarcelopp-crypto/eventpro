import 'quote_team_member.dart';

/// Aggregated team lines for a single quote (TASK-029 CP-D).
///
/// Pure snapshot of [QuoteTeamMember] rows — never schedules shifts or
/// mutates roster status.
class QuoteTeamSummary {
  QuoteTeamSummary({
    required this.quoteId,
    required List<QuoteTeamMember> items,
  }) : items = List.unmodifiable(items);

  final String quoteId;

  /// Team lines linked to [quoteId], typically ordered by creation.
  final List<QuoteTeamMember> items;

  int get lineCount => items.length;

  /// Sum of snapshotted [QuoteTeamMember.dailyRate] values (cents).
  int get totalCostCents =>
      items.fold<int>(0, (sum, item) => sum + item.dailyRate);

  bool get hasItems => items.isNotEmpty;
}
