import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_package_constants.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';
import 'package:eventpro/features/quotes/models/quote_line_item.dart';

import '../quotes_test_helpers.dart';

void main() {
  CatalogItem buildPackage() {
    return CatalogItem.fromForm(
      type: CatalogItemType.package,
      name: 'Pacote Festa',
      category: CatalogCategory.dj,
      unit: CatalogPackageConstants.unit,
      price: 9000,
      id: 'pkg-1',
      createdAt: DateTime(2024, 1, 1),
      components: [
        CatalogPackageComponent.fromCatalogItem(
          item: sampleCatalogItem(id: 'eq-1', name: 'Caixa de som'),
          quantityPerPackage: 2,
        ),
      ],
    );
  }

  group('QuoteLineItem package', () {
    test('linha antiga permanece com packageComponents nulo', () {
      final legacy = QuoteLineItem.fromCatalogItem(
        sampleCatalogItem(),
        quantity: 1,
      );

      expect(legacy.packageComponents, isNull);
      expect(legacy.isPackageLine, isFalse);
    });

    test('fromCatalogItem congela componentes textuais do pacote', () {
      final line = QuoteLineItem.fromCatalogItem(buildPackage(), quantity: 3);

      expect(line.unit, CatalogPackageConstants.unit);
      expect(line.isPackageLine, isTrue);
      expect(line.packageComponents, hasLength(1));
      expect(line.packageComponents!.single.name, 'Caixa de som');
      expect(line.packageComponents!.single.typeLabel, 'Equipamento');
      expect(line.packageComponents!.single.quantityPerPackage, 2);
      expect(line.packageComponents!.single.effectiveQuantity(3), 6);
      expect(() => line.packageComponents!.add(line.packageComponents!.first),
          throwsUnsupportedError);
    });

    test('copyWith limpa packageComponents', () {
      final line = QuoteLineItem.fromCatalogItem(buildPackage(), quantity: 1);
      final cleared = line.copyWith(clearPackageComponents: true);

      expect(cleared.packageComponents, isNull);
      expect(cleared.isPackageLine, isFalse);
    });
  });
}
