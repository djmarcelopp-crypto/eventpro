import 'package:eventpro/features/contracts/models/contract_template.dart';
import 'package:eventpro/features/contracts/providers/contract_template_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contracts_test_helpers.dart';

void main() {
  testWidgets('lists templates and creates a new one via notifier', (tester) async {
    final container = await pumpContractsApp(
      tester,
      initialLocation: '/contracts/templates',
      templates: [buildTestTemplate(name: 'Padrão')],
    );

    expect(find.text('Padrão'), findsOneWidget);
    expect(find.byKey(const Key('contract_template_add')), findsOneWidget);

    final now = DateTime(2026, 7, 17);
    final result =
        await container.read(contractTemplateProvider.notifier).addTemplate(
              ContractTemplate(
                id: '',
                name: 'Premium',
                createdAt: now,
                updatedAt: now,
              ),
            );
    expect(result.isSuccess, isTrue);
    await tester.pumpAndSettle();

    final templates = container.read(contractTemplateProvider).value!;
    expect(templates.map((t) => t.name), containsAll(['Padrão', 'Premium']));
    expect(find.text('Premium'), findsOneWidget);
  });

  testWidgets('opens create dialog from add button', (tester) async {
    await pumpContractsApp(
      tester,
      initialLocation: '/contracts/templates',
      templates: [buildTestTemplate(name: 'Padrão')],
    );

    await tester.tap(find.byKey(const Key('contract_template_add')));
    await tester.pumpAndSettle();

    expect(find.text('Novo modelo'), findsOneWidget);
    expect(find.byKey(const Key('contract_template_form_name')), findsOneWidget);
    expect(find.byKey(const Key('contract_template_form_save')), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
  });

  testWidgets('deactivates and activates a template', (tester) async {
    final container = await pumpContractsApp(
      tester,
      initialLocation: '/contracts/templates',
      templates: [buildTestTemplate(id: 'template-1', name: 'Padrão')],
    );

    await tester.tap(find.byKey(const Key('contract_template_toggle_template-1')));
    await tester.pumpAndSettle();

    expect(
      container.read(contractTemplateProvider).value!.single.active,
      isFalse,
    );

    await tester.tap(find.byKey(const Key('contract_template_toggle_template-1')));
    await tester.pumpAndSettle();

    expect(
      container.read(contractTemplateProvider).value!.single.active,
      isTrue,
    );
  });
}
