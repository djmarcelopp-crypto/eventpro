import 'package:eventpro/features/equipment/equipment_categories_screen.dart';
import 'package:eventpro/features/equipment/equipment_detail_screen.dart';
import 'package:eventpro/features/equipment/equipment_screen.dart';
import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:eventpro/features/equipment/models/quote_equipment.dart';
import 'package:eventpro/features/equipment/new_equipment_screen.dart';
import 'package:eventpro/features/equipment/providers/equipment_category_provider.dart';
import 'package:eventpro/features/equipment/providers/equipment_provider.dart';
import 'package:eventpro/features/equipment/providers/quote_equipment_provider.dart';
import 'package:eventpro/features/equipment/quote_equipment_screen.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:eventpro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'fakes/equipment_repository_test_overrides.dart';
import 'fakes/fake_equipment_category_repository.dart';
import 'fakes/fake_equipment_repository.dart';
import 'fakes/fake_quote_equipment_repository.dart';
import '../quotes/fakes/fake_quote_repository.dart';

Quote buildTestQuote({String id = 'quote-1'}) {
  final now = DateTime(2026, 7, 13, 10);
  return Quote(
    id: id,
    number: 'ORC-001',
    status: QuoteStatus.draft,
    clientSnapshot: const QuoteClientSnapshot(
      sourceClientId: 'client-1',
      type: QuoteClientType.individual,
      displayName: 'Maria Silva',
      phone: '67999998888',
    ),
    eventSnapshot: const QuoteEventSnapshot(
      name: 'Casamento',
      date: null,
      guestCount: 100,
    ),
    items: const [],
    subtotalCents: 0,
    discountCents: 0,
    freightCents: 0,
    totalCents: 0,
    statusHistory: [
      QuoteStatusHistoryEntry(
        previousStatus: null,
        newStatus: QuoteStatus.draft,
        changedAt: now,
      ),
    ],
    createdAt: now,
    updatedAt: now,
  );
}

EquipmentCategory buildTestCategory({
  String id = 'cat-sound',
  String name = 'Som',
  bool active = true,
}) {
  final now = DateTime(2026, 1, 1);
  return EquipmentCategory(
    id: id,
    name: name,
    active: active,
    createdAt: now,
    updatedAt: now,
  );
}

Equipment buildTestEquipment({
  String id = 'eq-1',
  String name = 'Caixa de som',
  String categoryId = 'cat-sound',
  int totalQuantity = 2,
  EquipmentStatus status = EquipmentStatus.available,
}) {
  final now = DateTime(2026, 1, 1);
  return Equipment(
    id: id,
    name: name,
    categoryId: categoryId,
    totalQuantity: totalQuantity,
    status: status,
    createdAt: now,
    updatedAt: now,
  );
}

Future<ProviderContainer> pumpEquipmentApp(
  WidgetTester tester, {
  List<Equipment> equipment = const [],
  List<EquipmentCategory>? categories,
  List<Quote> quotes = const [],
  List<QuoteEquipment> quoteEquipment = const [],
  String initialLocation = '/equipment',
  List<Override> extraOverrides = const [],
  FakeEquipmentRepository? equipmentRepository,
  FakeEquipmentCategoryRepository? categoryRepository,
  FakeQuoteEquipmentRepository? quoteEquipmentRepository,
  FakeQuoteRepository? quoteRepository,
  DateTime Function()? clock,
  bool awaitEquipment = true,
}) async {
  final resolvedCategories =
      categories ?? [buildTestCategory()];

  final equipmentRepo =
      equipmentRepository ??
      FakeEquipmentRepository(initialEquipment: equipment);
  final categoryRepo =
      categoryRepository ??
      FakeEquipmentCategoryRepository(initialCategories: resolvedCategories);
  final quoteEquipmentRepo =
      quoteEquipmentRepository ??
      FakeQuoteEquipmentRepository(initialItems: quoteEquipment);
  final quoteRepo =
      quoteRepository ?? FakeQuoteRepository(initialQuotes: quotes);

  final container = ProviderContainer(
    overrides: [
      ...equipmentRepositoryOverrides(
        equipmentRepository: equipmentRepo,
        categoryRepository: categoryRepo,
        quoteEquipmentRepository: quoteEquipmentRepo,
        quoteRepository: quoteRepo,
        clock: clock ?? () => DateTime(2030, 1, 1, 12),
      ),
      ...extraOverrides,
    ],
  );

  if (awaitEquipment) {
    await container.read(equipmentProvider.future);
  }
  await container.read(equipmentCategoryProvider.future);
  if (initialLocation.contains('/equipment') &&
      initialLocation.startsWith('/quotes/')) {
    final quoteId = initialLocation.split('/')[2];
    await container.read(quoteEquipmentProvider(quoteId).future);
  }

  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/equipment',
        builder: (context, state) => const EquipmentScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const NewEquipmentScreen(),
          ),
          GoRoute(
            path: 'categories',
            builder: (context, state) => const EquipmentCategoriesScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => EquipmentDetailScreen(
              equipmentId: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => NewEquipmentScreen(
                  equipmentId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/quotes/:id/equipment',
        builder: (context, state) => QuoteEquipmentScreen(
          quoteId: state.pathParameters['id']!,
        ),
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
  await tester.pumpAndSettle();

  addTearDown(container.dispose);
  return container;
}

Future<void> warmQuoteEquipment(
  ProviderContainer container,
  String quoteId,
) async {
  await container.read(quoteEquipmentProvider(quoteId).future);
}
