import '../models/financial_report_period.dart';

/// Resolves a [FinancialReportPeriodKind] into an inclusive civil-date window.
///
/// Uses an injectable [clock] — never calls [DateTime.now] directly — so
/// month/year presets stay deterministic in tests.
abstract class FinancialReportPeriodResolver {
  static FinancialReportPeriod resolve({
    required FinancialReportPeriodKind kind,
    DateTime? customStart,
    DateTime? customEnd,
    DateTime Function()? clock,
  }) {
    final now = (clock ?? DateTime.now)();
    final today = DateTime(now.year, now.month, now.day);

    switch (kind) {
      case FinancialReportPeriodKind.currentMonth:
        final start = DateTime(today.year, today.month, 1);
        final end = DateTime(today.year, today.month + 1, 0);
        return FinancialReportPeriod(
          kind: kind,
          start: start,
          end: end,
        );
      case FinancialReportPeriodKind.currentYear:
        return FinancialReportPeriod(
          kind: kind,
          start: DateTime(today.year, 1, 1),
          end: DateTime(today.year, 12, 31),
        );
      case FinancialReportPeriodKind.custom:
        if (customStart == null || customEnd == null) {
          throw ArgumentError(
            'customStart and customEnd are required for '
            'FinancialReportPeriodKind.custom',
          );
        }
        final start = DateTime(
          customStart.year,
          customStart.month,
          customStart.day,
        );
        final end = DateTime(
          customEnd.year,
          customEnd.month,
          customEnd.day,
        );
        if (end.isBefore(start)) {
          throw ArgumentError('customEnd must be on or after customStart');
        }
        return FinancialReportPeriod(kind: kind, start: start, end: end);
    }
  }
}
