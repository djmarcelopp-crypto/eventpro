import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_detail_screen.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_screen.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';
import 'package:eventpro/features/catalog/providers/catalog_image_services_provider.dart';
import 'package:eventpro/features/catalog/providers/catalog_provider.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';
import 'package:eventpro/main.dart';

import '../quotes/fakes/quote_repository_test_overrides.dart';
import '../quotes/quotes_test_helpers.dart';
import 'fakes/catalog_repository_test_overrides.dart';
import 'fakes/fake_catalog_image_storage_service.dart';
import 'utils/catalog_package_dependency_checker_test.dart';

void main() {
  Future<ProviderContainer> pumpDetailWithRouter(
    WidgetTester tester, {
    required List<CatalogItem> items,
    FakeCatalogImageStorageService? storage,
    String initialLocation = '/catalog/eq-1',
  }) async {
    final fakeStorage = storage ?? FakeCatalogImageStorageService();
    final container = ProviderContainer(
      overrides: [
        ...catalogRepositoryOverrides(),
        catalogImageStorageProvider.overrideWithValue(fakeStorage),
      ],
    );

    for (final item in items) {
      await container.read(catalogProvider.notifier).addItem(item);
    }

    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/catalog',
          builder: (context, state) => const CatalogScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => CatalogItemDetailScreen(
                itemId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          scaffoldMessengerKey: EventProApp.scaffoldMessengerKey,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> openDeleteDialog(WidgetTester tester) async {
    final button = find.byKey(const Key('catalog_permanent_delete_button'));
    await tester.scrollUntilVisible(button, 500);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  CatalogItem service({String id = 'svc-1', String name = 'DJ Premium'}) {
    return CatalogItem.fromForm(
      type: CatalogItemType.service,
      name: name,
      category: CatalogCategory.dj,
      unit: 'Evento',
      price: 2500,
      id: id,
      createdAt: DateTime(2024, 1, 1),
    );
  }

  group('CatalogItemDetailScreen permanent delete', () {
    testWidgets('exibe área destrutiva separada', (tester) async {
      await pumpDetailWithRouter(tester, items: [equipment()]);

      expect(
        find.byKey(const Key('catalog_destructive_delete_section')),
        findsOneWidget,
      );
      expect(
        find.textContaining('prefira desativar'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('catalog_permanent_delete_button')), findsOneWidget);
    });

    testWidgets('nome incorreto mantém botão de confirmação desabilitado', (
      tester,
    ) async {
      await pumpDetailWithRouter(tester, items: [equipment()]);

      await openDeleteDialog(tester);

      final confirmButton =
          find.byKey(const Key('catalog_delete_confirm_button'));
      final confirmWidget = tester.widget<TextButton>(confirmButton);
      expect(confirmWidget.onPressed, isNull);

      await tester.enterText(
        find.byKey(const Key('catalog_delete_confirm_name_field')),
        'Nome errado',
      );
      await tester.pumpAndSettle();

      expect(tester.widget<TextButton>(confirmButton).onPressed, isNull);
    });

    testWidgets('cancelamento preserva item', (tester) async {
      final container = await pumpDetailWithRouter(
        tester,
        items: [equipment()],
      );

      await openDeleteDialog(tester);
      await tester.tap(find.byKey(const Key('catalog_delete_cancel_button')));
      await tester.pumpAndSettle();

      expect(container.read(catalogProvider), hasLength(1));
      expect(find.byKey(const Key('catalog_permanent_delete_button')), findsOneWidget);
    });

    testWidgets('exclui equipamento após confirmação e volta ao catálogo', (
      tester,
    ) async {
      final container = await pumpDetailWithRouter(
        tester,
        items: [equipment()],
      );

      await openDeleteDialog(tester);
      await tester.enterText(
        find.byKey(const Key('catalog_delete_confirm_name_field')),
        'Caixa de som',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('catalog_delete_confirm_button')));
      await tester.pumpAndSettle();

      expect(container.read(catalogProvider), isEmpty);
      expect(find.byType(CatalogScreen), findsOneWidget);
      expect(find.text('Item excluído definitivamente'), findsOneWidget);
    });

    testWidgets('exclui serviço após confirmação', (tester) async {
      final svc = service();
      final container = await pumpDetailWithRouter(
        tester,
        items: [svc],
        initialLocation: '/catalog/svc-1',
      );

      await openDeleteDialog(tester);
      await tester.enterText(
        find.byKey(const Key('catalog_delete_confirm_name_field')),
        'DJ Premium',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('catalog_delete_confirm_button')));
      await tester.pumpAndSettle();

      expect(container.read(catalogProvider), isEmpty);
    });

    testWidgets('bloqueia item usado por pacote ativo e mostra nomes', (
      tester,
    ) async {
      final eq = equipment();
      final pkg = packageItem(
        name: 'Pacote Premium',
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: eq,
            quantityPerPackage: 1,
          ),
        ],
      );

      final container = await pumpDetailWithRouter(
        tester,
        items: [eq, pkg],
      );

      await openDeleteDialog(tester);

      expect(find.byKey(const Key('catalog_delete_confirm_dialog')), findsNothing);

      expect(
        find.byKey(const Key('catalog_delete_package_block')),
        findsOneWidget,
      );
      final blockText = tester.widget<Text>(
        find.byKey(const Key('catalog_delete_package_block')),
      );
      expect(blockText.data, contains('Pacote Premium'));
      expect(container.read(catalogProvider), hasLength(2));
    });

    testWidgets('bloqueia item usado por pacote inativo', (tester) async {
      final eq = equipment();
      final pkg = packageItem(
        name: 'Pacote Arquivado',
        active: false,
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: eq,
            quantityPerPackage: 1,
          ),
        ],
      );

      final container = await pumpDetailWithRouter(
        tester,
        items: [eq, pkg],
      );

      await openDeleteDialog(tester);

      expect(
        find.byKey(const Key('catalog_delete_package_block')),
        findsOneWidget,
      );
      final blockText = tester.widget<Text>(
        find.byKey(const Key('catalog_delete_package_block')),
      );
      expect(blockText.data, contains('Pacote Arquivado'));
      expect(container.read(catalogProvider), hasLength(2));
    });

    testWidgets('exclui pacote normalmente', (tester) async {
      final eq = equipment();
      final pkg = packageItem(
        id: 'pkg-1',
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: eq,
            quantityPerPackage: 1,
          ),
        ],
      );

      final container = await pumpDetailWithRouter(
        tester,
        items: [eq, pkg],
        initialLocation: '/catalog/pkg-1',
      );

      await openDeleteDialog(tester);
      await tester.enterText(
        find.byKey(const Key('catalog_delete_confirm_name_field')),
        'Pacote Festa',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('catalog_delete_confirm_button')));
      await tester.pumpAndSettle();

      expect(
        container.read(catalogProvider).map((item) => item.id).toList(),
        ['eq-1'],
      );
    });

    testWidgets('remove foto após exclusão com sucesso', (tester) async {
      final storage = FakeCatalogImageStorageService();
      storage.seedCommitted('catalog/items/eq.jpg', Uint8List.fromList([1, 2, 3]));

      final container = await pumpDetailWithRouter(
        tester,
        items: [
          equipment().copyWith(imageReference: 'catalog/items/eq.jpg'),
        ],
        storage: storage,
      );

      await openDeleteDialog(tester);
      await tester.enterText(
        find.byKey(const Key('catalog_delete_confirm_name_field')),
        'Caixa de som',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('catalog_delete_confirm_button')));
      await tester.pumpAndSettle();

      expect(container.read(catalogProvider), isEmpty);
      expect(storage.deleteLog, ['catalog/items/eq.jpg']);
      expect(find.text('Item excluído definitivamente'), findsOneWidget);
      expect(find.textContaining('catalog/items'), findsNothing);
    });

    testWidgets('falha na foto mantém exclusão e mostra aviso', (tester) async {
      final storage = FakeCatalogImageStorageService()
        ..deleteCommittedShouldFail = true;
      storage.seedCommitted('catalog/items/eq.jpg', Uint8List.fromList([1, 2, 3]));

      final container = await pumpDetailWithRouter(
        tester,
        items: [
          equipment().copyWith(imageReference: 'catalog/items/eq.jpg'),
        ],
        storage: storage,
      );

      await openDeleteDialog(tester);
      await tester.enterText(
        find.byKey(const Key('catalog_delete_confirm_name_field')),
        'Caixa de som',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('catalog_delete_confirm_button')));
      await tester.pumpAndSettle();

      expect(container.read(catalogProvider), isEmpty);
      expect(
        find.text('Item excluído, mas não foi possível remover a foto local'),
        findsOneWidget,
      );
      expect(find.textContaining('catalog/items'), findsNothing);
    });

    testWidgets('clique duplo no diálogo executa exclusão uma vez', (
      tester,
    ) async {
      final storage = FakeCatalogImageStorageService();
      storage.seedCommitted('catalog/items/eq.jpg', Uint8List.fromList([1]));

      final container = await pumpDetailWithRouter(
        tester,
        items: [
          equipment().copyWith(imageReference: 'catalog/items/eq.jpg'),
        ],
        storage: storage,
      );

      await openDeleteDialog(tester);
      await tester.enterText(
        find.byKey(const Key('catalog_delete_confirm_name_field')),
        'Caixa de som',
      );
      await tester.pumpAndSettle();

      final confirmButton =
          find.byKey(const Key('catalog_delete_confirm_button'));
      await tester.tap(confirmButton);
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(container.read(catalogProvider), isEmpty);
      expect(storage.deleteLog, hasLength(1));
    });

    testWidgets('orçamento existente não bloqueia exclusão', (tester) async {
      final eq = equipment();
      final container = ProviderContainer(
        overrides: [
          ...catalogRepositoryOverrides(),
          ...quoteRepositoryOverrides(),
          catalogImageStorageProvider.overrideWithValue(
            FakeCatalogImageStorageService(),
          ),
        ],
      );

      await container.read(catalogProvider.notifier).addItem(eq);
      await container.read(quotesProvider.notifier).addQuote(
            sampleQuoteDraft(
              items: [
                sampleLineItem(catalogItemId: eq.id, name: eq.name),
              ],
            ),
          );

      final router = GoRouter(
        initialLocation: '/catalog/eq-1',
        routes: [
          GoRoute(
            path: '/catalog',
            builder: (context, state) => const CatalogScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => CatalogItemDetailScreen(
                  itemId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            scaffoldMessengerKey: EventProApp.scaffoldMessengerKey,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await openDeleteDialog(tester);
      await tester.enterText(
        find.byKey(const Key('catalog_delete_confirm_name_field')),
        'Caixa de som',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('catalog_delete_confirm_button')));
      await tester.pumpAndSettle();

      expect(container.read(catalogProvider), isEmpty);
      expect(container.read(quotesProvider), hasLength(1));
      final quoteLine = container.read(quotesProvider).single.items.single;
      expect(quoteLine.name, 'Caixa de som');
    });

    testWidgets('ativar/desativar continua funcionando', (tester) async {
      final container = await pumpDetailWithRouter(
        tester,
        items: [equipment()],
      );

      final deactivateButton = find.byKey(const Key('catalog_deactivate_button'));
      await tester.scrollUntilVisible(deactivateButton, 500);
      await tester.pumpAndSettle();
      await tester.tap(deactivateButton);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Desativar'));
      await tester.pumpAndSettle();

      expect(container.read(catalogProvider).single.active, isFalse);
      expect(find.byKey(const Key('catalog_activate_button')), findsOneWidget);
    });
  });
}
