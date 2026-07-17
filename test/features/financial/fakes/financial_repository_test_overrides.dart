import 'package:eventpro/features/financial/providers/financial_category_repository_provider.dart';
import 'package:eventpro/features/financial/providers/financial_clock_provider.dart';
import 'package:eventpro/features/financial/providers/financial_entry_repository_provider.dart';
import 'package:flutter_riverpod/misc.dart';

import 'fake_financial_category_repository.dart';
import 'fake_financial_entry_repository.dart';

List<Override> financialRepositoryOverrides({
  FakeFinancialEntryRepository? entryRepository,
  FakeFinancialCategoryRepository? categoryRepository,
  DateTime Function()? clock,
}) {
  return [
    financialEntryRepositoryProvider.overrideWithValue(
      entryRepository ?? FakeFinancialEntryRepository(),
    ),
    financialCategoryRepositoryProvider.overrideWithValue(
      categoryRepository ?? FakeFinancialCategoryRepository(),
    ),
    if (clock != null) financialClockProvider.overrideWithValue(clock),
  ];
}
