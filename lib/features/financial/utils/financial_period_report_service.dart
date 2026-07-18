import '../models/financial_category.dart';
import '../models/financial_entry.dart';
import '../models/financial_period_report.dart';
import '../models/financial_report_period.dart';
import 'financial_period_report_calculator.dart';
import 'financial_report_period_resolver.dart';

/// Orchestrates period resolution and report calculation (TASK-027 CP-F).
///
/// Keeps period presets (month/year) testable via an injectable [clock] and
/// delegates every aggregation to [FinancialPeriodReportCalculator].
class FinancialPeriodReportService {
  FinancialPeriodReportService({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  FinancialPeriodReport build({
    required FinancialReportPeriodKind kind,
    required List<FinancialEntry> entries,
    required List<FinancialCategory> categories,
    DateTime? customStart,
    DateTime? customEnd,
  }) {
    final period = FinancialReportPeriodResolver.resolve(
      kind: kind,
      customStart: customStart,
      customEnd: customEnd,
      clock: _clock,
    );
    return FinancialPeriodReportCalculator.calculate(
      period: period,
      entries: entries,
      categories: categories,
    );
  }
}
