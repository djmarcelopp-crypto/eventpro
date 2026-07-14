import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_package_constants.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';
import 'package:eventpro/features/quotes/models/quote_line_draft.dart';
import 'package:eventpro/features/quotes/models/quote_line_item.dart';
import 'package:eventpro/features/quotes/models/quote_package_component_snapshot.dart';
import 'package:eventpro/features/quotes/state/quote_form_state.dart';
import 'package:eventpro/features/quotes/utils/quote_package_component_mapper.dart';
import 'package:eventpro/features/quotes/widgets/quote_line_editor.dart';
import 'package:eventpro/features/quotes/widgets/quote_line_items_section.dart';

import '../quotes_test_helpers.dart';

CatalogItem buildPackageCatalogItem({
  String id = 'pkg-1',
  bool active = true,
}) {
  return CatalogItem.fromForm(
    type: CatalogItemType.package,
    name: 'Pacote Festa',
    category: CatalogCategory.dj,
    unit: CatalogPackageConstants.unit,
    price: 9000,
    id: id,
    createdAt: DateTime(2024, 1, 1),
    active: active,
    components: [
      CatalogPackageComponent.fromCatalogItem(
        item: sampleCatalogItem(id: 'eq-1'),
        quantityPerPackage: 2,
      ),
    ],
  );
}

List<QuotePackageComponentSnapshot> buildSnapshots() {
  return QuotePackageComponentMapper.fromCatalogComponents(
    buildPackageCatalogItem().components,
  );
}

void main() {
  group('QuoteLineEditor package', () {
    testWidgets('exibe badge, resumo e expande componentes', (tester) async {
      final draft = QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: 'pkg-1',
        name: 'Pacote Festa',
        unit: CatalogPackageConstants.unit,
        quantityText: '2',
        priceText: '9.000,00',
        isExistingLine: false,
        packageComponents: buildSnapshots(),
      );
      final quantityController = TextEditingController(text: '2');
      final priceController = TextEditingController(text: '9.000,00');
      addTearDown(quantityController.dispose);
      addTearDown(priceController.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: QuoteLineEditor(
                draft: draft,
                quantityController: quantityController,
                priceController: priceController,
                calculation: QuoteFormState.calculateLine(draft),
                onQuantityChanged: (_) {},
                onPriceChanged: (_) {},
                onRemove: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('quote_package_badge')), findsOneWidget);
      expect(find.byKey(const Key('quote_package_summary_line_1')), findsOneWidget);
      expect(find.text('1 item incluído'), findsOneWidget);

      await tester.tap(find.byKey(const Key('quote_package_components_expand')));
      await tester.pumpAndSettle();

      expect(find.text('Caixa de som'), findsOneWidget);
      expect(find.text('Qtd. efetiva: 4'), findsOneWidget);

      await tester.tap(find.byKey(const Key('quote_package_components_collapse')));
      await tester.pumpAndSettle();

      expect(find.text('Qtd. efetiva: 4'), findsNothing);
    });

    testWidgets('não estoura em celular', (tester) async {
      final draft = QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: 'pkg-1',
        name: 'Pacote Festa',
        unit: CatalogPackageConstants.unit,
        quantityText: '1,5',
        priceText: '9.000,00',
        isExistingLine: false,
        packageComponents: buildSnapshots(),
      );
      final quantityController = TextEditingController(text: '1,5');
      final priceController = TextEditingController(text: '9.000,00');
      addTearDown(quantityController.dispose);
      addTearDown(priceController.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(360, 800)),
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 360,
                  child: QuoteLineEditor(
                    draft: draft,
                    quantityController: quantityController,
                    priceController: priceController,
                    calculation: QuoteFormState.calculateLine(draft),
                    onQuantityChanged: (_) {},
                    onPriceChanged: (_) {},
                    onRemove: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group('QuoteLineItemsSection package', () {
    QuoteLineItem buildPackageLine({
      double quantity = 2,
    }) {
      return QuoteLineItem(
        catalogItemId: 'pkg-1',
        name: 'Pacote Festa',
        unit: CatalogPackageConstants.unit,
        quantity: quantity,
        unitPriceCents: 900_000,
        lineTotalCents: (quantity * 900_000).round(),
        packageComponents: buildSnapshots(),
      );
    }

    testWidgets('detalhes mostram componentes do pacote', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 390,
              child: QuoteLineItemsSection(items: [buildPackageLine()]),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('quote_package_badge')), findsOneWidget);
      expect(
        find.byKey(const Key('quote_detail_package_summary_pkg-1')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('quote_package_components_expand')));
      await tester.pumpAndSettle();

      expect(find.text('Qtd. efetiva: 4'), findsOneWidget);
    });

    testWidgets('orçamento legado sem packageComponents permanece normal', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 390,
              child: QuoteLineItemsSection(
                items: [
                  QuoteLineItem(
                    catalogItemId: 'item-1',
                    name: 'Equipamento legado',
                    unit: 'Unidade',
                    quantity: 1,
                    unitPriceCents: 150_000,
                    lineTotalCents: 150_000,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('quote_package_badge')), findsNothing);
      expect(find.text('Equipamento legado'), findsOneWidget);
    });
  });
}
