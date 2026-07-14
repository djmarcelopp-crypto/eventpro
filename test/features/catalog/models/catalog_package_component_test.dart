import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_package_constants.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';

void main() {
  CatalogItem componentSource({
    String id = 'component-1',
    CatalogItemType type = CatalogItemType.equipment,
    bool active = true,
    String name = 'Caixa de som',
  }) {
    return CatalogItem.fromForm(
      type: type,
      name: name,
      category: CatalogCategory.sound,
      unit: 'Unidade',
      price: 1500,
      id: id,
      createdAt: DateTime(2024, 1, 1),
      active: active,
    );
  }

  group('CatalogPackageComponent', () {
    test('fromCatalogItem congela snapshots textuais', () {
      final component = CatalogPackageComponent.fromCatalogItem(
        item: componentSource(),
        quantityPerPackage: 2,
      );

      expect(component.catalogItemId, 'component-1');
      expect(component.nameSnapshot, 'Caixa de som');
      expect(component.unitSnapshot, 'Unidade');
      expect(component.typeSnapshot, 'Equipamento');
      expect(component.categorySnapshot, 'Som');
      expect(component.quantityPerPackage, 2);
    });

    test('rejeita pacote aninhado', () {
      final package = CatalogItem.fromForm(
        type: CatalogItemType.package,
        name: 'Pacote',
        category: CatalogCategory.other,
        unit: CatalogPackageConstants.unit,
        price: 5000,
      );

      expect(
        () => CatalogPackageComponent.fromCatalogItem(
          item: package,
          quantityPerPackage: 1,
        ),
        throwsArgumentError,
      );
    });

    test('copyWith preserva campos não informados', () {
      final original = CatalogPackageComponent.fromCatalogItem(
        item: componentSource(),
        quantityPerPackage: 1,
      );

      final updated = original.copyWith(quantityPerPackage: 3);

      expect(updated.catalogItemId, original.catalogItemId);
      expect(updated.nameSnapshot, original.nameSnapshot);
      expect(updated.quantityPerPackage, 3);
    });
  });
}
