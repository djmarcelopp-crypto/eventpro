import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_entry_filters.dart';
import 'package:eventpro/features/financial/models/financial_entry_status.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/utils/financial_entry_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialEntryFilter', () {
    final createdAt = DateTime(2026, 8, 1);

    FinancialEntry buildEntry({
      required String id,
      required DateTime date,
      FinancialFlowKind kind = FinancialFlowKind.expense,
      FinancialEntryStatus status = FinancialEntryStatus.pending,
    }) {
      return FinancialEntry(
        id: id,
        kind: kind,
        description: id,
        amountCents: 1000,
        date: date,
        categoryId: 'cat',
        status: status,
        createdAt: createdAt,
        updatedAt: createdAt,
      );
    }

    final entries = [
      buildEntry(id: 'july', date: DateTime(2026, 7, 10)),
      buildEntry(
        id: 'aug-income',
        date: DateTime(2026, 8, 5),
        kind: FinancialFlowKind.income,
        status: FinancialEntryStatus.paid,
      ),
      buildEntry(id: 'aug-expense', date: DateTime(2026, 8, 20)),
      buildEntry(id: 'sep', date: DateTime(2026, 9, 1)),
    ];

    test('returns all entries when filters are empty', () {
      final result = FinancialEntryFilter.apply(
        entries,
        FinancialEntryFilters.empty,
      );

      expect(result.map((entry) => entry.id), [
        'july',
        'aug-income',
        'aug-expense',
        'sep',
      ]);
    });

    test('filters by inclusive period', () {
      final result = FinancialEntryFilter.apply(
        entries,
        FinancialEntryFilters(
          periodStart: DateTime(2026, 8, 1),
          periodEnd: DateTime(2026, 8, 31),
        ),
      );

      expect(result.map((entry) => entry.id), ['aug-income', 'aug-expense']);
    });

    test('filters by kind', () {
      final result = FinancialEntryFilter.apply(
        entries,
        const FinancialEntryFilters(kind: FinancialFlowKind.income),
      );

      expect(result.map((entry) => entry.id), ['aug-income']);
    });

    test('filters by status', () {
      final result = FinancialEntryFilter.apply(
        entries,
        const FinancialEntryFilters(status: FinancialEntryStatus.paid),
      );

      expect(result.map((entry) => entry.id), ['aug-income']);
    });

    test('combines period, kind and status', () {
      final result = FinancialEntryFilter.apply(
        entries,
        FinancialEntryFilters(
          periodStart: DateTime(2026, 8, 1),
          periodEnd: DateTime(2026, 8, 31),
          kind: FinancialFlowKind.expense,
          status: FinancialEntryStatus.pending,
        ),
      );

      expect(result.map((entry) => entry.id), ['aug-expense']);
    });
  });
}
