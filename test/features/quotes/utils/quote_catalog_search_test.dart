import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_package_constants.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';
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

    test('pacote ativo aparece e pacote inativo é excluído', () {
      final package = CatalogItem.fromForm(
        type: CatalogItemType.package,
        name: 'Pacote Festa',
        category: CatalogCategory.dj,
        unit: CatalogPackageConstants.unit,
        price: 9000,
        id: 'pkg-active',
        createdAt: DateTime(2024, 1, 1),
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: activeItem,
            quantityPerPackage: 1,
          ),
        ],
      );
      final inactivePackage = package.copyWith(
        id: 'pkg-inactive',
        active: false,
      );

      final result = QuoteCatalogSearch.filterActive(
        [package, inactivePackage],
        '',
      );

      expect(result, hasLength(1));
      expect(result.single.id, 'pkg-active');
      expect(result.single.isPackage, isTrue);
    });
  });
}
