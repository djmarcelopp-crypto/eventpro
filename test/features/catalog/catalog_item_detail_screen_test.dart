import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_detail_screen.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_package_constants.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';
import 'package:eventpro/features/catalog/providers/catalog_image_services_provider.dart';
import 'package:eventpro/features/catalog/providers/catalog_provider.dart';
import 'package:eventpro/features/catalog/widgets/catalog_list_item.dart';

import 'fakes/fake_catalog_image_storage_service.dart';

void main() {
  CatalogItem sampleItem({
    bool active = true,
    String? description,
  }) {
    return CatalogItem.fromForm(
      type: CatalogItemType.equipment,
      name: 'Caixa de som',
      category: CatalogCategory.sound,
      unit: 'Unidade',
      price: 1500,
      active: active,
      description: description,
      id: 'item-1',
      createdAt: DateTime(2024, 3, 5),
    );
  }

  Future<ProviderContainer> pumpDetail(
    WidgetTester tester, {
    required CatalogItem item,
  }) async {
    final container = ProviderContainer(
      overrides: [
        catalogImageStorageProvider.overrideWithValue(
          FakeCatalogImageStorageService(),
        ),
      ],
    );
    container.read(catalogProvider.notifier).addItem(item);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: CatalogItemDetailScreen(itemId: item.id),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  group('CatalogItemDetailScreen', () {
    testWidgets('exibe detalhes sem descrição vazia', (tester) async {
      await pumpDetail(tester, item: sampleItem());

      expect(find.text('Caixa de som'), findsWidgets);
      expect(find.text('Equipamento'), findsOneWidget);
      expect(find.text('Som'), findsOneWidget);
      expect(find.text('R\$ 1.500,00'), findsOneWidget);
      expect(find.text('Ativo'), findsOneWidget);
      expect(find.text('05/março/2024'), findsOneWidget);
      expect(find.text('Descrição'), findsNothing);
      expect(find.byKey(const Key('catalog_edit_button')), findsOneWidget);
    });

    testWidgets('exibe descrição quando preenchida', (tester) async {
      await pumpDetail(
        tester,
        item: sampleItem(description: 'Potência 1000W'),
      );

      expect(find.text('Descrição'), findsOneWidget);
      expect(find.text('Potência 1000W'), findsOneWidget);
    });

    testWidgets('exibe componentes compactos para pacote', (tester) async {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.package,
        name: 'Pacote Festa',
        category: CatalogCategory.dj,
        unit: CatalogPackageConstants.unit,
        price: 9000,
        id: 'pkg-detail',
        createdAt: DateTime(2024, 3, 5),
        components: const [
          CatalogPackageComponent(
            catalogItemId: 'eq-1',
            nameSnapshot: 'Caixa de som',
            unitSnapshot: 'Unidade',
            typeSnapshot: 'Equipamento',
            categorySnapshot: 'Som',
            quantityPerPackage: 2,
          ),
        ],
      );

      await pumpDetail(tester, item: item);

      expect(find.text('Pacote'), findsWidgets);
      expect(
        find.byKey(const Key('catalog_detail_package_components_title')),
        findsOneWidget,
      );
      expect(find.text('Itens incluídos (1)'), findsOneWidget);
      expect(find.text('Caixa de som'), findsWidgets);
      expect(find.text('Qtd. por pacote: 2'), findsOneWidget);
    });

    testWidgets('desativa item após confirmação e atualiza tela', (
      tester,
    ) async {
      final container = await pumpDetail(tester, item: sampleItem());

      final deactivateButton = find.byKey(const Key('catalog_deactivate_button'));
      await tester.scrollUntilVisible(deactivateButton, 500);
      await tester.pumpAndSettle();
      await tester.tap(deactivateButton);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Desativar'));
      await tester.pumpAndSettle();

      expect(find.text('Inativo'), findsOneWidget);
      expect(find.byKey(const Key('catalog_activate_button')), findsOneWidget);
      expect(container.read(catalogProvider).single.active, isFalse);
      expect(find.text('Item desativado com sucesso'), findsOneWidget);
    });
  });

  group('CatalogListItem', () {
    testWidgets('dispara onTap ao tocar card', (tester) async {
      var tapped = false;
      final item = sampleItem();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogImageStorageProvider.overrideWithValue(
              FakeCatalogImageStorageService(),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: CatalogListItem(
                item: item,
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('catalog_list_item_item-1')));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
