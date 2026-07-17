import '../models/financial_entry.dart';
import '../models/financial_event_summary.dart';
import '../models/financial_flow_kind.dart';

/// Pure computation of financial indicators (total revenue, total expense,
/// profit) for a single event/quote, out of a list of [FinancialEntry].
///
/// No repository, database, or Riverpod dependency — only combines data
/// that is already provided, mirroring the pure-calculator pattern used by
/// `AgendaOverlapChecker` in the Agenda module.
abstract class FinancialEventSummaryCalculator {
  static FinancialEventSummary calculate(
    String quoteId,
    List<FinancialEntry> entries,
  ) {
    final linkedEntries = entries.where((entry) => entry.quoteId == quoteId);

    var totalIncomeCents = 0;
    var totalExpenseCents = 0;
    for (final entry in linkedEntries) {
      if (entry.kind == FinancialFlowKind.income) {
        totalIncomeCents += entry.amountCents;
      } else {
        totalExpenseCents += entry.amountCents;
      }
    }

    final sortedEntries = linkedEntries.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return FinancialEventSummary(
      quoteId: quoteId,
      entries: sortedEntries,
      totalIncomeCents: totalIncomeCents,
      totalExpenseCents: totalExpenseCents,
    );
  }
}
