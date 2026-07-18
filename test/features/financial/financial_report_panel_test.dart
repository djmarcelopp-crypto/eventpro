import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_entry_status.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/providers/financial_report_query_provider.dart';
import 'package:eventpro/features/financial/models/financial_report_period.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'financial_test_helpers.dart';

void main() {
  final createdAt = DateTime(2026, 1, 1);

  FinancialEntry buildEntry({
    required String id,
    required String description,
    required DateTime date,
    FinancialFlowKind kind = FinancialFlowKind.expense,
    String categoryId = 'cat-expense',
    int amountCents = 10000,
    FinancialEntryStatus status = FinancialEntryStatus.pending,
  }) {
    return FinancialEntry(
      id: id,
      kind: kind,
      description: description,
      amountCents: amountCents,
      date: date,
      categoryId: categoryId,
      status: status,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
  }

  testWidgets('shows period report panel with month preset indicators', (
    tester,
  ) async {
    await pumpFinancialApp(
      tester,
      clock: () => DateTime(2026, 8, 17),
      entries: [
        buildEntry(
          id: 'income',
          description: 'Receita ago',
          date: DateTime(2026, 8, 5),
          kind: FinancialFlowKind.income,
          categoryId: 'cat-income',
          amountCents: 200000,
          status: FinancialEntryStatus.paid,
        ),
        buildEntry(
          id: 'expense',
          description: 'Despesa ago',
          date: DateTime(2026, 8, 10),
          amountCents: 50000,
        ),
      ],
    );

    expect(find.byKey(const Key('financial_report_panel')), findsOneWidget);
    expect(find.byKey(const Key('financial_report_income')), findsOneWidget);
    expect(find.byKey(const Key('financial_report_expense')), findsOneWidget);
    expect(find.byKey(const Key('financial_report_balance')), findsOneWidget);
    expect(find.byKey(const Key('financial_report_entry_count')), findsOneWidget);
    expect(
      find.byKey(const Key('financial_report_pending_count')),
      findsOneWidget,
    );
    expect(find.textContaining('Lançamentos'), findsWidgets);
    expect(find.text('2'), findsWidgets);
    expect(find.text('1'), findsWidgets); // pending count
    expect(find.text('Por categoria'), findsOneWidget);
    expect(find.byKey(const Key('financial_report_monthly_table')), findsOneWidget);
  });

  testWidgets('switches report to year preset from the panel', (tester) async {
    final container = await pumpFinancialApp(
      tester,
      clock: () => DateTime(2026, 8, 17),
      entries: [
        buildEntry(
          id: 'jul',
          description: 'Julho',
          date: DateTime(2026, 7, 5),
          amountCents: 10000,
        ),
        buildEntry(
          id: 'aug',
          description: 'Agosto',
          date: DateTime(2026, 8, 5),
          amountCents: 20000,
        ),
      ],
    );

    await tester.tap(find.byKey(const Key('financial_report_preset_year')));
    await tester.pumpAndSettle();

    expect(
      container.read(financialReportQueryProvider).kind,
      FinancialReportPeriodKind.currentYear,
    );
    expect(find.textContaining('01/01/2026'), findsOneWidget);
    expect(find.textContaining('31/12/2026'), findsOneWidget);
  });
}
