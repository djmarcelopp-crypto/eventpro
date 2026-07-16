import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_package_constants.dart';
import 'package:eventpro/features/catalog/data/mappers/catalog_item_mapper.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';

void main() {
  group('CatalogItemMapper', () {
    test('toInsertCompanion converte equipamento com todos os campos', () {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: 'Caixa de som',
        category: CatalogCategory.sound,
        unit: 'Unidade',
        price: 1500.5,
        active: false,
        description: 'Caixa ativa 500W',
        imageReference: 'catalog/items/img.jpg',
        id: 'item-1',
        createdAt: DateTime(2024, 3, 5, 10, 30),
      );

      final companion = CatalogItemMapper.toInsertCompanion(item);

      expect(companion.id.value, 'item-1');
      expect(companion.type.value, 'equipment');
      expect(companion.category.value, 'sound');
      expect(companion.priceCents.value, 150050);
      expect(companion.active.value, isFalse);
      expect(companion.description.value, 'Caixa ativa 500W');
      expect(companion.imageReference.value, 'catalog/items/img.jpg');
    });

    test('toDomain reconstrói item a partir da linha do banco', () {
      final row = CatalogItemRow(
        id: 'item-2',
        createdAt: DateTime(2024, 3, 5, 10, 30).toUtc().millisecondsSinceEpoch,
        type: 'service',
        name: 'DJ Profissional',
        category: 'dj',
        description: null,
        unit: 'hora',
        priceCents: 60000,
        active: true,
        imageReference: null,
      );

      final item = CatalogItemMapper.toDomain(row);

      expect(item.id, 'item-2');
      expect(item.type, CatalogItemType.service);
      expect(item.category, CatalogCategory.dj);
      expect(item.name, 'DJ Profissional');
      expect(item.unit, 'hora');
      expect(item.price, 600.0);
      expect(item.active, isTrue);
      expect(item.components, isEmpty);
    });

    test('preço em centavos não perde precisão no round-trip', () {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.service,
        name: 'DJ',
        category: CatalogCategory.dj,
        unit: 'hora',
        price: 123.45,
        id: 'item-3',
      );

      final companion = CatalogItemMapper.toInsertCompanion(item);
      expect(companion.priceCents.value, 12345);

      final row = CatalogItemRow(
        id: 'item-3',
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
        type: 'service',
        name: 'DJ',
        category: 'dj',
        unit: 'hora',
        priceCents: companion.priceCents.value,
        active: true,
      );

      expect(CatalogItemMapper.toDomain(row).price, 123.45);
    });

    test('componentes de pacote são convertidos para companions', () {
      final component = CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: 'Caixa',
        category: CatalogCategory.sound,
        unit: 'Unidade',
        price: 100,
        id: 'component-1',
      );

      final package = CatalogItem.fromForm(
        type: CatalogItemType.package,
        name: 'Pacote Festa',
        category: CatalogCategory.dj,
        unit: CatalogPackageConstants.unit,
        price: 900,
        id: 'package-1',
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: component,
            quantityPerPackage: 2,
          ),
        ],
      );

      final companions = CatalogItemMapper.toComponentCompanions(package);

      expect(companions, hasLength(1));
      expect(companions.single.packageId.value, 'package-1');
      expect(companions.single.componentItemId.value, 'component-1');
      expect(companions.single.quantityPerPackage.value, 2);
      expect(companions.single.nameSnapshot.value, 'Caixa');
    });

    test('item sem pacote gera lista de componentes vazia', () {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: 'Caixa',
        category: CatalogCategory.sound,
        unit: 'Unidade',
        price: 100,
        id: 'item-4',
      );

      expect(CatalogItemMapper.toComponentCompanions(item), isEmpty);
    });

    test('toDomain aplica componentes de pacote informados', () {
      final row = CatalogItemRow(
        id: 'package-2',
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
        type: 'package',
        name: 'Pacote Som',
        category: 'sound',
        unit: CatalogPackageConstants.unit,
        priceCents: 90000,
        active: true,
      );

      final componentRow = CatalogPackageComponentRow(
        packageId: 'package-2',
        componentItemId: 'component-2',
        nameSnapshot: 'Caixa',
        unitSnapshot: 'Unidade',
        typeSnapshot: 'Equipamento',
        categorySnapshot: 'Som',
        quantityPerPackage: 3,
      );

      final item = CatalogItemMapper.toDomain(row, components: [componentRow]);

      expect(item.isPackage, isTrue);
      expect(item.components, hasLength(1));
      expect(item.components.single.catalogItemId, 'component-2');
      expect(item.components.single.quantityPerPackage, 3);
    });
  });
}
