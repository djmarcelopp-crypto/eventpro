import 'financial_category_total.dart';
import 'financial_global_summary.dart';
import 'financial_monthly_evolution_point.dart';
import 'financial_report_period.dart';

/// Full period report (TASK-027 CP-F).
///
/// Money totals live in [summary], produced exclusively by
/// [FinancialGlobalSummaryCalculator]. Counts, category breakdown and monthly
/// evolution are additional projections over the same filtered entry set.
class FinancialPeriodReport {
  FinancialPeriodReport({
    required this.period,
    required this.summary,
    required this.entryCount,
    required this.pendingEntryCount,
    required List<FinancialCategoryTotal> categoryTotals,
    required List<FinancialMonthlyEvolutionPoint> monthlyEvolution,
  }) : categoryTotals = List.unmodifiable(categoryTotals),
       monthlyEvolution = List.unmodifiable(monthlyEvolution);

  final FinancialReportPeriod period;
  final FinancialGlobalSummary summary;
  final int entryCount;
  final int pendingEntryCount;
  final List<FinancialCategoryTotal> categoryTotals;
  final List<FinancialMonthlyEvolutionPoint> monthlyEvolution;

  int get totalIncomeCents => summary.totalIncomeCents;
  int get totalExpenseCents => summary.totalExpenseCents;
  int get balanceCents => summary.balanceCents;
  int get pendingCents => summary.pendingCents;
}
