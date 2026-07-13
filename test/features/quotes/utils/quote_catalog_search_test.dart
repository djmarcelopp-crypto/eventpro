import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/quotes/utils/quote_catalog_search.dart';

void main() {
  final activeItem = CatalogItem.fromForm(
    type: CatalogItemType.equipment,
    name: 'Caixa de som',
    category: CatalogCategory.sound,
    unit: 'Unidade',
    price: 1500,
    id: 'active-1',
    createdAt: DateTime(2024, 1, 1),
  );

  final inactiveItem = CatalogItem.fromForm(
    type: CatalogItemType.service,
    name: 'DJ',
    category: CatalogCategory.dj,
    unit: 'Evento',
    price: 2000,
    id: 'inactive-1',
    createdAt: DateTime(2024, 1, 1),
    active: false,
  );

  group('QuoteCatalogSearch', () {
    test('exclui itens inativos', () {
      final result = QuoteCatalogSearch.filterActive(
        [activeItem, inactiveItem],
        '',
      );

      expect(result, hasLength(1));
      expect(result.first.id, 'active-1');
    });

    test('busca por nome, categoria e tipo', () {
      expect(
        QuoteCatalogSearch.matches(activeItem, 'caixa'),
        isTrue,
      );
      expect(
        QuoteCatalogSearch.matches(activeItem, 'som'),
        isTrue,
      );
      expect(
        QuoteCatalogSearch.matches(activeItem, 'equipamento'),
        isTrue,
      );
    });
  });
}
