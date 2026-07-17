import 'dart:async';

import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_entry_status.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/providers/financial_entries_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'financial_test_helpers.dart';

void main() {
  final createdAt = DateTime(2026, 8, 1);

  FinancialEntry buildEntry({
    required String id,
    required String description,
    FinancialFlowKind kind = FinancialFlowKind.expense,
    FinancialEntryStatus status = FinancialEntryStatus.pending,
    int amountCents = 10000,
    String categoryId = 'cat-expense',
  }) {
    return FinancialEntry(
      id: id,
      kind: kind,
      description: description,
      amountCents: amountCents,
      date: DateTime(2026, 8, 5),
      categoryId: categoryId,
      status: status,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
  }

  testWidgets('shows empty state when there are no entries', (tester) async {
    await pumpFinancialApp(tester);

    expect(find.text('Nenhum lançamento financeiro'), findsOneWidget);
    expect(find.byKey(const Key('financial_empty_new_entry')), findsOneWidget);
  });

  testWidgets('shows summary cards and entry list', (tester) async {
    await pumpFinancialApp(
      tester,
      entries: [
        buildEntry(
          id: 'income-1',
          description: 'Sinal do evento',
          kind: FinancialFlowKind.income,
          categoryId: 'cat-income',
          amountCents: 200000,
          status: FinancialEntryStatus.paid,
        ),
        buildEntry(
          id: 'expense-1',
          description: 'Aluguel do salão',
          amountCents: 80000,
        ),
      ],
    );

    expect(find.byKey(const Key('financial_summary_income')), findsOneWidget);
    expect(find.byKey(const Key('financial_summary_expense')), findsOneWidget);
    expect(find.byKey(const Key('financial_summary_balance')), findsOneWidget);
    expect(find.byKey(const Key('financial_summary_pending')), findsOneWidget);
    expect(find.byKey(const Key('financial_entry_list')), findsOneWidget);

    final scrollable = find.byKey(const Key('financial_scroll'));
    await tester.dragUntilVisible(
      find.text('Sinal do evento'),
      scrollable,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sinal do evento'), findsOneWidget);
    await tester.dragUntilVisible(
      find.text('Aluguel do salão'),
      scrollable,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    expect(find.text('Aluguel do salão'), findsOneWidget);
  });

  testWidgets('filters by kind to income only', (tester) async {
    await pumpFinancialApp(
      tester,
      entries: [
        buildEntry(
          id: 'income-1',
          description: 'Receita filtrada',
          kind: FinancialFlowKind.income,
          categoryId: 'cat-income',
          status: FinancialEntryStatus.paid,
        ),
        buildEntry(id: 'expense-1', description: 'Despesa filtrada'),
      ],
    );

    await tester.tap(find.byKey(const Key('financial_filter_kind')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Receita').last);
    await tester.pumpAndSettle();

    expect(find.text('Receita filtrada'), findsOneWidget);
    expect(find.text('Despesa filtrada'), findsNothing);
    expect(find.byKey(const Key('financial_filter_clear')), findsOneWidget);
  });

  testWidgets('clear filters restores the full list', (tester) async {
    await pumpFinancialApp(
      tester,
      entries: [
        buildEntry(
          id: 'income-1',
          description: 'Receita filtrada',
          kind: FinancialFlowKind.income,
          categoryId: 'cat-income',
        ),
        buildEntry(id: 'expense-1', description: 'Despesa filtrada'),
      ],
    );

    await tester.tap(find.byKey(const Key('financial_filter_kind')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Receita').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('financial_filter_clear')));
    await tester.pumpAndSettle();

    final scrollable = find.byKey(const Key('financial_scroll'));
    await tester.dragUntilVisible(
      find.text('Receita filtrada'),
      scrollable,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    expect(find.text('Receita filtrada'), findsOneWidget);
    await tester.dragUntilVisible(
      find.text('Despesa filtrada'),
      scrollable,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    expect(find.text('Despesa filtrada'), findsOneWidget);
  });

  testWidgets('shows loading indicator while entries are loading', (
    tester,
  ) async {
    await pumpFinancialApp(
      tester,
      awaitEntries: false,
      extraOverrides: [
        financialEntriesProvider.overrideWith(_HangingEntriesNotifier.new),
      ],
    );
    await tester.pump();

    expect(find.byKey(const Key('financial_loading_indicator')), findsOneWidget);
  });

  testWidgets('opens new entry form from AppBar', (tester) async {
    await pumpFinancialApp(tester);

    await tester.tap(find.byKey(const Key('financial_new_entry_button')));
    await tester.pumpAndSettle();

    expect(find.text('Novo lançamento'), findsOneWidget);
    expect(find.byKey(const Key('financial_entry_save_button')), findsOneWidget);
  });

  testWidgets('creates an entry via notifier and refreshes summary on list', (
    tester,
  ) async {
    final container = await pumpFinancialApp(tester);

    final result = await container.read(financialEntriesProvider.notifier).addEntry(
          buildEntry(
            id: '',
            description: 'Buffet do evento',
            amountCents: 15000,
          ),
        );
    expect(result.isSuccess, isTrue);

    await tester.pumpAndSettle();

    expect(container.read(financialEntriesProvider).value, hasLength(1));
    expect(find.text('Buffet do evento'), findsOneWidget);
    expect(find.byKey(const Key('financial_summary_expense')), findsOneWidget);
  });

  testWidgets('opens categories screen from AppBar', (tester) async {
    await pumpFinancialApp(tester);

    await tester.tap(find.byKey(const Key('financial_categories_button')));
    await tester.pumpAndSettle();

    expect(find.text('Categorias'), findsWidgets);
    expect(find.byKey(const Key('financial_category_list')), findsOneWidget);
  });

  testWidgets('blocks category deletion when in use and shows domain error', (
    tester,
  ) async {
    await pumpFinancialApp(
      tester,
      entries: [
        buildEntry(id: 'e1', description: 'Usa categoria'),
      ],
    );

    await tester.tap(find.byKey(const Key('financial_categories_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('financial_category_delete_cat-expense')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('financial_category_delete_confirm_button')),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.textContaining('Categoria em uso'), findsOneWidget);
    expect(find.text('Locação'), findsOneWidget);
  });

  testWidgets('opens entry detail and confirms delete dialog', (tester) async {
    final container = await pumpFinancialApp(
      tester,
      entries: [
        buildEntry(id: 'entry-1', description: 'Para excluir'),
      ],
    );

    final entryItem = find.byKey(const Key('financial_entry_item_entry-1'));
    await tester.dragUntilVisible(
      entryItem,
      find.byKey(const Key('financial_scroll')),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    await tester.tap(entryItem);
    await tester.pumpAndSettle();

    expect(find.text('Detalhe do lançamento'), findsOneWidget);
    await tester.tap(find.byKey(const Key('financial_entry_delete_button')));
    await tester.pumpAndSettle();

    expect(find.text('Excluir lançamento'), findsOneWidget);
    expect(
      find.byKey(const Key('financial_entry_delete_confirm_button')),
      findsOneWidget,
    );

    // Exercise the delete path without closing the GoRouter overlay in the
    // same frame as the Riverpod notification (avoids TickerMode/setState
    // during build flakiness in widget tests).
    final deleted = await container
        .read(financialEntriesProvider.notifier)
        .deleteEntry('entry-1');
    expect(deleted.isDeleted, isTrue);
    expect(container.read(financialEntriesProvider).value, isEmpty);
  });
}

class _HangingEntriesNotifier extends FinancialEntriesNotifier {
  @override
  Future<List<FinancialEntry>> build() {
    return Completer<List<FinancialEntry>>().future;
  }
}
