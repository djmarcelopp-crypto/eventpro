import '../models/financial_entry.dart';
import '../models/financial_entry_status.dart';
import '../models/financial_flow_kind.dart';
import '../models/financial_global_summary.dart';

/// Pure aggregation of global financial indicators from a list of entries.
///
/// No repository, Riverpod or Flutter dependency — mirrors the pattern of
/// [FinancialEventSummaryCalculator] but for the whole filtered set, not a
/// single quote.
abstract class FinancialGlobalSummaryCalculator {
  static FinancialGlobalSummary calculate(List<FinancialEntry> entries) {
    var totalIncomeCents = 0;
    var totalExpenseCents = 0;
    var pendingCents = 0;

    for (final entry in entries) {
      if (entry.kind == FinancialFlowKind.income) {
        totalIncomeCents += entry.amountCents;
      } else {
        totalExpenseCents += entry.amountCents;
      }
      if (entry.status == FinancialEntryStatus.pending) {
        pendingCents += entry.amountCents;
      }
    }

    return FinancialGlobalSummary(
      totalIncomeCents: totalIncomeCents,
      totalExpenseCents: totalExpenseCents,
      pendingCents: pendingCents,
    );
  }
}
