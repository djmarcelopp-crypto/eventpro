import 'package:eventpro/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/contract_repository.dart';
import '../data/repositories/drift_contract_repository.dart';

final contractRepositoryProvider = Provider<ContractRepository>((ref) {
  return DriftContractRepository(ref.watch(appDatabaseProvider));
});
