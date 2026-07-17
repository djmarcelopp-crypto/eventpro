/// Aggregated financial indicators across a set of entries (TASK-027 CP-E).
///
/// Computed by [FinancialGlobalSummaryCalculator] — never recalculated in
/// widgets. Distinct from [FinancialEventSummary], which is scoped to a
/// single quote/event.
class FinancialGlobalSummary {
  const FinancialGlobalSummary({
    required this.totalIncomeCents,
    required this.totalExpenseCents,
    required this.pendingCents,
  });

  static const empty = FinancialGlobalSummary(
    totalIncomeCents: 0,
    totalExpenseCents: 0,
    pendingCents: 0,
  );

  final int totalIncomeCents;
  final int totalExpenseCents;

  /// Sum of [FinancialEntry.amountCents] for entries still pending settlement.
  final int pendingCents;

  int get balanceCents => totalIncomeCents - totalExpenseCents;
}
