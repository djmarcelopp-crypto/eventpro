import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_package_constants.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';
import 'package:eventpro/features/catalog/utils/catalog_package_validator.dart';

void main() {
  CatalogItem equipment({
    String id = 'eq-1',
    bool active = true,
  }) {
    return CatalogItem.fromForm(
      type: CatalogItemType.equipment,
      name: 'Caixa de som',
      category: CatalogCategory.sound,
      unit: 'Unidade',
      price: 1500,
      id: id,
      createdAt: DateTime(2024, 1, 1),
      active: active,
    );
  }

  CatalogPackageComponent component({
    String id = 'eq-1',
    double quantity = 1,
  }) {
    return CatalogPackageComponent(
      catalogItemId: id,
      nameSnapshot: 'Caixa de som',
      unitSnapshot: 'Unidade',
      typeSnapshot: 'Equipamento',
      categorySnapshot: 'Som',
      quantityPerPackage: quantity,
    );
  }

  CatalogItem package({
    List<CatalogPackageComponent> components = const [],
    String unit = CatalogPackageConstants.unit,
  }) {
    return CatalogItem.fromForm(
      type: CatalogItemType.package,
      name: 'Pacote Festa',
      category: CatalogCategory.dj,
      unit: unit,
      price: 9000,
      id: 'pkg-1',
      createdAt: DateTime(2024, 1, 1),
      components: components,
    );
  }

  CatalogItem? resolve(Map<String, CatalogItem> items, String id) => items[id];

  group('CatalogPackageValidator', () {
    test('exige unidade Pacote e ao menos um componente', () {
      final result = CatalogPackageValidator.validate(
        item: package(),
        resolveItem: (id) => resolve({}, id),
      );

      expect(result.canSave, isFalse);
      expect(
        result.issues.map((issue) => issue.message),
        contains('Informe pelo menos um componente no pacote'),
      );
    });

    test('bloqueia componente duplicado e pacote aninhado', () {
      final nestedPackage = CatalogItem.fromForm(
        type: CatalogItemType.package,
        name: 'Pacote interno',
        category: CatalogCategory.other,
        unit: CatalogPackageConstants.unit,
        price: 1000,
        id: 'pkg-2',
        createdAt: DateTime(2024, 1, 1),
      );
      final items = {
        'eq-1': equipment(),
        'pkg-2': nestedPackage,
      };

      final result = CatalogPackageValidator.validate(
        item: package(
          components: [
            component(id: 'eq-1'),
            component(id: 'eq-1'),
            component(id: 'pkg-2'),
          ],
        ),
        resolveItem: (id) => resolve(items, id),
      );

      expect(result.canSave, isFalse);
      expect(
        result.issues.any((issue) => issue.message.contains('duplicado')),
        isTrue,
      );
      expect(
        result.issues.any(
          (issue) => issue.message.contains('não podem conter outros pacotes'),
        ),
        isTrue,
      );
    });

    test('novo componente inativo gera erro', () {
      final items = {'eq-1': equipment(active: false)};

      final result = CatalogPackageValidator.validate(
        item: package(components: [component()]),
        resolveItem: (id) => resolve(items, id),
      );

      expect(result.canSave, isFalse);
      expect(result.issues.single.isError, isTrue);
    });

    test('componente existente inativo gera aviso e permite salvar', () {
      final items = {'eq-1': equipment(active: false)};

      final result = CatalogPackageValidator.validate(
        item: package(components: [component()]),
        resolveItem: (id) => resolve(items, id),
        existingComponentIds: {'eq-1'},
      );

      expect(result.canSave, isTrue);
      expect(result.hasWarnings, isTrue);
      expect(result.issues.single.isWarning, isTrue);
    });

    test('bloqueia unidade diferente de Pacote', () {
      final invalidPackage = CatalogItem(
        id: 'pkg-1',
        createdAt: DateTime(2024, 1, 1),
        type: CatalogItemType.package,
        name: 'Pacote Festa',
        category: CatalogCategory.dj,
        unit: 'Evento',
        price: 9000,
        active: true,
        components: [component()],
      );

      final result = CatalogPackageValidator.validate(
        item: invalidPackage,
        resolveItem: (id) => equipment(id: id),
      );

      expect(result.canSave, isFalse);
      expect(
        result.issues.any(
          (issue) => issue.message.contains('unidade "Pacote"'),
        ),
        isTrue,
      );
    });
  });
}