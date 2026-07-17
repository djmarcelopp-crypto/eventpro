import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/financial_period_report.dart';
import '../models/financial_report_period.dart';
import 'financial_categories_provider.dart';
import 'financial_entries_provider.dart';
import 'financial_period_report_service_provider.dart';
import 'financial_report_query_provider.dart';

/// Period report derived from the full entry list (not the list-screen
/// filters), categories, and the selected [financialReportQueryProvider].
///
/// Aggregation stays inside [FinancialPeriodReportService] /
/// [FinancialPeriodReportCalculator] — widgets only present the result.
final financialPeriodReportProvider =
    Provider<AsyncValue<FinancialPeriodReport>>((ref) {
      final entriesAsync = ref.watch(financialEntriesProvider);
      final categoriesAsync = ref.watch(financialCategoriesProvider);
      final query = ref.watch(financialReportQueryProvider);
      final service = ref.watch(financialPeriodReportServiceProvider);

      if (entriesAsync.hasError) {
        return AsyncValue.error(
          entriesAsync.error!,
          entriesAsync.stackTrace ?? StackTrace.current,
        );
      }
      if (categoriesAsync.hasError) {
        return AsyncValue.error(
          categoriesAsync.error!,
          categoriesAsync.stackTrace ?? StackTrace.current,
        );
      }
      if (!entriesAsync.hasValue || !categoriesAsync.hasValue) {
        return const AsyncValue.loading();
      }

      if (query.kind == FinancialReportPeriodKind.custom &&
          (query.customStart == null || query.customEnd == null)) {
        // Custom selected but dates not picked yet — wait without crashing.
        return const AsyncValue.loading();
      }

      final report = service.build(
        kind: query.kind,
        entries: entriesAsync.value!,
        categories: categoriesAsync.value!,
        customStart: query.customStart,
        customEnd: query.customEnd,
      );
      return AsyncValue.data(report);
    });
