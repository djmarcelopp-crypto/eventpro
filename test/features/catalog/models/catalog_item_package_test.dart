import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_package_constants.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';

void main() {
  CatalogPackageComponent sampleComponent({String id = 'component-1'}) {
    return CatalogPackageComponent(
      catalogItemId: id,
      nameSnapshot: 'Caixa de som',
      unitSnapshot: 'Unidade',
      typeSnapshot: 'Equipamento',
      categorySnapshot: 'Som',
      quantityPerPackage: 2,
    );
  }

  group('CatalogItem package', () {
    test('fromForm força unidade Pacote e lista imutável de componentes', () {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.package,
        name: ' Pacote Festa ',
        category: CatalogCategory.dj,
        unit: 'Evento',
        price: 8500,
        components: [sampleComponent()],
      );

      expect(item.name, 'Pacote Festa');
      expect(item.unit, CatalogPackageConstants.unit);
      expect(item.components, hasLength(1));
      expect(() => item.components.add(sampleComponent()), throwsUnsupportedError);
    });

    test('itens simples ignoram componentes informados', () {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: 'Caixa',
        category: CatalogCategory.sound,
        unit: 'Unidade',
        price: 1500,
        components: [sampleComponent()],
      );

      expect(item.components, isEmpty);
    });

    test('copyWith limpa componentes e mantém unidade fixa em pacote', () {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.package,
        name: 'Pacote',
        category: CatalogCategory.other,
        unit: CatalogPackageConstants.unit,
        price: 5000,
        components: [sampleComponent()],
      );

      final cleared = item.copyWith(clearComponents: true);

      expect(cleared.components, isEmpty);
      expect(cleared.unit, CatalogPackageConstants.unit);
    });
  });
}
