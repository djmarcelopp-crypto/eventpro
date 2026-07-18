import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/financial_entry_service.dart';
import 'financial_category_repository_provider.dart';
import 'financial_clock_provider.dart';
import 'financial_entry_repository_provider.dart';

final financialEntryServiceProvider = Provider<FinancialEntryService>((ref) {
  return FinancialEntryService(
    entryRepository: ref.watch(financialEntryRepositoryProvider),
    categoryRepository: ref.watch(financialCategoryRepositoryProvider),
    clock: ref.watch(financialClockProvider),
  );
});
