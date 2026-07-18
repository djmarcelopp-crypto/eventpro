import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/financial_category_service.dart';
import 'financial_category_repository_provider.dart';
import 'financial_clock_provider.dart';
import 'financial_entry_repository_provider.dart';

final financialCategoryServiceProvider = Provider<FinancialCategoryService>((
  ref,
) {
  return FinancialCategoryService(
    categoryRepository: ref.watch(financialCategoryRepositoryProvider),
    entryRepository: ref.watch(financialEntryRepositoryProvider),
    clock: ref.watch(financialClockProvider),
  );
});
