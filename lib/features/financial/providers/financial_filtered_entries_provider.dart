import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/financial_entry.dart';
import '../utils/financial_entry_filter.dart';
import 'financial_entries_provider.dart';
import 'financial_entry_filters_provider.dart';

/// Entries after applying [financialEntryFiltersProvider], preserving the
/// chronological order already maintained by [financialEntriesProvider].
final financialFilteredEntriesProvider =
    Provider<AsyncValue<List<FinancialEntry>>>((ref) {
      final entriesAsync = ref.watch(financialEntriesProvider);
      final filters = ref.watch(financialEntryFiltersProvider);

      return entriesAsync.whenData(
        (entries) => FinancialEntryFilter.apply(entries, filters),
      );
    });
