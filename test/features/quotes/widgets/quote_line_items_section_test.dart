import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/core/theme/app_colors.dart';
import 'package:eventpro/features/quotes/models/quote_line_item.dart';
import 'package:eventpro/features/quotes/widgets/quote_line_items_section.dart';

void main() {
  QuoteLineItem buildItem({
    required String id,
    String name = 'Caixa de som',
    String? description,
    String unit = 'Unidade',
    double quantity = 1,
  }) {
    return QuoteLineItem(
      catalogItemId: id,
      name: name,
      description: description,
      unit: unit,
      quantity: quantity,
      unitPriceCents: 150_000,
      lineTotalCents: (quantity * 150_000).round(),
    );
  }

  Widget buildSection({
    required List<QuoteLineItem> items,
    double width = 390,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: QuoteLineItemsSection(items: items),
            ),
          ),
        ),
      ),
    );
  }

  group('QuoteLineItemsSection', () {
    testWidgets('exibe cabeçalho com quantidade total', (tester) async {
      await tester.pumpWidget(
        buildSection(
          items: [
            buildItem(id: 'item-1'),
            buildItem(id: 'item-2', name: 'Iluminação'),
          ],
        ),
      );

      expect(find.text('Itens do orçamento (2)'), findsOneWidget);
      expect(find.byKey(const Key('quote_line_items_section')), findsOneWidget);
    });

    testWidgets('mostra cards com chip, preço e subtotal dourado', (tester) async {
      await tester.pumpWidget(
        buildSection(
          items: [
            buildItem(
              id: 'item-1',
              description: 'Descrição detalhada do serviço',
              quantity: 2,
              unit: 'Diária',
            ),
          ],
        ),
      );

      expect(find.text('2 × Diária'), findsOneWidget);
      expect(find.text('R\$ 3.000,00'), findsOneWidget);

      final subtotal = tester.widget<Text>(
        find.text('R\$ 3.000,00'),
      );
      expect(subtotal.style?.color, AppColors.primary);
    });

    testWidgets('limita descrição a três linhas com ellipsis', (tester) async {
      await tester.pumpWidget(
        buildSection(
          items: [
            buildItem(
              id: 'item-1',
              description: 'Linha um. Linha dois. Linha três. Linha quatro.',
            ),
          ],
        ),
      );

      final description = tester.widget<Text>(
        find.textContaining('Linha um.'),
      );
      expect(description.maxLines, 3);
      expect(description.overflow, TextOverflow.ellipsis);
    });

    testWidgets('expande e recolhe quando há mais de 6 itens', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final items = [
        for (var i = 1; i <= 8; i++)
          buildItem(id: 'item-$i', name: 'Item $i'),
      ];

      await tester.pumpWidget(buildSection(items: items));

      expect(find.text('Item 6'), findsOneWidget);
      expect(find.text('Item 7'), findsNothing);

      await tester.ensureVisible(
        find.byKey(const Key('quote_items_show_all_button')),
      );
      await tester.tap(find.byKey(const Key('quote_items_show_all_button')));
      await tester.pumpAndSettle();

      expect(find.text('Item 7'), findsOneWidget);
      expect(find.text('Item 8'), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('quote_items_show_less_button')),
      );
      await tester.tap(find.byKey(const Key('quote_items_show_less_button')));
      await tester.pumpAndSettle();

      expect(find.text('Item 7'), findsNothing);
    });

    testWidgets('usa duas colunas em desktop largo', (tester) async {
      await tester.pumpWidget(
        buildSection(
          width: 1000,
          items: [
            buildItem(id: 'item-1', name: 'Item A'),
            buildItem(id: 'item-2', name: 'Item B'),
          ],
        ),
      );

      final row = find.ancestor(
        of: find.text('Item A'),
        matching: find.byType(Row),
      );
      expect(row, findsWidgets);
    });

    testWidgets('equipamento simples continua sem badge de pacote', (tester) async {
      await tester.pumpWidget(
        buildSection(
          items: [buildItem(id: 'item-1')],
        ),
      );

      expect(find.byKey(const Key('quote_package_badge')), findsNothing);
      expect(find.text('Caixa de som'), findsOneWidget);
    });
  });
}
