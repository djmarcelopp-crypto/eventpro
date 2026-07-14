import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_screen.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/providers/catalog_provider.dart';

void main() {
  group('CatalogScreen grid', () {
    CatalogItem buildItem({
      required String id,
      bool active = true,
      String name = 'Caixa de som profissional de alta potência',
      String unit = 'Unidade',
    }) {
      return CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: name,
        category: CatalogCategory.sound,
        unit: unit,
        price: 1500,
        id: id,
        createdAt: DateTime(2024, 1, 1),
        active: active,
      );
    }

    Future<void> pumpCatalogGrid(
      WidgetTester tester, {
      required Size viewport,
      required List<CatalogItem> items,
    }) async {
      tester.view.physicalSize = viewport;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      for (final item in items) {
        container.read(catalogProvider.notifier).addItem(item);
      }

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CatalogScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('não estoura em 2048×1200', (tester) async {
      await pumpCatalogGrid(
        tester,
        viewport: const Size(2048, 1200),
        items: [
          buildItem(id: 'item-1'),
          buildItem(id: 'item-2', active: false),
          buildItem(
            id: 'item-3',
            name: 'Equipamento com nome extremamente longo para validar quebra',
            unit: 'Metro quadrado',
          ),
        ],
      );

      expect(find.byKey(const Key('catalog_items_grid')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('não estoura em 960 px', (tester) async {
      await pumpCatalogGrid(
        tester,
        viewport: const Size(960, 900),
        items: [
          buildItem(id: 'item-1'),
          buildItem(id: 'item-2'),
        ],
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('não estoura em tablet e celular', (tester) async {
      for (final viewport in [
        const Size(768, 1024),
        const Size(390, 844),
      ]) {
        await pumpCatalogGrid(
          tester,
          viewport: viewport,
          items: [
            buildItem(id: 'item-mobile'),
            buildItem(
              id: 'item-mobile-2',
              unit: 'Diária',
              name: 'Serviço premium com nome longo e categoria extensa',
            ),
          ],
        );

        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('exibe item ativo e inativo sem overflow', (tester) async {
      await pumpCatalogGrid(
        tester,
        viewport: const Size(1280, 900),
        items: [
          buildItem(id: 'active-item'),
          buildItem(id: 'inactive-item', active: false),
        ],
      );

      expect(find.byKey(const Key('catalog_inactive_badge')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
