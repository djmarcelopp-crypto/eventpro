import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/utils/catalog_detail_presenter.dart';

void main() {
  group('CatalogDetailPresenter', () {
    final createdAt = DateTime(2024, 3, 5);

    test('detailItems omite descrição vazia', () {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: 'Caixa de som',
        category: CatalogCategory.sound,
        unit: 'Unidade',
        price: 1500,
        id: 'item-1',
        createdAt: createdAt,
      );

      final labels = CatalogDetailPresenter.detailItems(item)
          .map((entry) => entry.label)
          .toList();

      expect(labels, isNot(contains('Descrição')));
      expect(labels, contains('Preço'));
      expect(CatalogDetailPresenter.formattedPrice(item), 'R\$ 1.500,00');
    });

    test('detailItems inclui descrição quando preenchida', () {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.service,
        name: 'DJ',
        category: CatalogCategory.dj,
        unit: 'Evento',
        price: 2500,
        description: 'Com rider técnico',
        id: 'item-2',
        createdAt: createdAt,
      );

      final items = CatalogDetailPresenter.detailItems(item);
      final description = items.firstWhere((entry) => entry.label == 'Descrição');

      expect(description.value, 'Com rider técnico');
      expect(CatalogDetailPresenter.statusLabel(item), 'Ativo');
    });

    test('statusLabel reflete item inativo', () {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: 'Mesa',
        category: CatalogCategory.sound,
        unit: 'Unidade',
        price: 800,
        active: false,
        id: 'item-3',
        createdAt: createdAt,
      );

      expect(CatalogDetailPresenter.statusLabel(item), 'Inativo');
      expect(
        CatalogDetailPresenter.formattedCreatedAt(item),
        '05/março/2024',
      );
    });
  });
}
