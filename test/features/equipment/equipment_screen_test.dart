import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:eventpro/features/equipment/providers/equipment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'equipment_test_helpers.dart';

void main() {
  testWidgets('shows empty state when there is no equipment', (tester) async {
    await pumpEquipmentApp(tester);

    expect(find.text('Nenhum equipamento cadastrado'), findsOneWidget);
    expect(find.byKey(const Key('equipment_empty_new_button')), findsOneWidget);
  });

  testWidgets('shows summary cards and equipment list', (tester) async {
    await pumpEquipmentApp(
      tester,
      equipment: [
        buildTestEquipment(id: 'eq-1', name: 'Caixa de som'),
        buildTestEquipment(
          id: 'eq-2',
          name: 'Microfone',
          status: EquipmentStatus.maintenance,
        ),
      ],
    );

    expect(find.byKey(const Key('equipment_summary_total')), findsOneWidget);
    expect(find.byKey(const Key('equipment_list')), findsOneWidget);
    expect(find.text('Caixa de som'), findsOneWidget);
    expect(find.text('Microfone'), findsOneWidget);
  });

  testWidgets('filters equipment by name query', (tester) async {
    await pumpEquipmentApp(
      tester,
      equipment: [
        buildTestEquipment(id: 'eq-1', name: 'Caixa de som'),
        buildTestEquipment(id: 'eq-2', name: 'Microfone'),
      ],
    );

    await tester.enterText(
      find.byKey(const Key('equipment_filter_name')),
      'micro',
    );
    await tester.pumpAndSettle();

    expect(find.text('Microfone'), findsOneWidget);
    expect(find.text('Caixa de som'), findsNothing);
  });

  testWidgets('creates equipment via notifier and refreshes list', (
    tester,
  ) async {
    final container = await pumpEquipmentApp(tester);

    final result = await container.read(equipmentProvider.notifier).addEquipment(
          buildTestEquipment(id: '', name: 'Subwoofer', totalQuantity: 4),
        );
    expect(result.isSuccess, isTrue);

    await tester.pumpAndSettle();

    expect(container.read(equipmentProvider).value, hasLength(1));
    expect(find.text('Subwoofer'), findsOneWidget);
  });

  testWidgets('opens new equipment form from empty state', (tester) async {
    await pumpEquipmentApp(tester);

    await tester.tap(find.byKey(const Key('equipment_empty_new_button')));
    await tester.pumpAndSettle();

    expect(find.text('Novo equipamento'), findsOneWidget);
    expect(find.byKey(const Key('equipment_form_save_button')), findsOneWidget);
  });

  testWidgets('opens categories screen from equipment list', (tester) async {
    await pumpEquipmentApp(tester);

    await tester.tap(find.byKey(const Key('equipment_categories_button')));
    await tester.pumpAndSettle();

    expect(find.text('Categorias de equipamento'), findsOneWidget);
    expect(find.text('Som'), findsOneWidget);
  });
}
