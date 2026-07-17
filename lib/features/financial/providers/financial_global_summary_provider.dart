import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/financial_global_summary.dart';
import '../utils/financial_global_summary_calculator.dart';
import 'financial_filtered_entries_provider.dart';

/// Global financial summary derived from the currently filtered entry list.
/// Aggregation lives entirely in [FinancialGlobalSummaryCalculator] — widgets
/// only present the numbers.
final financialGlobalSummaryProvider =
    Provider<AsyncValue<FinancialGlobalSummary>>((ref) {
      final entriesAsync = ref.watch(financialFilteredEntriesProvider);

      return entriesAsync.whenData(
        FinancialGlobalSummaryCalculator.calculate,
      );
    });
