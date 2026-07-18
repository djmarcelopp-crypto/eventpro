import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/providers/contract_provider.dart';
import 'package:eventpro/features/contracts/providers/contract_template_provider.dart';
import 'package:eventpro/features/contracts/providers/quote_contract_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../contracts_test_helpers.dart';
import '../fakes/contracts_repository_test_overrides.dart';
import '../fakes/fake_contract_repository.dart';
import '../fakes/fake_contract_template_repository.dart';
import '../../quotes/fakes/fake_quote_repository.dart';

void main() {
  group('contractProvider / contractTemplateProvider / quoteContractProvider', () {
    final now = DateTime(2026, 7, 17, 12);

    test('loads templates and contracts', () async {
      final container = ProviderContainer(
        overrides: contractsRepositoryOverrides(
          templateRepository: FakeContractTemplateRepository(
            initialTemplates: [buildTestTemplate()],
          ),
          contractRepository: FakeContractRepository(
            initialContracts: [
              buildTestContract(status: ContractStatus.draft),
            ],
          ),
          quoteRepository: FakeQuoteRepository(
            initialQuotes: [buildTestQuote()],
          ),
          clock: () => now,
        ),
      );
      addTearDown(container.dispose);

      final templates = await container.read(contractTemplateProvider.future);
      final contracts = await container.read(contractProvider.future);

      expect(templates, hasLength(1));
      expect(contracts, hasLength(1));
      expect(contracts.single.status, ContractStatus.draft);
    });

    test('generates and cancels contract for quote via providers', () async {
      final container = ProviderContainer(
        overrides: contractsRepositoryOverrides(
          templateRepository: FakeContractTemplateRepository(
            initialTemplates: [buildTestTemplate()],
          ),
          contractRepository: FakeContractRepository(),
          quoteRepository: FakeQuoteRepository(
            initialQuotes: [buildTestQuote()],
          ),
          clock: () => now,
        ),
      );
      addTearDown(container.dispose);

      await container.read(contractTemplateProvider.future);
      await container.read(quoteContractProvider('quote-1').future);

      final generated = await container
          .read(quoteContractProvider('quote-1').notifier)
          .generate(templateId: 'template-1');
      expect(generated.isSuccess, isTrue);
      expect(generated.contract!.status, ContractStatus.generated);

      final cancelled = await container
          .read(quoteContractProvider('quote-1').notifier)
          .cancel(generated.contract!.id);
      expect(cancelled.isSuccess, isTrue);
      expect(cancelled.contract!.status, ContractStatus.cancelled);
    });
  });
}
