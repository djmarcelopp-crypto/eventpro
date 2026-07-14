import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';
import 'package:eventpro/features/quotes/utils/quote_package_component_mapper.dart';

void main() {
  group('QuotePackageComponentMapper', () {
    test('mapeia snapshots textuais sem enums do catálogo', () {
      const component = CatalogPackageComponent(
        catalogItemId: 'eq-1',
        nameSnapshot: 'Caixa de som',
        unitSnapshot: 'Unidade',
        typeSnapshot: 'Equipamento',
        categorySnapshot: 'Som',
        quantityPerPackage: 2,
      );

      final snapshot = QuotePackageComponentMapper.fromCatalogComponent(component);

      expect(snapshot.catalogItemId, 'eq-1');
      expect(snapshot.name, 'Caixa de som');
      expect(snapshot.unit, 'Unidade');
      expect(snapshot.typeLabel, 'Equipamento');
      expect(snapshot.categoryLabel, 'Som');
      expect(snapshot.quantityPerPackage, 2);
    });

    test('retorna lista imutável', () {
      final components = QuotePackageComponentMapper.fromCatalogComponents([
        const CatalogPackageComponent(
          catalogItemId: 'eq-1',
          nameSnapshot: 'Caixa',
          unitSnapshot: 'Unidade',
          typeSnapshot: 'Equipamento',
          categorySnapshot: 'Som',
          quantityPerPackage: 1,
        ),
      ]);

      expect(components, hasLength(1));
      expect(() => components.add(components.first), throwsUnsupportedError);
    });
  });
}
