import 'package:eventpro/features/quotes/providers/quote_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/contract_service.dart';
import 'contract_repository_provider.dart';
import 'contract_template_repository_provider.dart';
import 'contracts_clock_provider.dart';

final contractServiceProvider = Provider<ContractService>((ref) {
  return ContractService(
    contractRepository: ref.watch(contractRepositoryProvider),
    templateRepository: ref.watch(contractTemplateRepositoryProvider),
    quoteRepository: ref.watch(quoteRepositoryProvider),
    clock: ref.watch(contractsClockProvider),
  );
});
