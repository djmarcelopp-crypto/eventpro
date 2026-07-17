import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/models/financial_report_period.dart';
import 'package:eventpro/features/financial/providers/financial_categories_provider.dart';
import 'package:eventpro/features/financial/providers/financial_entries_provider.dart';
import 'package:eventpro/features/financial/providers/financial_period_report_provider.dart';
import 'package:eventpro/features/financial/providers/financial_report_query_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_financial_category_repository.dart';
import '../fakes/fake_financial_entry_repository.dart';
import '../fakes/financial_repository_test_overrides.dart';

void main() {
  group('financialPeriodReportProvider', () {
    late ProviderContainer container;
    final fixedNow = DateTime(2026, 8, 17, 12);
    final createdAt = DateTime(2026, 1, 1);

    setUp(() async {
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
      ];
      final entries = [
        FinancialEntry(
          id: 'e1',
          kind: FinancialFlowKind.income,
          description: 'Receita ago',
          amountCents: 100000,
          date: DateTime(2026, 8, 5),
          categoryId: 'cat-income',
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
        FinancialEntry(
          id: 'e2',
          kind: FinancialFlowKind.expense,
          description: 'Despesa jul',
          amountCents: 40000,
          date: DateTime(2026, 7, 10),
          categoryId: 'cat-expense',
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
      ];

      container = ProviderContainer(
        overrides: financialRepositoryOverrides(
          entryRepository: FakeFinancialEntryRepository(initialEntries: entries),
          categoryRepository: FakeFinancialCategoryRepository(
            initialCategories: categories,
          ),
          clock: () => fixedNow,
        ),
      );
      await container.read(financialEntriesProvider.future);
      await container.read(financialCategoriesProvider.future);
    });

    tearDown(() => container.dispose());

    test('defaults to current month using the injectable clock', () {
      final report = container.read(financialPeriodReportProvider).value!;

      expect(report.period.kind, FinancialReportPeriodKind.currentMonth);
      expect(report.period.start, DateTime(2026, 8, 1));
      expect(report.entryCount, 1);
      expect(report.totalIncomeCents, 100000);
      expect(report.totalExpenseCents, 0);
    });

    test('switches to current year and includes prior months', () {
      container
          .read(financialReportQueryProvider.notifier)
          .selectPreset(FinancialReportPeriodKind.currentYear);

      final report = container.read(financialPeriodReportProvider).value!;

      expect(report.period.kind, FinancialReportPeriodKind.currentYear);
      expect(report.entryCount, 2);
      expect(report.totalIncomeCents, 100000);
      expect(report.totalExpenseCents, 40000);
      expect(report.monthlyEvolution, hasLength(12));
    });

    test('applies a custom period', () {
      container.read(financialReportQueryProvider.notifier).setCustomPeriod(
            start: DateTime(2026, 7, 1),
            end: DateTime(2026, 7, 31),
          );

      final report = container.read(financialPeriodReportProvider).value!;

      expect(report.period.kind, FinancialReportPeriodKind.custom);
      expect(report.entryCount, 1);
      expect(report.totalExpenseCents, 40000);
      expect(report.categoryTotals.single.categoryName, 'Locação');
    });
  });
}
