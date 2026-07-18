import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/providers/contract_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contracts_test_helpers.dart';

void main() {
  testWidgets('shows empty state when there are no contracts', (tester) async {
    await pumpContractsApp(tester);

    expect(find.text('Nenhum contrato encontrado'), findsOneWidget);
    expect(find.byKey(const Key('contract_summary_draft')), findsOneWidget);
  });

  testWidgets('shows summary cards and contract list', (tester) async {
    await pumpContractsApp(
      tester,
      contracts: [
        buildTestContract(
          id: 'c-1',
          contractNumber: 'CTR-2026-0001',
          status: ContractStatus.draft,
        ),
        buildTestContract(
          id: 'c-2',
          contractNumber: 'CTR-2026-0002',
          status: ContractStatus.sent,
          generatedAt: DateTime(2026, 1, 2),
          sentAt: DateTime(2026, 1, 3),
        ),
      ],
    );

    expect(find.byKey(const Key('contract_summary_draft')), findsOneWidget);
    expect(find.byKey(const Key('contract_summary_sent')), findsOneWidget);
    expect(find.byKey(const Key('contracts_scroll')), findsOneWidget);
    expect(find.text('CTR-2026-0001'), findsOneWidget);
    expect(find.text('CTR-2026-0002'), findsOneWidget);
  });

  testWidgets('filters contracts by number query', (tester) async {
    await pumpContractsApp(
      tester,
      contracts: [
        buildTestContract(id: 'c-1', contractNumber: 'CTR-2026-0001'),
        buildTestContract(id: 'c-2', contractNumber: 'CTR-2026-0099'),
      ],
    );

    await tester.enterText(
      find.byKey(const Key('contract_filter_number')),
      '0099',
    );
    await tester.pumpAndSettle();

    expect(find.text('CTR-2026-0099'), findsOneWidget);
    expect(find.text('CTR-2026-0001'), findsNothing);
  });

  testWidgets('opens templates screen from contracts list', (tester) async {
    await pumpContractsApp(tester);

    await tester.tap(find.byKey(const Key('contract_templates_button')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Modelos'), findsWidgets);
    expect(find.text('Padrão'), findsOneWidget);
  });

  testWidgets('opens contract detail from list item', (tester) async {
    await pumpContractsApp(
      tester,
      contracts: [
        buildTestContract(
          id: 'c-1',
          contractNumber: 'CTR-2026-0001',
          status: ContractStatus.generated,
          generatedAt: DateTime(2026, 1, 2),
        ),
      ],
    );

    await tester.tap(find.byKey(const Key('contract_list_item_c-1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('contract_detail_card')), findsOneWidget);
    expect(find.text('CTR-2026-0001'), findsWidgets);
  });

  testWidgets('cancels contract via detail screen', (tester) async {
    final container = await pumpContractsApp(
      tester,
      contracts: [
        buildTestContract(
          id: 'c-1',
          contractNumber: 'CTR-2026-0001',
          status: ContractStatus.generated,
          generatedAt: DateTime(2026, 1, 2),
        ),
      ],
    );

    await tester.tap(find.byKey(const Key('contract_list_item_c-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('contract_detail_cancel')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('contract_cancel_confirm')));
    await tester.pumpAndSettle();

    final contracts = container.read(contractProvider).value!;
    expect(contracts.single.status, ContractStatus.cancelled);
  });
}
