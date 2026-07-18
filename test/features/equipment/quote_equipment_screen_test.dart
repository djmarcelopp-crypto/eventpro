import 'package:eventpro/features/equipment/models/quote_equipment.dart';
import 'package:eventpro/features/equipment/providers/quote_equipment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equipment_test_helpers.dart';

void main() {
  testWidgets('shows empty quote equipment state', (tester) async {
    await pumpEquipmentApp(
      tester,
      quotes: [buildTestQuote()],
      equipment: [buildTestEquipment()],
      initialLocation: '/quotes/quote-1/equipment',
    );

    expect(
      find.text('Nenhum equipamento associado a este orçamento.'),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('quote_equipment_empty_add_button')),
      findsOneWidget,
    );
  });

  testWidgets('lists associated quote equipment with summary', (tester) async {
    final now = DateTime(2026, 1, 1);
    await pumpEquipmentApp(
      tester,
      quotes: [buildTestQuote()],
      equipment: [buildTestEquipment(name: 'Caixa de som')],
      quoteEquipment: [
        QuoteEquipment(
          id: 'qe-1',
          quoteId: 'quote-1',
          equipmentId: 'eq-1',
          quantity: 3,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      initialLocation: '/quotes/quote-1/equipment',
    );

    expect(find.byKey(const Key('quote_equipment_list')), findsOneWidget);
    expect(find.text('Caixa de som'), findsOneWidget);
    expect(find.text('Quantidade: 3'), findsOneWidget);
    expect(
      find.byKey(const Key('quote_equipment_summary_lines')),
      findsOneWidget,
    );
  });

  testWidgets('adds equipment to quote through dialog', (tester) async {
    final container = await pumpEquipmentApp(
      tester,
      quotes: [buildTestQuote()],
      equipment: [buildTestEquipment(name: 'Caixa de som')],
      initialLocation: '/quotes/quote-1/equipment',
    );

    await warmQuoteEquipment(container, 'quote-1');

    final result = await container
        .read(quoteEquipmentProvider('quote-1').notifier)
        .add(equipmentId: 'eq-1', quantity: 2);
    expect(result.isSuccess, isTrue);

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('quote_equipment_list')), findsOneWidget);
    expect(find.text('Quantidade: 2'), findsOneWidget);
  });

  testWidgets('opens add dialog from empty state', (tester) async {
    await pumpEquipmentApp(
      tester,
      quotes: [buildTestQuote()],
      equipment: [buildTestEquipment(name: 'Caixa de som')],
      initialLocation: '/quotes/quote-1/equipment',
    );

    await tester.tap(find.byKey(const Key('quote_equipment_empty_add_button')));
    await tester.pumpAndSettle();

    expect(find.text('Adicionar equipamento'), findsWidgets);
    expect(
      find.byKey(const Key('quote_equipment_add_save_button')),
      findsOneWidget,
    );
  });
}
