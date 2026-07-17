import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:eventpro/features/equipment/new_equipment_screen.dart';
import 'package:eventpro/features/equipment/providers/equipment_category_provider.dart';
import 'package:eventpro/features/equipment/providers/equipment_provider.dart';
import 'package:eventpro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/equipment_repository_test_overrides.dart';
import 'fakes/fake_equipment_category_repository.dart';
import 'fakes/fake_equipment_repository.dart';

void main() {
  testWidgets('saves a new equipment without GoRouter overlay conflict', (
    tester,
  ) async {
    final equipmentRepository = FakeEquipmentRepository();
    final categoryRepository = FakeEquipmentCategoryRepository(
      initialCategories: [
        EquipmentCategory(
          id: 'cat-sound',
          name: 'Som',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
      ],
    );
    final container = ProviderContainer(
      overrides: equipmentRepositoryOverrides(
        equipmentRepository: equipmentRepository,
        categoryRepository: categoryRepository,
        clock: () => DateTime(2030, 1, 1, 12),
      ),
    );
    addTearDown(container.dispose);

    await container.read(equipmentProvider.future);
    await container.read(equipmentCategoryProvider.future);

    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          scaffoldMessengerKey: EventProApp.scaffoldMessengerKey,
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: TextButton(
                    key: const Key('open_form'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<bool>(
                          builder: (_) => const NewEquipmentScreen(),
                        ),
                      );
                    },
                    child: const Text('Abrir'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open_form')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('equipment_form_name')),
      'Subwoofer',
    );
    await tester.enterText(
      find.byKey(const Key('equipment_form_quantity')),
      '4',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('equipment_form_category')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Som').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('equipment_form_save_button')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(container.read(equipmentProvider).value, hasLength(1));
    expect(
      container.read(equipmentProvider).value!.single.name,
      'Subwoofer',
    );
  });
}
