/// Preset period for financial period reports (TASK-027 CP-F).
enum FinancialReportPeriodKind {
  /// Explicit [periodStart]/[periodEnd] supplied by the caller.
  custom,

  /// Civil month containing the clock's "now".
  currentMonth,

  /// Civil year containing the clock's "now".
  currentYear,
}

/// Resolved inclusive civil-date window for a report query.
class FinancialReportPeriod {
  const FinancialReportPeriod({
    required this.kind,
    required this.start,
    required this.end,
  });

  final FinancialReportPeriodKind kind;

  /// Inclusive civil-date start (date-only).
  final DateTime start;

  /// Inclusive civil-date end (date-only).
  final DateTime end;
}
