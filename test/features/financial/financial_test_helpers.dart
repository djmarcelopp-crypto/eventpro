import 'package:eventpro/features/financial/financial_categories_screen.dart';
import 'package:eventpro/features/financial/financial_entry_detail_screen.dart';
import 'package:eventpro/features/financial/financial_screen.dart';
import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/new_financial_entry_screen.dart';
import 'package:eventpro/features/financial/providers/financial_categories_provider.dart';
import 'package:eventpro/features/financial/providers/financial_entries_provider.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';
import 'package:eventpro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'fakes/fake_financial_category_repository.dart';
import 'fakes/fake_financial_entry_repository.dart';
import 'fakes/financial_repository_test_overrides.dart';

Future<ProviderContainer> pumpFinancialApp(
  WidgetTester tester, {
  List<FinancialEntry> entries = const [],
  List<FinancialCategory>? categories,
  List<Quote> quotes = const [],
  String initialLocation = '/financial',
  List<Override> extraOverrides = const [],
  FakeFinancialEntryRepository? entryRepository,
  FakeFinancialCategoryRepository? categoryRepository,
  DateTime Function()? clock,
  bool awaitEntries = true,
}) async {
  final resolvedCategories =
      categories ??
      [
        FinancialCategory(
          id: 'cat-expense',
          name: 'Locação',
          kind: FinancialFlowKind.expense,
          createdAt: DateTime(2026, 1, 1),
        ),
        FinancialCategory(
          id: 'cat-income',
          name: 'Eventos',
          kind: FinancialFlowKind.income,
          createdAt: DateTime(2026, 1, 1),
        ),
      ];

  final entryRepo =
      entryRepository ??
      FakeFinancialEntryRepository(initialEntries: entries);
  final categoryRepo =
      categoryRepository ??
      FakeFinancialCategoryRepository(initialCategories: resolvedCategories);

  final container = ProviderContainer(
    overrides: [
      ...financialRepositoryOverrides(
        entryRepository: entryRepo,
        categoryRepository: categoryRepo,
        clock: clock ?? () => DateTime(2030, 1, 1, 12),
      ),
      ...extraOverrides,
    ],
  );

  if (awaitEntries) {
    await container.read(financialEntriesProvider.future);
  }
  await container.read(financialCategoriesProvider.future);
  container.read(quotesProvider.notifier).hydrate(quotes);

  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/financial',
        builder: (context, state) => const FinancialScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const NewFinancialEntryScreen(),
          ),
          GoRoute(
            path: 'categories',
            builder: (context, state) => const FinancialCategoriesScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => FinancialEntryDetailScreen(
              entryId: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => NewFinancialEntryScreen(
                  entryId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  await tester.binding.setSurfaceSize(const Size(1280, 900));
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        scaffoldMessengerKey: EventProApp.scaffoldMessengerKey,
        locale: const Locale('pt', 'BR'),
        routerConfig: router,
      ),
    ),
  );
  if (awaitEntries) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
  return container;
}
