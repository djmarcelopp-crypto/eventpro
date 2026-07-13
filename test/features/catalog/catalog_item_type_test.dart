import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';

void main() {
  group('CatalogItemType', () {
    test('possui labels em português', () {
      expect(CatalogItemType.equipment.label, 'Equipamento');
      expect(CatalogItemType.service.label, 'Serviço');
    });
  });
}
