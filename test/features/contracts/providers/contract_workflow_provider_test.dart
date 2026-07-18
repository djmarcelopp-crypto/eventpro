import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/providers/contract_provider.dart';
import 'package:eventpro/features/contracts/providers/contract_workflow_provider.dart';
import 'package:eventpro/features/contracts/providers/contract_workflow_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../contracts_test_helpers.dart';
import '../fakes/contracts_repository_test_overrides.dart';
import '../fakes/fake_contract_repository.dart';
import '../../quotes/fakes/fake_quote_repository.dart';

void main() {
  test('contractWorkflowSummaryProvider tracks allowed transitions', () async {
    final now = DateTime(2026, 7, 17, 12);
    final container = ProviderContainer(
      overrides: contractsRepositoryOverrides(
        contractRepository: FakeContractRepository(
          initialContracts: [
            buildTestContract(
              id: 'c-1',
              status: ContractStatus.generated,
              generatedAt: now,
            ),
          ],
        ),
        quoteRepository: FakeQuoteRepository(
          initialQuotes: [buildTestQuote()],
        ),
        clock: () => now,
      ),
    );
    addTearDown(container.dispose);

    await container.read(contractProvider.future);
    final summaryAsync = container.read(contractWorkflowSummaryProvider('c-1'));
    final summary = summaryAsync.value;
    expect(summary, isNotNull);
    expect(summary!.canMarkSent, isTrue);
    expect(summary.canCancel, isTrue);

    final workflow = container.read(contractWorkflowServiceProvider);
    final sent = await workflow.markSent('c-1');
    expect(sent.isSuccess, isTrue);

    await container.read(contractProvider.notifier).reload();
    final afterSent =
        container.read(contractWorkflowSummaryProvider('c-1')).value!;
    expect(afterSent.canSign, isTrue);
    expect(afterSent.canMarkSent, isFalse);
  });
}
