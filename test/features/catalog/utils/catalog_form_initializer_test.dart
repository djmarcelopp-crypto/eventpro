import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_billing_unit.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/utils/catalog_form_initializer.dart';

void main() {
  group('CatalogFormInitializer', () {
    test('fromItem mapeia campos e unidade predefinida', () {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.service,
        name: 'DJ Premium',
        category: CatalogCategory.dj,
        unit: 'Diária',
        price: 1800.5,
        description: 'Inclui equipamento',
        active: false,
        id: 'item-1',
        createdAt: DateTime(2024, 1, 1),
        imageReference: 'catalog/items/dj.jpg',
      );

      final values = CatalogFormInitializer.fromItem(item);

      expect(values.type, CatalogItemType.service);
      expect(values.category, CatalogCategory.dj);
      expect(values.billingUnit, CatalogBillingUnit.daily);
      expect(values.customUnit, isEmpty);
      expect(values.name, 'DJ Premium');
      expect(values.description, 'Inclui equipamento');
      expect(values.active, isFalse);
      expect(values.priceText, '1.800,50');
    });

    test('fromItem mapeia unidade personalizada', () {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: 'Pacote',
        category: CatalogCategory.other,
        unit: 'Pacote especial',
        price: 500,
        id: 'item-2',
        createdAt: DateTime(2024, 1, 1),
      );

      final values = CatalogFormInitializer.fromItem(item);

      expect(values.billingUnit, CatalogBillingUnit.other);
      expect(values.customUnit, 'Pacote especial');
    });
  });
}
