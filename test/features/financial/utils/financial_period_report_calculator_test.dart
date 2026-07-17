import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_entry_status.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/models/financial_report_period.dart';
import 'package:eventpro/features/financial/utils/financial_period_report_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialPeriodReportCalculator', () {
    final createdAt = DateTime(2026, 1, 1);
    final categories = [
      FinancialCategory(
        id: 'cat-income',
        name: 'Eventos',
        kind: FinancialFlowKind.income,
        createdAt: createdAt,
      ),
      FinancialCategory(
        id: 'cat-expense',
        name: 'Locação',
        kind: FinancialFlowKind.expense,
        createdAt: createdAt,
      ),
      FinancialCategory(
        id: 'cat-expense-2',
        name: 'Buffet',
        kind: FinancialFlowKind.expense,
        createdAt: createdAt,
      ),
    ];

    FinancialEntry entry({
      required String id,
      required FinancialFlowKind kind,
      required int amountCents,
      required DateTime date,
      required String categoryId,
      FinancialEntryStatus status = FinancialEntryStatus.paid,
    }) {
      return FinancialEntry(
        id: id,
        kind: kind,
        description: id,
        amountCents: amountCents,
        date: date,
        categoryId: categoryId,
        status: status,
        createdAt: createdAt,
        updatedAt: createdAt,
      );
    }

    final period = FinancialReportPeriod(
      kind: FinancialReportPeriodKind.custom,
      start: DateTime(2026, 7, 1),
      end: DateTime(2026, 9, 30),
    );

    final entries = [
      entry(
        id: 'jun',
        kind: FinancialFlowKind.income,
        amountCents: 999999,
        date: DateTime(2026, 6, 30),
        categoryId: 'cat-income',
      ),
      entry(
        id: 'jul-income',
        kind: FinancialFlowKind.income,
        amountCents: 200000,
        date: DateTime(2026, 7, 10),
        categoryId: 'cat-income',
      ),
      entry(
        id: 'aug-expense',
        kind: FinancialFlowKind.expense,
        amountCents: 50000,
        date: DateTime(2026, 8, 5),
        categoryId: 'cat-expense',
        status: FinancialEntryStatus.pending,
      ),
      entry(
        id: 'aug-expense-2',
        kind: FinancialFlowKind.expense,
        amountCents: 30000,
        date: DateTime(2026, 8, 20),
        categoryId: 'cat-expense-2',
      ),
      entry(
        id: 'sep-income',
        kind: FinancialFlowKind.income,
        amountCents: 100000,
        date: DateTime(2026, 9, 1),
        categoryId: 'cat-income',
        status: FinancialEntryStatus.pending,
      ),
      entry(
        id: 'oct',
        kind: FinancialFlowKind.expense,
        amountCents: 1000,
        date: DateTime(2026, 10, 1),
        categoryId: 'cat-expense',
      ),
    ];

    test('aggregates indicators reusing the global summary calculator', () {
      final report = FinancialPeriodReportCalculator.calculate(
        period: period,
        entries: entries,
        categories: categories,
      );

      expect(report.totalIncomeCents, 300000);
      expect(report.totalExpenseCents, 80000);
      expect(report.balanceCents, 220000);
      expect(report.entryCount, 4);
      expect(report.pendingEntryCount, 2);
      expect(report.pendingCents, 150000);
    });

    test('builds category totals sorted by amount descending', () {
      final report = FinancialPeriodReportCalculator.calculate(
        period: period,
        entries: entries,
        categories: categories,
      );

      expect(
        report.categoryTotals.map((total) => total.categoryId).toList(),
        ['cat-income', 'cat-expense', 'cat-expense-2'],
      );
      expect(report.categoryTotals.first.totalCents, 300000);
      expect(report.categoryTotals.first.entryCount, 2);
      expect(report.categoryTotals[1].totalCents, 50000);
      expect(report.categoryTotals[2].totalCents, 30000);
    });

    test('builds monthly evolution covering every month in the period', () {
      final report = FinancialPeriodReportCalculator.calculate(
        period: period,
        entries: entries,
        categories: categories,
      );

      expect(report.monthlyEvolution, hasLength(3));
      expect(report.monthlyEvolution[0].month, 7);
      expect(report.monthlyEvolution[0].incomeCents, 200000);
      expect(report.monthlyEvolution[0].expenseCents, 0);
      expect(report.monthlyEvolution[1].month, 8);
      expect(report.monthlyEvolution[1].incomeCents, 0);
      expect(report.monthlyEvolution[1].expenseCents, 80000);
      expect(report.monthlyEvolution[1].balanceCents, -80000);
      expect(report.monthlyEvolution[2].month, 9);
      expect(report.monthlyEvolution[2].incomeCents, 100000);
    });

    test('returns zeroed report when no entries fall in the period', () {
      final report = FinancialPeriodReportCalculator.calculate(
        period: FinancialReportPeriod(
          kind: FinancialReportPeriodKind.custom,
          start: DateTime(2025, 1, 1),
          end: DateTime(2025, 1, 31),
        ),
        entries: entries,
        categories: categories,
      );

      expect(report.entryCount, 0);
      expect(report.totalIncomeCents, 0);
      expect(report.categoryTotals, isEmpty);
      expect(report.monthlyEvolution, hasLength(1));
      expect(report.monthlyEvolution.single.balanceCents, 0);
    });
  });
}
