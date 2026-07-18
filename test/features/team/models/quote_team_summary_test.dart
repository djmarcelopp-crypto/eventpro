import 'package:eventpro/features/team/models/quote_team_member.dart';
import 'package:eventpro/features/team/models/quote_team_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuoteTeamSummary', () {
    final now = DateTime(2026, 7, 1);

    QuoteTeamMember buildLine({
      required String id,
      required int dailyRate,
    }) {
      return QuoteTeamMember(
        id: id,
        quoteId: 'quote-1',
        teamMemberId: 'member-$id',
        roleId: 'role-1',
        dailyRate: dailyRate,
        createdAt: now,
        updatedAt: now,
      );
    }

    test('aggregates lineCount and totalCostCents', () {
      final summary = QuoteTeamSummary(
        quoteId: 'quote-1',
        items: [
          buildLine(id: 'a', dailyRate: 25_000),
          buildLine(id: 'b', dailyRate: 15_000),
        ],
      );

      expect(summary.lineCount, 2);
      expect(summary.totalCostCents, 40_000);
      expect(summary.hasItems, isTrue);
    });

    test('empty summary has zero totals', () {
      final summary = QuoteTeamSummary(quoteId: 'quote-1', items: const []);

      expect(summary.lineCount, 0);
      expect(summary.totalCostCents, 0);
      expect(summary.hasItems, isFalse);
    });
  });
}
