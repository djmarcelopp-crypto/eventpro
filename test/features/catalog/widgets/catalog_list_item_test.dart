import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';
import 'package:eventpro/features/catalog/widgets/catalog_list_item.dart';

void main() {
  Widget buildItem(CatalogItem item, {VoidCallback? onTap}) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 320,
          child: CatalogListItem(
            item: item,
            onTap: onTap ?? () {},
          ),
        ),
      ),
    );
  }

  group('CatalogListItem', () {
    testWidgets('exibe dados do item ativo', (tester) async {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: 'Caixa de som profissional de alta potência',
        category: CatalogCategory.sound,
        unit: 'Diária',
        price: 1500,
        id: 'item-1',
        createdAt: DateTime(2024, 1, 1),
      );

      await tester.pumpWidget(buildItem(item));

      expect(find.text('Caixa de som profissional de alta potência'), findsOneWidget);
      expect(find.text('Equipamento'), findsOneWidget);
      expect(find.text('Som'), findsOneWidget);
      expect(find.text('R\$ 1.500,00 / Diária'), findsOneWidget);
      expect(find.byKey(const Key('catalog_inactive_badge')), findsNothing);
    });

    testWidgets('identifica pacote com resumo de itens incluídos', (tester) async {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.package,
        name: 'Pacote Festa',
        category: CatalogCategory.dj,
        unit: 'Pacote',
        price: 9000,
        id: 'pkg-1',
        createdAt: DateTime(2024, 1, 1),
        components: [
          const CatalogPackageComponent(
            catalogItemId: 'eq-1',
            nameSnapshot: 'Caixa',
            unitSnapshot: 'Unidade',
            typeSnapshot: 'Equipamento',
            categorySnapshot: 'Som',
            quantityPerPackage: 2,
          ),
          const CatalogPackageComponent(
            catalogItemId: 'svc-1',
            nameSnapshot: 'DJ',
            unitSnapshot: 'Evento',
            typeSnapshot: 'Serviço',
            categorySnapshot: 'DJ',
            quantityPerPackage: 1,
          ),
        ],
      );

      await tester.pumpWidget(buildItem(item));

      expect(find.text('Pacote'), findsOneWidget);
      expect(find.byKey(const Key('catalog_package_summary_pkg-1')), findsOneWidget);
      expect(find.text('2 itens incluídos'), findsOneWidget);
    });

    testWidgets('exibe badge Inativo para item desativado', (tester) async {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.service,
        name: 'DJ',
        category: CatalogCategory.dj,
        unit: 'Evento',
        price: 2500,
        active: false,
        id: 'item-2',
        createdAt: DateTime(2024, 1, 1),
      );

      await tester.pumpWidget(buildItem(item));

      expect(find.byKey(const Key('catalog_inactive_badge')), findsOneWidget);
      expect(find.text('Inativo'), findsOneWidget);
    });
  });
}
