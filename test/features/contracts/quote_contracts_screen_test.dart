import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/providers/quote_contract_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'contracts_test_helpers.dart';

void main() {
  testWidgets('shows empty quote contracts and generates one', (tester) async {
    final container = await pumpContractsApp(
      tester,
      initialLocation: '/quotes/quote-1/contracts',
      quotes: [buildTestQuote()],
      contracts: const [],
      templates: [buildTestTemplate()],
    );

    expect(find.textContaining('Nenhum contrato'), findsOneWidget);

    await tester.tap(find.byKey(const Key('quote_contract_generate')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('quote_contract_form_save')));
    await tester.pumpAndSettle();

    final items = container.read(quoteContractProvider('quote-1')).value!;
    expect(items, hasLength(1));
    expect(items.single.status, ContractStatus.generated);
    expect(find.byKey(const Key('quote_contract_summary_status')), findsOneWidget);
  });

  testWidgets('shows dates and cancels a quote contract', (tester) async {
    final container = await pumpContractsApp(
      tester,
      initialLocation: '/quotes/quote-1/contracts',
      quotes: [buildTestQuote()],
      contracts: [
        buildTestContract(
          id: 'c-1',
          quoteId: 'quote-1',
          status: ContractStatus.generated,
          generatedAt: DateTime(2026, 1, 2),
        ),
      ],
    );

    expect(find.textContaining('Gerado:'), findsOneWidget);

    await tester.tap(find.byKey(const Key('quote_contract_cancel_c-1')));
    await tester.pumpAndSettle();

    final items = container.read(quoteContractProvider('quote-1')).value!;
    expect(items.single.status, ContractStatus.cancelled);
  });
}
