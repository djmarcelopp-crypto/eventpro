import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';

void main() {
  group('CatalogCategory', () {
    test('possui 8 categorias com labels em português', () {
      expect(CatalogCategory.values.length, 8);
      expect(CatalogCategory.sound.label, 'Som');
      expect(CatalogCategory.lighting.label, 'Iluminação');
      expect(CatalogCategory.ledPanel.label, 'Painel de LED');
      expect(CatalogCategory.structure.label, 'Estrutura');
      expect(CatalogCategory.dj.label, 'DJ');
      expect(CatalogCategory.team.label, 'Equipe');
      expect(CatalogCategory.transport.label, 'Transporte');
      expect(CatalogCategory.other.label, 'Outros');
    });
  });
}
