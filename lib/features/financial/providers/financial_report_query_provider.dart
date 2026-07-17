import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/financial_report_period.dart';
import '../models/financial_report_query.dart';

class FinancialReportQueryNotifier extends Notifier<FinancialReportQuery> {
  @override
  FinancialReportQuery build() => FinancialReportQuery.currentMonth;

  void selectPreset(FinancialReportPeriodKind kind) {
    if (kind == FinancialReportPeriodKind.custom) {
      state = state.copyWith(kind: kind);
      return;
    }
    state = FinancialReportQuery(kind: kind);
  }

  void setCustomPeriod({required DateTime start, required DateTime end}) {
    state = FinancialReportQuery(
      kind: FinancialReportPeriodKind.custom,
      customStart: DateTime(start.year, start.month, start.day),
      customEnd: DateTime(end.year, end.month, end.day),
    );
  }
}

final financialReportQueryProvider =
    NotifierProvider<FinancialReportQueryNotifier, FinancialReportQuery>(
      FinancialReportQueryNotifier.new,
    );
