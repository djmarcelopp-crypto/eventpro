import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/repositories/drift_financial_entry_repository.dart';
import '../data/repositories/financial_entry_repository.dart';

final financialEntryRepositoryProvider = Provider<FinancialEntryRepository>((
  ref,
) {
  final database = ref.watch(appDatabaseProvider);
  return DriftFinancialEntryRepository(database);
});
