import 'financial_entry_status.dart';
import 'financial_flow_kind.dart';

/// UI filter criteria for the financial entry list (TASK-027 CP-E).
///
/// Applied by [FinancialEntryFilter] — never filtered ad-hoc inside widgets.
class FinancialEntryFilters {
  const FinancialEntryFilters({
    this.periodStart,
    this.periodEnd,
    this.kind,
    this.status,
  });

  static const empty = FinancialEntryFilters();

  /// Inclusive civil-date start of the period filter (date-only).
  final DateTime? periodStart;

  /// Inclusive civil-date end of the period filter (date-only).
  final DateTime? periodEnd;

  final FinancialFlowKind? kind;
  final FinancialEntryStatus? status;

  bool get isEmpty =>
      periodStart == null &&
      periodEnd == null &&
      kind == null &&
      status == null;

  bool get hasActiveFilters => !isEmpty;

  FinancialEntryFilters copyWith({
    DateTime? periodStart,
    DateTime? periodEnd,
    FinancialFlowKind? kind,
    FinancialEntryStatus? status,
    bool clearPeriodStart = false,
    bool clearPeriodEnd = false,
    bool clearKind = false,
    bool clearStatus = false,
  }) {
    return FinancialEntryFilters(
      periodStart: clearPeriodStart ? null : (periodStart ?? this.periodStart),
      periodEnd: clearPeriodEnd ? null : (periodEnd ?? this.periodEnd),
      kind: clearKind ? null : (kind ?? this.kind),
      status: clearStatus ? null : (status ?? this.status),
    );
  }
}
