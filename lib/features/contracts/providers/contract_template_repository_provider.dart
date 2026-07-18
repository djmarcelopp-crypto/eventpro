import 'package:eventpro/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/contract_template_repository.dart';
import '../data/repositories/drift_contract_template_repository.dart';

final contractTemplateRepositoryProvider =
    Provider<ContractTemplateRepository>((ref) {
  return DriftContractTemplateRepository(ref.watch(appDatabaseProvider));
});
