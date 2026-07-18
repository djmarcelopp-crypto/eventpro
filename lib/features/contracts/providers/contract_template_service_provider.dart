import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/contract_template_service.dart';
import 'contract_repository_provider.dart';
import 'contract_template_repository_provider.dart';
import 'contracts_clock_provider.dart';

final contractTemplateServiceProvider = Provider<ContractTemplateService>((
  ref,
) {
  return ContractTemplateService(
    templateRepository: ref.watch(contractTemplateRepositoryProvider),
    contractRepository: ref.watch(contractRepositoryProvider),
    clock: ref.watch(contractsClockProvider),
  );
});
