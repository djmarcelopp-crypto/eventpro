import 'package:eventpro/features/financial/models/financial_report_period.dart';
import 'package:eventpro/features/financial/utils/financial_report_period_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialReportPeriodResolver', () {
    DateTime clock() => DateTime(2026, 8, 17, 15, 30);

    test('resolves currentMonth to inclusive civil bounds', () {
      final period = FinancialReportPeriodResolver.resolve(
        kind: FinancialReportPeriodKind.currentMonth,
        clock: clock,
      );

      expect(period.start, DateTime(2026, 8, 1));
      expect(period.end, DateTime(2026, 8, 31));
      expect(period.kind, FinancialReportPeriodKind.currentMonth);
    });

    test('resolves currentYear to Jan 1 – Dec 31', () {
      final period = FinancialReportPeriodResolver.resolve(
        kind: FinancialReportPeriodKind.currentYear,
        clock: clock,
      );

      expect(period.start, DateTime(2026, 1, 1));
      expect(period.end, DateTime(2026, 12, 31));
    });

    test('resolves February currentMonth across non-leap years', () {
      final period = FinancialReportPeriodResolver.resolve(
        kind: FinancialReportPeriodKind.currentMonth,
        clock: () => DateTime(2026, 2, 10),
      );

      expect(period.start, DateTime(2026, 2, 1));
      expect(period.end, DateTime(2026, 2, 28));
    });

    test('resolves custom period stripping time-of-day', () {
      final period = FinancialReportPeriodResolver.resolve(
        kind: FinancialReportPeriodKind.custom,
        customStart: DateTime(2026, 3, 5, 9, 0),
        customEnd: DateTime(2026, 3, 20, 18, 0),
        clock: clock,
      );

      expect(period.start, DateTime(2026, 3, 5));
      expect(period.end, DateTime(2026, 3, 20));
    });

    test('throws when custom dates are missing', () {
      expect(
        () => FinancialReportPeriodResolver.resolve(
          kind: FinancialReportPeriodKind.custom,
          clock: clock,
        ),
        throwsArgumentError,
      );
    });

    test('throws when custom end is before start', () {
      expect(
        () => FinancialReportPeriodResolver.resolve(
          kind: FinancialReportPeriodKind.custom,
          customStart: DateTime(2026, 4, 10),
          customEnd: DateTime(2026, 4, 1),
          clock: clock,
        ),
        throwsArgumentError,
      );
    });
  });
}
