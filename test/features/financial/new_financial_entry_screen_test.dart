import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/new_financial_entry_screen.dart';
import 'package:eventpro/features/financial/providers/financial_categories_provider.dart';
import 'package:eventpro/features/financial/providers/financial_entries_provider.dart';
import 'package:eventpro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_financial_category_repository.dart';
import 'fakes/fake_financial_entry_repository.dart';
import 'fakes/financial_repository_test_overrides.dart';

void main() {
  testWidgets('saves a new entry without navigating away on success', (
    tester,
  ) async {
    final entryRepository = FakeFinancialEntryRepository();
    final categoryRepository = FakeFinancialCategoryRepository(
      initialCategories: [
        FinancialCategory(
          id: 'cat-expense',
          name: 'Locação',
          kind: FinancialFlowKind.expense,
          createdAt: DateTime(2026, 1, 1),
        ),
      ],
    );
    final container = ProviderContainer(
      overrides: financialRepositoryOverrides(
        entryRepository: entryRepository,
        categoryRepository: categoryRepository,
        clock: () => DateTime(2030, 1, 1, 12),
      ),
    );
    addTearDown(container.dispose);

    await container.read(financialEntriesProvider.future);
    await container.read(financialCategoriesProvider.future);

    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          scaffoldMessengerKey: EventProApp.scaffoldMessengerKey,
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: TextButton(
                    key: const Key('open_form'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<bool>(
                          builder: (_) => const NewFinancialEntryScreen(),
                        ),
                      );
                    },
                    child: const Text('Abrir'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open_form')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('financial_entry_description')),
      'Buffet do evento',
    );
    await tester.enterText(
      find.byKey(const Key('financial_entry_amount')),
      '15000',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('financial_entry_category')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Locação').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('financial_entry_save_button')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(container.read(financialEntriesProvider).value, hasLength(1));
    expect(
      container.read(financialEntriesProvider).value!.single.description,
      'Buffet do evento',
    );
  });
}
