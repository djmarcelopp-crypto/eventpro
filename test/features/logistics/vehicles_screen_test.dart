import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/providers/vehicle_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'logistics_test_helpers.dart';

void main() {
  testWidgets('shows empty state when there are no vehicles', (tester) async {
    await pumpLogisticsApp(tester);

    expect(find.text('Nenhum veículo cadastrado'), findsOneWidget);
    expect(find.byKey(const Key('vehicle_empty_add')), findsOneWidget);
  });

  testWidgets('shows summary cards and vehicle list', (tester) async {
    await pumpLogisticsApp(
      tester,
      vehicles: [
        buildTestVehicle(id: 'v-1', plate: 'ABC1D23'),
        buildTestVehicle(
          id: 'v-2',
          plate: 'XYZ9Z99',
          status: VehicleStatus.maintenance,
        ),
      ],
    );

    expect(find.byKey(const Key('vehicle_summary_available')), findsOneWidget);
    expect(find.byKey(const Key('vehicle_summary_maintenance')), findsOneWidget);
    expect(find.byKey(const Key('vehicle_summary_types')), findsOneWidget);
    expect(find.byKey(const Key('vehicles_scroll')), findsOneWidget);
    expect(find.text('ABC1D23'), findsOneWidget);
    expect(find.text('XYZ9Z99'), findsOneWidget);
  });

  testWidgets('filters vehicles by plate query', (tester) async {
    await pumpLogisticsApp(
      tester,
      vehicles: [
        buildTestVehicle(id: 'v-1', plate: 'ABC1D23'),
        buildTestVehicle(id: 'v-2', plate: 'XYZ9Z99'),
      ],
    );

    await tester.enterText(
      find.byKey(const Key('vehicle_filter_plate')),
      'xyz',
    );
    await tester.pumpAndSettle();

    expect(find.text('XYZ9Z99'), findsOneWidget);
    expect(find.text('ABC1D23'), findsNothing);
  });

  testWidgets('creates vehicle via notifier and refreshes list', (tester) async {
    final container = await pumpLogisticsApp(tester);

    final result = await container.read(vehicleProvider.notifier).addVehicle(
          buildTestVehicle(id: '', plate: 'new1a23'),
        );
    expect(result.isSuccess, isTrue);

    await tester.pumpAndSettle();

    expect(container.read(vehicleProvider).value, hasLength(1));
    expect(find.text('NEW1A23'), findsOneWidget);
  });

  testWidgets('opens new vehicle form from empty state', (tester) async {
    await pumpLogisticsApp(tester);

    await tester.tap(find.byKey(const Key('vehicle_empty_add')));
    await tester.pumpAndSettle();

    expect(find.textContaining('veículo'), findsWidgets);
    expect(find.byKey(const Key('vehicle_form_save')), findsOneWidget);
  });

  testWidgets('opens types screen from vehicles list', (tester) async {
    await pumpLogisticsApp(tester);

    await tester.tap(find.byKey(const Key('vehicle_types_button')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Tipos'), findsWidgets);
    expect(find.text('Van'), findsOneWidget);
  });
}
