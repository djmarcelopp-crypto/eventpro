/// One month bucket prepared for future charting (TASK-027 CP-F).
///
/// Income/expense come from [FinancialGlobalSummaryCalculator] applied to the
/// month's entries — never recalculated with a different formula.
class FinancialMonthlyEvolutionPoint {
  const FinancialMonthlyEvolutionPoint({
    required this.year,
    required this.month,
    required this.incomeCents,
    required this.expenseCents,
  });

  final int year;

  /// Calendar month in the range `1..12`.
  final int month;

  final int incomeCents;
  final int expenseCents;

  int get balanceCents => incomeCents - expenseCents;
}
