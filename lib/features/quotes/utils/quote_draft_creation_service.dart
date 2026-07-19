import '../data/repositories/quote_repository.dart';
import '../models/quote.dart';
import '../models/quote_status.dart';
import '../models/quote_status_history_entry.dart';
import 'quote_calculator.dart';

/// Official application service for creating quote drafts.
///
/// Extracted from [QuotesNotifier.addQuote] so the assistant adapter and UI
/// share the same rules without duplicating domain logic.
///
/// Persistence is atomic via [QuoteRepository.insert] → `QuotesDao.insertQuoteGraph`
/// (Drift transaction with automatic rollback on failure).
class QuoteDraftCreationService {
  QuoteDraftCreationService(
    this._repository, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final QuoteRepository _repository;
  final DateTime Function() _clock;

  /// Creates a draft quote. Always forces [QuoteStatus.draft].
  ///
  /// When a quote with the same [Quote.id] already exists, returns an
  /// idempotent replay result instead of inserting a second row.
  Future<QuoteDraftCreationOutcome> createDraft(Quote draft) async {
    try {
      final now = _clock();
      final existing = await _repository.findById(draft.id);
      if (existing != null) {
        if (existing.status != QuoteStatus.draft) {
          return QuoteDraftCreationOutcome.failure(
            'Orçamento existente não está em Draft',
          );
        }
        return QuoteDraftCreationOutcome.idempotent(existing);
      }

      final items = [
        for (final item in draft.items)
          QuoteCalculator.withCalculatedLineTotal(item),
      ];
      final subtotalCents = QuoteCalculator.subtotalCents(items);
      final totalCents = QuoteCalculator.totalCents(
        subtotalCents: subtotalCents,
        discountCents: draft.discountCents,
        freightCents: draft.freightCents,
      );

      final quote = Quote(
        id: draft.id,
        number: draft.number,
        status: QuoteStatus.draft,
        clientSnapshot: draft.clientSnapshot,
        eventSnapshot: draft.eventSnapshot,
        items: items,
        subtotalCents: subtotalCents,
        discountCents: draft.discountCents,
        freightCents: draft.freightCents,
        totalCents: totalCents,
        statusHistory: [
          QuoteStatusHistoryEntry(
            previousStatus: null,
            newStatus: QuoteStatus.draft,
            changedAt: now,
          ),
        ],
        validUntil: draft.validUntil,
        notes: draft.notes,
        internalNotes: draft.internalNotes,
        companySnapshot: draft.companySnapshot,
        createdAt: now,
        updatedAt: now,
        approvedAt: null,
      );

      final persisted = await _repository.insert(quote);
      if (persisted.status != QuoteStatus.draft) {
        return QuoteDraftCreationOutcome.failure(
          'Persistência não produziu Draft',
        );
      }
      return QuoteDraftCreationOutcome.created(persisted);
    } catch (error) {
      return QuoteDraftCreationOutcome.failure(
        'Falha ao persistir rascunho: $error',
        rolledBack: true,
      );
    }
  }
}

class QuoteDraftCreationOutcome {
  const QuoteDraftCreationOutcome._({
    required this.success,
    required this.idempotentReplay,
    required this.rolledBack,
    this.quote,
    this.errorMessage,
  });

  factory QuoteDraftCreationOutcome.created(Quote quote) =>
      QuoteDraftCreationOutcome._(
        success: true,
        idempotentReplay: false,
        rolledBack: false,
        quote: quote,
      );

  factory QuoteDraftCreationOutcome.idempotent(Quote quote) =>
      QuoteDraftCreationOutcome._(
        success: true,
        idempotentReplay: true,
        rolledBack: false,
        quote: quote,
      );

  factory QuoteDraftCreationOutcome.failure(
    String message, {
    bool rolledBack = false,
  }) =>
      QuoteDraftCreationOutcome._(
        success: false,
        idempotentReplay: false,
        rolledBack: rolledBack,
        errorMessage: message,
      );

  final bool success;
  final bool idempotentReplay;
  final bool rolledBack;
  final Quote? quote;
  final String? errorMessage;
}
