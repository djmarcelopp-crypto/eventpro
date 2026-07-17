import 'financial_report_period.dart';

/// UI/state selection for which period report to display.
class FinancialReportQuery {
  const FinancialReportQuery({
    this.kind = FinancialReportPeriodKind.currentMonth,
    this.customStart,
    this.customEnd,
  });

  static const currentMonth = FinancialReportQuery();

  final FinancialReportPeriodKind kind;
  final DateTime? customStart;
  final DateTime? customEnd;

  FinancialReportQuery copyWith({
    FinancialReportPeriodKind? kind,
    DateTime? customStart,
    DateTime? customEnd,
    bool clearCustomStart = false,
    bool clearCustomEnd = false,
  }) {
    return FinancialReportQuery(
      kind: kind ?? this.kind,
      customStart: clearCustomStart
          ? null
          : (customStart ?? this.customStart),
      customEnd: clearCustomEnd ? null : (customEnd ?? this.customEnd),
    );
  }
}
