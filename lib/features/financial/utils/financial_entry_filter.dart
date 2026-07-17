import '../models/financial_entry.dart';
import '../models/financial_entry_filters.dart';

/// Pure filter that applies [FinancialEntryFilters] to a list of entries.
///
/// Date comparisons use civil date only (year/month/day), matching the
/// domain meaning of [FinancialEntry.date].
abstract class FinancialEntryFilter {
  static List<FinancialEntry> apply(
    List<FinancialEntry> entries,
    FinancialEntryFilters filters,
  ) {
    if (filters.isEmpty) {
      return List<FinancialEntry>.unmodifiable(entries);
    }

    final start = filters.periodStart == null
        ? null
        : DateTime(
            filters.periodStart!.year,
            filters.periodStart!.month,
            filters.periodStart!.day,
          );
    final end = filters.periodEnd == null
        ? null
        : DateTime(
            filters.periodEnd!.year,
            filters.periodEnd!.month,
            filters.periodEnd!.day,
          );

    final filtered = entries.where((entry) {
      final entryDate = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );

      if (start != null && entryDate.isBefore(start)) {
        return false;
      }
      if (end != null && entryDate.isAfter(end)) {
        return false;
      }
      if (filters.kind != null && entry.kind != filters.kind) {
        return false;
      }
      if (filters.status != null && entry.status != filters.status) {
        return false;
      }
      return true;
    }).toList(growable: false);

    return List<FinancialEntry>.unmodifiable(filtered);
  }
}
