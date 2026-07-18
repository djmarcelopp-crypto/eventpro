import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/utils/financial_event_summary_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialEventSummaryCalculator', () {
    final createdAt = DateTime(2026, 8, 1, 9, 0);

    FinancialEntry buildEntry({
      required String id,
      required FinancialFlowKind kind,
      required int amountCents,
      DateTime? date,
      String? quoteId,
    }) {
      return FinancialEntry(
        id: id,
        kind: kind,
        description: 'Lançamento $id',
        amountCents: amountCents,
        date: date ?? DateTime(2026, 8, 5),
        categoryId: 'category-1',
        quoteId: quoteId,
        createdAt: createdAt,
        updatedAt: createdAt,
      );
    }

    test('returns zeroed totals when there are no linked entries', () {
      final summary = FinancialEventSummaryCalculator.calculate(
        'quote-1',
        const [],
      );

      expect(summary.quoteId, 'quote-1');
      expect(summary.entries, isEmpty);
      expect(summary.totalIncomeCents, 0);
      expect(summary.totalExpenseCents, 0);
      expect(summary.profitCents, 0);
      expect(summary.hasEntries, isFalse);
    });

    test('sums income entries into totalIncomeCents', () {
      final entries = [
        buildEntry(
          id: 'e1',
          kind: FinancialFlowKind.income,
          amountCents: 100000,
          quoteId: 'quote-1',
        ),
        buildEntry(
          id: 'e2',
          kind: FinancialFlowKind.income,
          amountCents: 50000,
          quoteId: 'quote-1',
        ),
      ];

      final summary = FinancialEventSummaryCalculator.calculate(
        'quote-1',
        entries,
      );

      expect(summary.totalIncomeCents, 150000);
      expect(summary.totalExpenseCents, 0);
      expect(summary.profitCents, 150000);
    });

    test('sums expense entries into totalExpenseCents', () {
      final entries = [
        buildEntry(
          id: 'e1',
          kind: FinancialFlowKind.expense,
          amountCents: 30000,
          quoteId: 'quote-1',
        ),
        buildEntry(
          id: 'e2',
          kind: FinancialFlowKind.expense,
          amountCents: 20000,
          quoteId: 'quote-1',
        ),
      ];

      final summary = FinancialEventSummaryCalculator.calculate(
        'quote-1',
        entries,
      );

      expect(summary.totalIncomeCents, 0);
      expect(summary.totalExpenseCents, 50000);
      expect(summary.profitCents, -50000);
    });

    test('profitCents is income minus expense for mixed entries', () {
      final entries = [
        buildEntry(
          id: 'income',
          kind: FinancialFlowKind.income,
          amountCents: 200000,
          quoteId: 'quote-1',
        ),
        buildEntry(
          id: 'expense',
          kind: FinancialFlowKind.expense,
          amountCents: 120000,
          quoteId: 'quote-1',
        ),
      ];

      final summary = FinancialEventSummaryCalculator.calculate(
        'quote-1',
        entries,
      );

      expect(summary.profitCents, 80000);
      expect(summary.hasEntries, isTrue);
    });

    test('profitCents is negative when expenses exceed income', () {
      final entries = [
        buildEntry(
          id: 'income',
          kind: FinancialFlowKind.income,
          amountCents: 50000,
          quoteId: 'quote-1',
        ),
        buildEntry(
          id: 'expense',
          kind: FinancialFlowKind.expense,
          amountCents: 90000,
          quoteId: 'quote-1',
        ),
      ];

      final summary = FinancialEventSummaryCalculator.calculate(
        'quote-1',
        entries,
      );

      expect(summary.profitCents, -40000);
    });

    test('ignores entries linked to a different quote (no cross-event leakage)', () {
      final entries = [
        buildEntry(
          id: 'own',
          kind: FinancialFlowKind.income,
          amountCents: 100000,
          quoteId: 'quote-1',
        ),
        buildEntry(
          id: 'other-event',
          kind: FinancialFlowKind.income,
          amountCents: 999999,
          quoteId: 'quote-2',
        ),
      ];

      final summary = FinancialEventSummaryCalculator.calculate(
        'quote-1',
        entries,
      );

      expect(summary.entries, hasLength(1));
      expect(summary.entries.single.id, 'own');
      expect(summary.totalIncomeCents, 100000);
    });

    test('ignores entries with no event association (quoteId == null)', () {
      final entries = [
        buildEntry(
          id: 'linked',
          kind: FinancialFlowKind.expense,
          amountCents: 10000,
          quoteId: 'quote-1',
        ),
        buildEntry(
          id: 'unlinked',
          kind: FinancialFlowKind.expense,
          amountCents: 999999,
        ),
      ];

      final summary = FinancialEventSummaryCalculator.calculate(
        'quote-1',
        entries,
      );

      expect(summary.entries, hasLength(1));
      expect(summary.totalExpenseCents, 10000);
    });

    test('entries are returned sorted by date regardless of input order', () {
      final entries = [
        buildEntry(
          id: 'later',
          kind: FinancialFlowKind.expense,
          amountCents: 1000,
          date: DateTime(2026, 8, 20),
          quoteId: 'quote-1',
        ),
        buildEntry(
          id: 'earlier',
          kind: FinancialFlowKind.income,
          amountCents: 2000,
          date: DateTime(2026, 8, 5),
          quoteId: 'quote-1',
        ),
      ];

      final summary = FinancialEventSummaryCalculator.calculate(
        'quote-1',
        entries,
      );

      expect(summary.entries.map((entry) => entry.id).toList(), [
        'earlier',
        'later',
      ]);
    });
  });
}
