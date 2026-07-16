import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_package_constants.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';
import 'package:eventpro/features/catalog/new_catalog_item_screen.dart';
import 'package:eventpro/features/catalog/providers/catalog_provider.dart';

import 'fakes/catalog_repository_test_overrides.dart';

Future<void> _tapCatalogSave(WidgetTester tester) async {
  final saveButton = find.byKey(const Key('catalog_save_button'));
  final formScrollable = find.ancestor(
    of: saveButton,
    matching: find.byType(Scrollable),
  );
  await tester.scrollUntilVisible(
    saveButton,
    800,
    scrollable: formScrollable,
  );
  await tester.pumpAndSettle();
  await tester.ensureVisible(saveButton);
  await tester.tap(saveButton);
  await tester.pumpAndSettle();
}

Future<void> _selectPackageType(WidgetTester tester) async {
  final segmented = find.byKey(const Key('catalog_type_segmented'));
  if (segmented.evaluate().isNotEmpty) {
    await tester.tap(
      find.descendant(
        of: segmented,
        matching: find.text('Pacote'),
      ),
    );
    await tester.pumpAndSettle();
    return;
  }

  await tester.tap(find.byKey(const Key('catalog_type_dropdown')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Pacote').last);
  await tester.pumpAndSettle();
}

Future<void> _addComponentFromSheet(
  WidgetTester tester,
  String itemName,
) async {
  await tester.tap(find.byKey(const Key('catalog_package_add_component_button')));
  await tester.pumpAndSettle();

  await tester.tap(find.text(itemName).last);
  await tester.pumpAndSettle();
}

CatalogItem equipment({
  String id = 'eq-1',
  String name = 'Caixa de som',
  bool active = true,
}) {
  return CatalogItem.fromForm(
    type: CatalogItemType.equipment,
    name: name,
    category: CatalogCategory.sound,
    unit: 'Unidade',
    price: 1500,
    id: id,
    createdAt: DateTime(2024, 1, 1),
    active: active,
  );
}

CatalogItem service({
  String id = 'svc-1',
  String name = 'DJ',
  bool active = true,
}) {
  return CatalogItem.fromForm(
    type: CatalogItemType.service,
    name: name,
    category: CatalogCategory.dj,
    unit: 'Evento',
    price: 2500,
    id: id,
    createdAt: DateTime(2024, 1, 1),
    active: active,
  );
}

CatalogItem packageItem({
  String id = 'pkg-1',
  List<CatalogPackageComponent> components = const [],
}) {
  return CatalogItem.fromForm(
    type: CatalogItemType.package,
    name: 'Pacote Festa',
    category: CatalogCategory.dj,
    unit: CatalogPackageConstants.unit,
    price: 9000,
    id: id,
    createdAt: DateTime(2024, 2, 1),
    components: components,
  );
}

CatalogPackageComponent component({
  String id = 'eq-1',
  double quantity = 1,
  String name = 'Caixa de som',
}) {
  return CatalogPackageComponent(
    catalogItemId: id,
    nameSnapshot: name,
    unitSnapshot: 'Unidade',
    typeSnapshot: 'Equipamento',
    categorySnapshot: 'Som',
    quantityPerPackage: quantity,
  );
}

void main() {
  Future<ProviderContainer> pumpPackageForm(
    WidgetTester tester, {
    Size viewport = const Size(1280, 900),
    List<CatalogItem> seedItems = const [],
    String? editItemId,
  }) async {
    tester.view.physicalSize = viewport;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(
      overrides: catalogRepositoryOverrides(),
    );
    addTearDown(container.dispose);

    for (final item in seedItems) {
      await container.read(catalogProvider.notifier).addItem(item);
    }

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: NewCatalogItemScreen(itemId: editItemId),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  group('NewCatalogItemScreen package UI', () {
    testWidgets('cria pacote válido com unidade fixa e preço manual', (
      tester,
    ) async {
      final container = await pumpPackageForm(
        tester,
        seedItems: [equipment(), service()],
      );

      await _selectPackageType(tester);

      expect(find.byKey(const Key('catalog_package_unit_field')), findsOneWidget);
      expect(find.byKey(const Key('catalog_unit_field')), findsNothing);

      await tester.enterText(
        find.byKey(const Key('catalog_name_field')),
        'Pacote Premium',
      );
      await tester.enterText(
        find.byKey(const Key('catalog_price_field')),
        '9.000,00',
      );

      await _addComponentFromSheet(tester, 'Caixa de som');
      await _addComponentFromSheet(tester, 'DJ');

      await _tapCatalogSave(tester);

      final saved = container.read(catalogProvider).last;
      expect(saved.type, CatalogItemType.package);
      expect(saved.unit, CatalogPackageConstants.unit);
      expect(saved.price, 9000);
      expect(saved.components, hasLength(2));
    });

    testWidgets('bloqueia pacote sem componente', (tester) async {
      await pumpPackageForm(
        tester,
        seedItems: [equipment()],
      );

      await _selectPackageType(tester);
      await tester.enterText(
        find.byKey(const Key('catalog_name_field')),
        'Pacote vazio',
      );
      await tester.enterText(
        find.byKey(const Key('catalog_price_field')),
        '1000',
      );

      await _tapCatalogSave(tester);

      expect(
        find.text('Informe pelo menos um componente no pacote'),
        findsOneWidget,
      );
    });

    testWidgets('bloqueia pacote aninhado e duplicidade', (tester) async {
      final nested = packageItem(
        id: 'pkg-nested',
        components: [component(id: 'eq-1')],
      );

      await pumpPackageForm(
        tester,
        seedItems: [equipment(), nested],
      );

      await _selectPackageType(tester);
      await tester.enterText(
        find.byKey(const Key('catalog_name_field')),
        'Pacote externo',
      );
      await tester.enterText(
        find.byKey(const Key('catalog_price_field')),
        '5000',
      );

      await tester.tap(find.byKey(const Key('catalog_package_add_component_button')));
      await tester.pumpAndSettle();

      expect(find.text('Pacote Festa'), findsNothing);

      await tester.tap(find.text('Caixa de som').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('catalog_package_add_component_button')));
      await tester.pumpAndSettle();
      expect(find.text('Caixa de som'), findsWidgets);
      final duplicateOption = find.byKey(const Key('catalog_package_option_eq-1'));
      expect(duplicateOption, findsNothing);
    });

    testWidgets('componente inativo não aparece para nova inclusão', (
      tester,
    ) async {
      await pumpPackageForm(
        tester,
        seedItems: [equipment(active: false)],
      );

      await _selectPackageType(tester);
      await tester.tap(find.byKey(const Key('catalog_package_add_component_button')));
      await tester.pumpAndSettle();

      expect(
        find.text('Nenhum equipamento ou serviço ativo disponível para incluir.'),
        findsOneWidget,
      );
    });

    testWidgets('componente existente inativo preservado com aviso', (
      tester,
    ) async {
      final inactive = equipment(active: false);
      final pkg = packageItem(
        components: [component(id: inactive.id, name: inactive.name)],
      );

      await pumpPackageForm(
        tester,
        seedItems: [inactive, pkg],
        editItemId: pkg.id,
      );

      expect(
        find.byKey(
          const Key('catalog_package_component_inactive_eq-1'),
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Este item está inativo no catálogo. Você pode mantê-lo ou removê-lo.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('componente ausente bloqueia save', (tester) async {
      final pkg = packageItem(
        components: [component(id: 'missing-eq')],
      );

      await pumpPackageForm(
        tester,
        seedItems: [pkg],
        editItemId: pkg.id,
      );

      expect(
        find.byKey(
          const Key('catalog_package_component_missing_missing-eq'),
        ),
        findsOneWidget,
      );
      expect(
        find.text('Componente removido do catálogo. Remova-o para salvar.'),
        findsOneWidget,
      );

      await _tapCatalogSave(tester);

      expect(
        find.text('Componente não encontrado no catálogo'),
        findsOneWidget,
      );
    });

    testWidgets('quantidade inválida bloqueia save', (tester) async {
      await pumpPackageForm(
        tester,
        seedItems: [equipment()],
      );

      await _selectPackageType(tester);
      await tester.enterText(
        find.byKey(const Key('catalog_name_field')),
        'Pacote teste',
      );
      await tester.enterText(
        find.byKey(const Key('catalog_price_field')),
        '1000',
      );
      await _addComponentFromSheet(tester, 'Caixa de som');

      await tester.enterText(
        find.byKey(const Key('catalog_package_component_quantity_eq-1')),
        '0',
      );

      await _tapCatalogSave(tester);

      expect(find.text('A quantidade deve ser maior que zero'), findsOneWidget);
    });

    testWidgets('permite remover componente antes de salvar', (tester) async {
      await pumpPackageForm(
        tester,
        seedItems: [equipment(), service()],
      );

      await _selectPackageType(tester);
      await _addComponentFromSheet(tester, 'Caixa de som');
      await _addComponentFromSheet(tester, 'DJ');

      expect(find.text('Itens do pacote (2)'), findsOneWidget);

      await tester.tap(
        find.byKey(const Key('catalog_package_component_remove_eq-1')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Itens do pacote (1)'), findsOneWidget);
      expect(
        find.byKey(const Key('catalog_package_component_eq-1')),
        findsNothing,
      );
    });

    testWidgets('pede confirmação ao trocar tipo com componentes', (
      tester,
    ) async {
      await pumpPackageForm(
        tester,
        seedItems: [equipment()],
      );

      await _selectPackageType(tester);
      await _addComponentFromSheet(tester, 'Caixa de som');

      await tester.tap(find.text('Equipamento'));
      await tester.pumpAndSettle();

      expect(find.text('Alterar tipo'), findsOneWidget);
      expect(
        find.textContaining('itens selecionados serão descartados'),
        findsOneWidget,
      );

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('Itens do pacote (1)'), findsOneWidget);

      await tester.tap(find.text('Equipamento'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('catalog_unit_field')), findsOneWidget);
      expect(find.text('Itens do pacote (0)'), findsNothing);
    });

    testWidgets('edição de pacote não permite virar item simples', (tester) async {
      final pkg = packageItem(components: [component()]);
      await pumpPackageForm(
        tester,
        seedItems: [equipment(), pkg],
        editItemId: pkg.id,
      );

      expect(find.byKey(const Key('catalog_package_unit_field')), findsOneWidget);
      expect(find.byKey(const Key('catalog_unit_field')), findsNothing);

      final segmented = find.byKey(const Key('catalog_type_segmented'));
      await tester.tap(
        find.descendant(
          of: segmented,
          matching: find.text('Equipamento'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('catalog_package_unit_field')), findsOneWidget);
      expect(find.byKey(const Key('catalog_unit_field')), findsNothing);
    });

    testWidgets('edição de equipamento não permite virar pacote', (tester) async {
      final eq = equipment(id: 'eq-edit');
      await pumpPackageForm(
        tester,
        seedItems: [eq],
        editItemId: eq.id,
      );

      expect(find.byKey(const Key('catalog_unit_field')), findsOneWidget);
      expect(find.byKey(const Key('catalog_package_unit_field')), findsNothing);

      final segmented = find.byKey(const Key('catalog_type_segmented'));
      await tester.tap(
        find.descendant(
          of: segmented,
          matching: find.text('Pacote'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('catalog_unit_field')), findsOneWidget);
      expect(find.byKey(const Key('catalog_package_unit_field')), findsNothing);
    });

    testWidgets('edição preserva id, createdAt, foto e componentes', (
      tester,
    ) async {
      final createdAt = DateTime(2024, 3, 10);
      final eq = equipment();
      final pkg = CatalogItem.fromForm(
        type: CatalogItemType.package,
        name: 'Pacote original',
        category: CatalogCategory.dj,
        unit: CatalogPackageConstants.unit,
        price: 8000,
        imageReference: 'catalog/items/pkg.jpg',
        id: 'pkg-edit',
        createdAt: createdAt,
        components: [component(id: eq.id)],
      );

      final container = ProviderContainer(
        overrides: catalogRepositoryOverrides(),
      );
      addTearDown(container.dispose);
      await container.read(catalogProvider.notifier).addItem(eq);
      await container.read(catalogProvider.notifier).addItem(pkg);

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: Text('Lista do catálogo'),
            ),
          ),
          GoRoute(
            path: '/edit',
            builder: (context, state) => const NewCatalogItemScreen(
              itemId: 'pkg-edit',
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      router.go('/edit');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('catalog_name_field')),
        'Pacote atualizado',
      );
      await _tapCatalogSave(tester);

      final updated = container.read(catalogProvider).last;
      expect(updated.name, 'Pacote atualizado');
      expect(updated.id, 'pkg-edit');
      expect(updated.createdAt, createdAt);
      expect(updated.imageReference, 'catalog/items/pkg.jpg');
      expect(updated.components.single.catalogItemId, eq.id);
    });

    testWidgets('item simples continua funcionando sem regressão', (
      tester,
    ) async {
      final container = await pumpPackageForm(tester);

      await tester.enterText(
        find.byKey(const Key('catalog_name_field')),
        'Equipamento simples',
      );
      await tester.enterText(
        find.byKey(const Key('catalog_price_field')),
        '1.500,00',
      );

      await _tapCatalogSave(tester);

      final saved = container.read(catalogProvider).single;
      expect(saved.type, CatalogItemType.equipment);
      expect(saved.unit, 'Unidade');
      expect(saved.components, isEmpty);
    });

    testWidgets('não estoura em celular com seletor compacto', (tester) async {
      await pumpPackageForm(
        tester,
        viewport: const Size(360, 800),
        seedItems: [equipment()],
      );

      expect(find.byKey(const Key('catalog_type_dropdown')), findsOneWidget);
      expect(find.byKey(const Key('catalog_type_segmented')), findsNothing);

      await _selectPackageType(tester);
      await tester.enterText(
        find.byKey(const Key('catalog_name_field')),
        'Pacote mobile',
      );
      await tester.enterText(
        find.byKey(const Key('catalog_price_field')),
        '3000',
      );
      await _addComponentFromSheet(tester, 'Caixa de som');

      expect(tester.takeException(), isNull);
    });

    testWidgets('não estoura em desktop com seletor segmentado', (tester) async {
      await pumpPackageForm(
        tester,
        viewport: const Size(1280, 900),
        seedItems: [equipment(), service()],
      );

      expect(find.byKey(const Key('catalog_type_segmented')), findsOneWidget);

      await _selectPackageType(tester);
      await _addComponentFromSheet(tester, 'Caixa de som');

      expect(tester.takeException(), isNull);
    });
  });
}
