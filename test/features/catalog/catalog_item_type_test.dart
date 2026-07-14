import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';

void main() {
  group('CatalogItemType', () {
    test('possui labels em português', () {
      expect(CatalogItemType.equipment.label, 'Equipamento');
      expect(CatalogItemType.service.label, 'Serviço');
      expect(CatalogItemType.package.label, 'Pacote');
    });

    test('identifica tipos elegíveis como componente', () {
      expect(CatalogItemType.equipment.canBePackageComponent, isTrue);
      expect(CatalogItemType.service.canBePackageComponent, isTrue);
      expect(CatalogItemType.package.canBePackageComponent, isFalse);
      expect(CatalogItemType.package.isPackage, isTrue);
    });
  });
}
