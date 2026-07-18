import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/financial_entry_filters.dart';
import '../models/financial_entry_status.dart';
import '../models/financial_flow_kind.dart';

class FinancialEntryFiltersNotifier extends Notifier<FinancialEntryFilters> {
  @override
  FinancialEntryFilters build() => FinancialEntryFilters.empty;

  void setPeriod({DateTime? start, DateTime? end}) {
    state = state.copyWith(
      periodStart: start,
      periodEnd: end,
      clearPeriodStart: start == null,
      clearPeriodEnd: end == null,
    );
  }

  void setKind(FinancialFlowKind? kind) {
    state = state.copyWith(kind: kind, clearKind: kind == null);
  }

  void setStatus(FinancialEntryStatus? status) {
    state = state.copyWith(status: status, clearStatus: status == null);
  }

  void clear() {
    state = FinancialEntryFilters.empty;
  }
}

final financialEntryFiltersProvider =
    NotifierProvider<FinancialEntryFiltersNotifier, FinancialEntryFilters>(
      FinancialEntryFiltersNotifier.new,
    );
