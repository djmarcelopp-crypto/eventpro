import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_package_constants.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';
import 'package:eventpro/features/catalog/utils/catalog_package_dependency_checker.dart';

CatalogItem equipment({
  String id = 'eq-1',
  String name = 'Caixa de som',
  bool active = true,
}) {
  return CatalogItem.fromForm(
    type: CatalogItemType.equipment,
    name: name,
    category: CatalogCategory.sound,
    unit: 'Unidade',
    price: 1500,
    id: id,
    createdAt: DateTime(2024, 1, 1),
    active: active,
  );
}

CatalogItem packageItem({
  String id = 'pkg-1',
  String name = 'Pacote Festa',
  bool active = true,
  List<CatalogPackageComponent> components = const [],
}) {
  return CatalogItem.fromForm(
    type: CatalogItemType.package,
    name: name,
    category: CatalogCategory.dj,
    unit: CatalogPackageConstants.unit,
    price: 9000,
    id: id,
    createdAt: DateTime(2024, 1, 1),
    active: active,
    components: components,
  );
}

void main() {
  group('CatalogPackageDependencyChecker', () {
    test('detecta pacote ativo e inativo que usam o item', () {
      final eq = equipment();
      final activePackage = packageItem(
        id: 'pkg-active',
        name: 'Pacote Ativo',
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: eq,
            quantityPerPackage: 1,
          ),
        ],
      );
      final inactivePackage = packageItem(
        id: 'pkg-inactive',
        name: 'Pacote Inativo',
        active: false,
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: eq,
            quantityPerPackage: 2,
          ),
        ],
      );

      final names = CatalogPackageDependencyChecker.dependentPackageNames(
        catalogItemId: eq.id,
        items: [eq, activePackage, inactivePackage],
      );

      expect(names, ['Pacote Ativo', 'Pacote Inativo']);
    });

    test('permite excluir pacote sem dependentes', () {
      final pkg = packageItem();
      final names = CatalogPackageDependencyChecker.dependentPackageNames(
        catalogItemId: pkg.id,
        items: [pkg, equipment()],
      );

      expect(names, isEmpty);
    });
  });
}
