import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_package_component_snapshot.dart';

void main() {
  group('QuotePackageComponentSnapshot', () {
    test('calcula quantidade efetiva para checklist futuro', () {
      const snapshot = QuotePackageComponentSnapshot(
        catalogItemId: 'eq-1',
        name: 'Caixa de som',
        unit: 'Unidade',
        typeLabel: 'Equipamento',
        categoryLabel: 'Som',
        quantityPerPackage: 2,
      );

      expect(snapshot.effectiveQuantity(3), 6);
    });

    test('copyWith limpa catalogItemId quando solicitado', () {
      const original = QuotePackageComponentSnapshot(
        catalogItemId: 'eq-1',
        name: 'Caixa de som',
        unit: 'Unidade',
        typeLabel: 'Equipamento',
        categoryLabel: 'Som',
        quantityPerPackage: 1,
      );

      final cleared = original.copyWith(clearCatalogItemId: true);

      expect(cleared.catalogItemId, isNull);
      expect(cleared.name, original.name);
    });
  });
}
