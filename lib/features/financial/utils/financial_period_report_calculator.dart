import '../models/financial_category.dart';
import '../models/financial_category_total.dart';
import '../models/financial_entry.dart';
import '../models/financial_entry_filters.dart';
import '../models/financial_entry_status.dart';
import '../models/financial_monthly_evolution_point.dart';
import '../models/financial_period_report.dart';
import '../models/financial_report_period.dart';
import 'financial_entry_filter.dart';
import 'financial_global_summary_calculator.dart';

/// Pure builder for [FinancialPeriodReport].
///
/// Reuses [FinancialEntryFilter] for the period window and
/// [FinancialGlobalSummaryCalculator] for every money aggregation (overall
/// and per-month). Does not touch repositories, Riverpod or Flutter.
abstract class FinancialPeriodReportCalculator {
  static FinancialPeriodReport calculate({
    required FinancialReportPeriod period,
    required List<FinancialEntry> entries,
    required List<FinancialCategory> categories,
  }) {
    final filtered = FinancialEntryFilter.apply(
      entries,
      FinancialEntryFilters(
        periodStart: period.start,
        periodEnd: period.end,
      ),
    );

    final summary = FinancialGlobalSummaryCalculator.calculate(filtered);
    final pendingEntryCount = filtered
        .where((entry) => entry.status == FinancialEntryStatus.pending)
        .length;

    final categoryById = {
      for (final category in categories) category.id: category,
    };

    final categoryTotals = _categoryTotals(filtered, categoryById);
    final monthlyEvolution = _monthlyEvolution(period, filtered);

    return FinancialPeriodReport(
      period: period,
      summary: summary,
      entryCount: filtered.length,
      pendingEntryCount: pendingEntryCount,
      categoryTotals: categoryTotals,
      monthlyEvolution: monthlyEvolution,
    );
  }

  static List<FinancialCategoryTotal> _categoryTotals(
    List<FinancialEntry> entries,
    Map<String, FinancialCategory> categoryById,
  ) {
    final grouped = <String, List<FinancialEntry>>{};
    for (final entry in entries) {
      grouped.putIfAbsent(entry.categoryId, () => []).add(entry);
    }

    final totals = <FinancialCategoryTotal>[];
    for (final entry in grouped.entries) {
      final category = categoryById[entry.key];
      final bucketSummary =
          FinancialGlobalSummaryCalculator.calculate(entry.value);
      final totalCents = bucketSummary.totalIncomeCents +
          bucketSummary.totalExpenseCents;
      totals.add(
        FinancialCategoryTotal(
          categoryId: entry.key,
          categoryName: category?.name ?? 'Categoria removida',
          kind: category?.kind ?? entry.value.first.kind,
          totalCents: totalCents,
          entryCount: entry.value.length,
        ),
      );
    }

    totals.sort((a, b) {
      final byAmount = b.totalCents.compareTo(a.totalCents);
      if (byAmount != 0) {
        return byAmount;
      }
      return a.categoryName.toLowerCase().compareTo(
        b.categoryName.toLowerCase(),
      );
    });
    return totals;
  }

  static List<FinancialMonthlyEvolutionPoint> _monthlyEvolution(
    FinancialReportPeriod period,
    List<FinancialEntry> filtered,
  ) {
    final buckets = <String, List<FinancialEntry>>{};
    for (final entry in filtered) {
      final key = '${entry.date.year}-${entry.date.month}';
      buckets.putIfAbsent(key, () => []).add(entry);
    }

    final points = <FinancialMonthlyEvolutionPoint>[];
    var cursor = DateTime(period.start.year, period.start.month, 1);
    final last = DateTime(period.end.year, period.end.month, 1);

    while (!cursor.isAfter(last)) {
      final key = '${cursor.year}-${cursor.month}';
      final monthEntries = buckets[key] ?? const <FinancialEntry>[];
      final monthSummary =
          FinancialGlobalSummaryCalculator.calculate(monthEntries);
      points.add(
        FinancialMonthlyEvolutionPoint(
          year: cursor.year,
          month: cursor.month,
          incomeCents: monthSummary.totalIncomeCents,
          expenseCents: monthSummary.totalExpenseCents,
        ),
      );
      cursor = DateTime(cursor.year, cursor.month + 1, 1);
    }

    return points;
  }
}
