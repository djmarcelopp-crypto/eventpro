import 'package:eventpro/features/logistics/models/quote_vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'logistics_test_helpers.dart';

void main() {
  testWidgets('shows empty quote logistics list', (tester) async {
    await pumpLogisticsApp(
      tester,
      quotes: [buildTestQuote()],
      vehicles: [buildTestVehicle()],
      initialLocation: '/quotes/quote-1/vehicles',
    );

    expect(
      find.text('Nenhum veículo associado a este orçamento.'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('quote_vehicle_add')), findsOneWidget);
  });

  testWidgets('shows linked vehicles and freight summary', (tester) async {
    final now = DateTime(2026, 7, 17);
    await pumpLogisticsApp(
      tester,
      quotes: [buildTestQuote()],
      vehicles: [buildTestVehicle()],
      quoteVehicles: [
        QuoteVehicle(
          id: 'qv-1',
          quoteId: 'quote-1',
          vehicleId: 'vehicle-1',
          freightCostCents: 15_000,
          plannedDepartureAt: DateTime(2026, 8, 1),
          plannedReturnAt: DateTime(2026, 8, 2),
          createdAt: now,
          updatedAt: now,
        ),
      ],
      initialLocation: '/quotes/quote-1/vehicles',
    );

    expect(find.byKey(const Key('quote_vehicle_list')), findsOneWidget);
    expect(find.byKey(const Key('quote_vehicle_summary_total')), findsOneWidget);
    expect(find.text('ABC1D23'), findsOneWidget);
    expect(find.textContaining('Frete:'), findsOneWidget);
  });

  testWidgets('opens add vehicle dialog', (tester) async {
    await pumpLogisticsApp(
      tester,
      quotes: [buildTestQuote()],
      vehicles: [buildTestVehicle()],
      members: [buildTestDriver()],
      initialLocation: '/quotes/quote-1/vehicles',
    );

    await tester.tap(find.byKey(const Key('quote_vehicle_add')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('quote_vehicle_form_vehicle')), findsOneWidget);
    expect(find.byKey(const Key('quote_vehicle_form_driver')), findsOneWidget);
    expect(
      find.byKey(const Key('quote_vehicle_form_departure')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('quote_vehicle_form_save')), findsOneWidget);
  });
}
