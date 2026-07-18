import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/models/financial_report_period.dart';
import 'package:eventpro/features/financial/utils/financial_period_report_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialPeriodReportService', () {
    final createdAt = DateTime(2026, 1, 1);
    final categories = [
      FinancialCategory(
        id: 'cat-income',
        name: 'Eventos',
        kind: FinancialFlowKind.income,
        createdAt: createdAt,
      ),
    ];

    test('uses injectable clock for currentMonth preset', () {
      final service = FinancialPeriodReportService(
        clock: () => DateTime(2026, 8, 17),
      );
      final report = service.build(
        kind: FinancialReportPeriodKind.currentMonth,
        entries: [
          FinancialEntry(
            id: 'in',
            kind: FinancialFlowKind.income,
            description: 'Agosto',
            amountCents: 10000,
            date: DateTime(2026, 8, 5),
            categoryId: 'cat-income',
            createdAt: createdAt,
            updatedAt: createdAt,
          ),
          FinancialEntry(
            id: 'out',
            kind: FinancialFlowKind.income,
            description: 'Julho',
            amountCents: 99999,
            date: DateTime(2026, 7, 5),
            categoryId: 'cat-income',
            createdAt: createdAt,
            updatedAt: createdAt,
          ),
        ],
        categories: categories,
      );

      expect(report.period.start, DateTime(2026, 8, 1));
      expect(report.period.end, DateTime(2026, 8, 31));
      expect(report.entryCount, 1);
      expect(report.totalIncomeCents, 10000);
    });

    test('builds currentYear report spanning all months of the year', () {
      final service = FinancialPeriodReportService(
        clock: () => DateTime(2026, 3, 1),
      );
      final report = service.build(
        kind: FinancialReportPeriodKind.currentYear,
        entries: const [],
        categories: categories,
      );

      expect(report.period.start, DateTime(2026, 1, 1));
      expect(report.period.end, DateTime(2026, 12, 31));
      expect(report.monthlyEvolution, hasLength(12));
    });
  });
}
