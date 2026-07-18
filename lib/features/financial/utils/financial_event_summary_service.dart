import '../data/repositories/financial_entry_repository.dart';
import '../models/financial_event_summary.dart';
import 'financial_event_summary_calculator.dart';

/// Thin orchestrator that fetches the [FinancialEntry] records linked to an
/// event/quote and delegates the actual computation to
/// [FinancialEventSummaryCalculator]. Keeps the query concern (repository)
/// separate from the pure calculation, so the calculator stays trivially
/// testable without any persistence double.
class FinancialEventSummaryService {
  FinancialEventSummaryService({
    required FinancialEntryRepository entryRepository,
  }) : _entryRepository = entryRepository;

  final FinancialEntryRepository _entryRepository;

  Future<FinancialEventSummary> summaryForQuote(String quoteId) async {
    final entries = await _entryRepository.listByQuoteId(quoteId);
    return FinancialEventSummaryCalculator.calculate(quoteId, entries);
  }
}
