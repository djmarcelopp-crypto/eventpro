import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_package_constants.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';
import 'package:eventpro/features/quotes/models/quote_line_draft.dart';
import 'package:eventpro/features/quotes/models/quote_package_component_snapshot.dart';
import 'package:eventpro/features/quotes/utils/quote_calculator.dart';
import 'package:eventpro/features/quotes/utils/quote_form_initializer.dart';
import 'package:eventpro/features/quotes/utils/quote_line_draft_saver.dart';
import 'package:eventpro/features/quotes/utils/quote_package_component_mapper.dart';

import '../quotes_test_helpers.dart';

CatalogItem buildPackage({
  String id = 'pkg-1',
  bool active = true,
  double price = 9000,
}) {
  final equipment = sampleCatalogItem(id: 'eq-1', name: 'Caixa de som');
  return CatalogItem.fromForm(
    type: CatalogItemType.package,
    name: 'Pacote Festa',
    category: CatalogCategory.dj,
    unit: CatalogPackageConstants.unit,
    price: price,
    id: id,
    createdAt: DateTime(2024, 1, 1),
    active: active,
    components: [
      CatalogPackageComponent.fromCatalogItem(
        item: equipment,
        quantityPerPackage: 2,
      ),
      CatalogPackageComponent.fromCatalogItem(
        item: sampleCatalogItem(
          id: 'svc-1',
          name: 'DJ',
          price: 2500,
        ).copyWith(
          type: CatalogItemType.service,
          category: CatalogCategory.dj,
          unit: 'Evento',
        ),
        quantityPerPackage: 1,
      ),
    ],
  );
}

List<QuotePackageComponentSnapshot> packageSnapshots() {
  return QuotePackageComponentMapper.fromCatalogComponents(
    buildPackage().components,
  );
}

void main() {
  group('QuoteLineDraftSaver package', () {
    test('linha nova cria snapshots no save', () {
      final draft = QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: 'pkg-1',
        name: 'Pacote Festa',
        unit: CatalogPackageConstants.unit,
        quantityText: '2',
        priceText: '9.000,00',
        isExistingLine: false,
        packageComponents: packageSnapshots(),
      );

      final result = QuoteLineDraftSaver.buildLineItems(
        drafts: [draft],
        findCatalogItem: (_) => buildPackage(),
      );

      expect(result.isSuccess, isTrue);
      final line = result.items!.single;
      expect(line.isPackageLine, isTrue);
      expect(line.packageComponents, hasLength(2));
      expect(line.packageComponents!.first.name, 'Caixa de som');
      expect(line.quantity, 2);
      expect(line.unitPriceCents, 900_000);
      expect(
        QuoteCalculator.lineTotalCents(
          quantity: line.quantity,
          unitPriceCents: line.unitPriceCents,
        ),
        1_800_000,
      );
    });

    test('financeiro usa preço do pacote, não dos componentes', () {
      final draft = QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: 'pkg-1',
        name: 'Pacote Festa',
        unit: CatalogPackageConstants.unit,
        quantityText: '3',
        priceText: '10.000,00',
        isExistingLine: false,
        packageComponents: packageSnapshots(),
      );

      final result = QuoteLineDraftSaver.buildLineItems(
        drafts: [draft],
        findCatalogItem: (_) => buildPackage(price: 10000),
      );

      final line = result.items!.single;
      expect(
        QuoteCalculator.lineTotalCents(
          quantity: line.quantity,
          unitPriceCents: line.unitPriceCents,
        ),
        3_000_000,
      );
      expect(line.packageComponents!.first.effectiveQuantity(3), 6);
    });

    test('linha nova bloqueia pacote inativo', () {
      final draft = QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: 'pkg-1',
        name: 'Pacote Festa',
        unit: CatalogPackageConstants.unit,
        quantityText: '1',
        priceText: '9.000,00',
        isExistingLine: false,
        packageComponents: packageSnapshots(),
      );

      final result = QuoteLineDraftSaver.buildLineItems(
        drafts: [draft],
        findCatalogItem: (_) => buildPackage(active: false),
      );

      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('inativo'));
    });

    test('linha existente preserva snapshots após alteração no catálogo', () {
      final frozenSnapshots = packageSnapshots();
      final draft = QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: 'pkg-1',
        name: 'Pacote congelado',
        unit: CatalogPackageConstants.unit,
        quantityText: '1,5',
        priceText: '8.000,00',
        isExistingLine: true,
        packageComponents: frozenSnapshots,
      );

      final changedPackage = buildPackage().copyWith(
        name: 'Pacote atualizado',
        components: const [],
      );

      final result = QuoteLineDraftSaver.buildLineItems(
        drafts: [draft],
        findCatalogItem: (_) => changedPackage,
      );

      expect(result.isSuccess, isTrue);
      final line = result.items!.single;
      expect(line.name, 'Pacote congelado');
      expect(line.packageComponents, frozenSnapshots);
      expect(line.packageComponents, hasLength(2));
      expect(line.quantity, 1.5);
      expect(
        line.packageComponents!.first.effectiveQuantity(1.5),
        3,
      );
    });

    test('linha existente preserva pacote inativo ou ausente', () {
      final draft = QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: 'pkg-1',
        name: 'Pacote congelado',
        unit: CatalogPackageConstants.unit,
        quantityText: '1',
        priceText: '8.000,00',
        isExistingLine: true,
        packageComponents: packageSnapshots(),
      );

      final inactiveResult = QuoteLineDraftSaver.buildLineItems(
        drafts: [draft],
        findCatalogItem: (_) => buildPackage(active: false),
      );
      expect(inactiveResult.isSuccess, isTrue);

      final missingResult = QuoteLineDraftSaver.buildLineItems(
        drafts: [draft],
        findCatalogItem: (_) => null,
      );
      expect(missingResult.isSuccess, isTrue);
      expect(missingResult.items!.single.packageComponents, hasLength(2));
    });

    test('linha legada sem packageComponents continua normal', () {
      final draft = QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: 'item-1',
        name: 'Equipamento',
        unit: 'Unidade',
        quantityText: '1',
        priceText: '1.500,00',
        isExistingLine: true,
      );

      final result = QuoteLineDraftSaver.buildLineItems(
        drafts: [draft],
        findCatalogItem: (_) => sampleCatalogItem(),
      );

      expect(result.isSuccess, isTrue);
      expect(result.items!.single.packageComponents, isNull);
      expect(result.items!.single.isPackageLine, isFalse);
    });
  });

  group('QuoteFormInitializer package', () {
    test('lineDraftFromItem carrega packageComponents', () {
      final line = sampleLineItem(
        name: 'Pacote Festa',
        unit: CatalogPackageConstants.unit,
      ).copyWith(
        packageComponents: packageSnapshots(),
      );

      final draft = QuoteFormInitializer.lineDraftFromItem(
        line,
        draftId: 'line_1',
      );

      expect(draft.isPackageLine, isTrue);
      expect(draft.packageComponents, hasLength(2));
    });
  });
}
