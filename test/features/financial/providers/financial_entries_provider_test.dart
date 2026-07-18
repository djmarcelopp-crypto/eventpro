import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_entry_status.dart';
import 'package:eventpro/features/financial/models/financial_entry_write_result.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/providers/financial_entries_provider.dart';
import 'package:eventpro/features/financial/providers/financial_entry_filters_provider.dart';
import 'package:eventpro/features/financial/providers/financial_filtered_entries_provider.dart';
import 'package:eventpro/features/financial/providers/financial_global_summary_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_financial_category_repository.dart';
import '../fakes/fake_financial_entry_repository.dart';
import '../fakes/financial_repository_test_overrides.dart';

void main() {
  group('FinancialEntriesNotifier and summary providers', () {
    late FakeFinancialEntryRepository entryRepository;
    late FakeFinancialCategoryRepository categoryRepository;
    late ProviderContainer container;
    final fixedNow = DateTime(2030, 1, 1, 12);

    FinancialCategory buildCategory({
      String id = 'cat-expense',
      FinancialFlowKind kind = FinancialFlowKind.expense,
    }) {
      return FinancialCategory(
        id: id,
        name: 'Categoria $id',
        kind: kind,
        createdAt: fixedNow,
      );
    }

    FinancialEntry buildDraft({
      String description = 'Aluguel',
      int amountCents = 10000,
      FinancialFlowKind kind = FinancialFlowKind.expense,
      String categoryId = 'cat-expense',
      FinancialEntryStatus status = FinancialEntryStatus.pending,
      DateTime? date,
    }) {
      return FinancialEntry(
        id: '',
        kind: kind,
        description: description,
        amountCents: amountCents,
        date: date ?? DateTime(2026, 8, 5),
        categoryId: categoryId,
        status: status,
        createdAt: fixedNow,
        updatedAt: fixedNow,
      );
    }

    setUp(() async {
      entryRepository = FakeFinancialEntryRepository();
      categoryRepository = FakeFinancialCategoryRepository(
        initialCategories: [
          buildCategory(),
          buildCategory(id: 'cat-income', kind: FinancialFlowKind.income),
        ],
      );
      container = ProviderContainer(
        overrides: financialRepositoryOverrides(
          entryRepository: entryRepository,
          categoryRepository: categoryRepository,
          clock: () => fixedNow,
        ),
      );
      await container.read(financialEntriesProvider.future);
    });

    tearDown(() {
      container.dispose();
    });

    test('addEntry persists via service and updates summary', () async {
      final result = await container
          .read(financialEntriesProvider.notifier)
          .addEntry(buildDraft(amountCents: 15000));

      expect(result.isSuccess, isTrue);
      final entries = container.read(financialEntriesProvider).value!;
      expect(entries, hasLength(1));

      final summary = container.read(financialGlobalSummaryProvider).value!;
      expect(summary.totalExpenseCents, 15000);
      expect(summary.pendingCents, 15000);
      expect(summary.balanceCents, -15000);
    });

    test('rejects incompatible category kind without mutating state', () async {
      final result = await container
          .read(financialEntriesProvider.notifier)
          .addEntry(
            buildDraft(
              kind: FinancialFlowKind.income,
              categoryId: 'cat-expense',
            ),
          );

      expect(
        result.status,
        FinancialEntryWriteStatus.categoryKindMismatch,
      );
      expect(container.read(financialEntriesProvider).value, isEmpty);
    });

    test('fills paidAt from clock when creating as paid', () async {
      final result = await container
          .read(financialEntriesProvider.notifier)
          .addEntry(buildDraft(status: FinancialEntryStatus.paid));

      expect(result.entry!.paidAt, fixedNow);
    });

    test('deleteEntry removes from state and refreshes summary', () async {
      final created = await container
          .read(financialEntriesProvider.notifier)
          .addEntry(buildDraft());
      final id = created.entry!.id;

      final deleted = await container
          .read(financialEntriesProvider.notifier)
          .deleteEntry(id);

      expect(deleted.isDeleted, isTrue);
      expect(container.read(financialEntriesProvider).value, isEmpty);
      final summary = container.read(financialGlobalSummaryProvider).value!;
      expect(summary.totalIncomeCents, 0);
      expect(summary.totalExpenseCents, 0);
      expect(summary.pendingCents, 0);
      expect(summary.balanceCents, 0);
    });

    test('filters narrow the derived entry list and summary', () async {
      await container.read(financialEntriesProvider.notifier).addEntry(
            buildDraft(
              description: 'Receita',
              kind: FinancialFlowKind.income,
              categoryId: 'cat-income',
              amountCents: 50000,
              status: FinancialEntryStatus.paid,
            ),
          );
      await container.read(financialEntriesProvider.notifier).addEntry(
            buildDraft(description: 'Despesa', amountCents: 10000),
          );

      container
          .read(financialEntryFiltersProvider.notifier)
          .setKind(FinancialFlowKind.income);

      final filtered =
          container.read(financialFilteredEntriesProvider).value!;
      expect(filtered, hasLength(1));
      expect(filtered.single.description, 'Receita');

      final summary = container.read(financialGlobalSummaryProvider).value!;
      expect(summary.totalIncomeCents, 50000);
      expect(summary.totalExpenseCents, 0);
      expect(summary.balanceCents, 50000);
    });
  });
}
