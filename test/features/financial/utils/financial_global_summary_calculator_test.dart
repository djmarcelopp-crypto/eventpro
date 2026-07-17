import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_entry_status.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/utils/financial_global_summary_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialGlobalSummaryCalculator', () {
    final createdAt = DateTime(2026, 8, 1);

    FinancialEntry buildEntry({
      required String id,
      required FinancialFlowKind kind,
      required int amountCents,
      FinancialEntryStatus status = FinancialEntryStatus.paid,
    }) {
      return FinancialEntry(
        id: id,
        kind: kind,
        description: id,
        amountCents: amountCents,
        date: DateTime(2026, 8, 5),
        categoryId: 'cat',
        status: status,
        createdAt: createdAt,
        updatedAt: createdAt,
      );
    }

    test('returns zeros for an empty list', () {
      final summary = FinancialGlobalSummaryCalculator.calculate(const []);

      expect(summary.totalIncomeCents, 0);
      expect(summary.totalExpenseCents, 0);
      expect(summary.balanceCents, 0);
      expect(summary.pendingCents, 0);
    });

    test('aggregates income, expense, balance and pending', () {
      final summary = FinancialGlobalSummaryCalculator.calculate([
        buildEntry(
          id: 'i1',
          kind: FinancialFlowKind.income,
          amountCents: 200000,
        ),
        buildEntry(
          id: 'i2',
          kind: FinancialFlowKind.income,
          amountCents: 50000,
          status: FinancialEntryStatus.pending,
        ),
        buildEntry(
          id: 'e1',
          kind: FinancialFlowKind.expense,
          amountCents: 80000,
        ),
        buildEntry(
          id: 'e2',
          kind: FinancialFlowKind.expense,
          amountCents: 20000,
          status: FinancialEntryStatus.pending,
        ),
      ]);

      expect(summary.totalIncomeCents, 250000);
      expect(summary.totalExpenseCents, 100000);
      expect(summary.balanceCents, 150000);
      expect(summary.pendingCents, 70000);
    });
  });
}
