import 'financial_entry.dart';

/// Financial indicators for a single event/quote (TASK-027 CP-D), computed
/// purely from the [FinancialEntry] records already linked to it via
/// [FinancialEntry.quoteId] — never a copy of event or quote data.
class FinancialEventSummary {
  FinancialEventSummary({
    required this.quoteId,
    required List<FinancialEntry> entries,
    required this.totalIncomeCents,
    required this.totalExpenseCents,
  }) : entries = List.unmodifiable(entries);

  final String quoteId;

  /// Entries linked to [quoteId], ordered by `date`.
  final List<FinancialEntry> entries;

  final int totalIncomeCents;
  final int totalExpenseCents;

  int get profitCents => totalIncomeCents - totalExpenseCents;

  bool get hasEntries => entries.isNotEmpty;
}
