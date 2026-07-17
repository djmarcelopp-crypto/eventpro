import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/repositories/drift_financial_category_repository.dart';
import '../data/repositories/financial_category_repository.dart';

final financialCategoryRepositoryProvider =
    Provider<FinancialCategoryRepository>((ref) {
      final database = ref.watch(appDatabaseProvider);
      return DriftFinancialCategoryRepository(database);
    });
