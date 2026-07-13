import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quote.dart';
import '../models/quote_status.dart';
import '../models/quote_status_history_entry.dart';
import '../utils/quote_calculator.dart';
import '../utils/quote_status_transitions.dart';
import 'quote_clock_provider.dart';
import 'quote_number_generator.dart';

class QuotesNotifier extends Notifier<List<Quote>> {
  final QuoteNumberGenerator _numberGenerator = QuoteNumberGenerator();

  @override
  List<Quote> build() => [];

  QuoteNumberGenerator get numberGenerator => _numberGenerator;

  DateTime _now() => ref.read(quoteClockProvider)();

  bool addQuote(Quote draft) {
    final now = _now();
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
      number: _numberGenerator.nextNumber(),
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
      createdAt: now,
      updatedAt: now,
      approvedAt: null,
    );

    state = [...state, quote];
    return true;
  }

  Quote? findById(String id) {
    for (final quote in state) {
      if (quote.id == id) {
        return quote;
      }
    }
    return null;
  }

  bool updateQuote(Quote quote) {
    final existing = findById(quote.id);
    if (existing == null || existing.status != QuoteStatus.draft) {
      return false;
    }

    final items = [
      for (final item in quote.items)
        QuoteCalculator.withCalculatedLineTotal(item),
    ];
    final subtotalCents = QuoteCalculator.subtotalCents(items);
    final totalCents = QuoteCalculator.totalCents(
      subtotalCents: subtotalCents,
      discountCents: quote.discountCents,
      freightCents: quote.freightCents,
    );

    final updated = Quote(
      id: existing.id,
      number: existing.number,
      status: existing.status,
      clientSnapshot: quote.clientSnapshot,
      eventSnapshot: quote.eventSnapshot,
      items: items,
      subtotalCents: subtotalCents,
      discountCents: quote.discountCents,
      freightCents: quote.freightCents,
      totalCents: totalCents,
      statusHistory: existing.statusHistory,
      validUntil: quote.validUntil,
      notes: quote.notes,
      internalNotes: quote.internalNotes,
      createdAt: existing.createdAt,
      updatedAt: _now(),
      approvedAt: existing.approvedAt,
    );

    state = [
      for (final current in state)
        if (current.id == updated.id) updated else current,
    ];
    return true;
  }

  bool transitionStatus(String id, QuoteStatus target) {
    final existing = findById(id);
    if (existing == null) {
      return false;
    }

    if (!QuoteStatusTransitions.isAllowed(existing.status, target)) {
      return false;
    }

    final now = _now();
    final historyEntry = QuoteStatusHistoryEntry(
      previousStatus: existing.status,
      newStatus: target,
      changedAt: now,
    );

    final reopeningForEditing = existing.status == QuoteStatus.approved &&
        target == QuoteStatus.draft;

    final updated = existing.copyWith(
      status: target,
      updatedAt: now,
      approvedAt: target == QuoteStatus.approved ? now : null,
      clearApprovedAt: reopeningForEditing,
      statusHistory: [...existing.statusHistory, historyEntry],
    );

    state = [
      for (final current in state)
        if (current.id == updated.id) updated else current,
    ];
    return true;
  }
}

final quotesProvider =
    NotifierProvider<QuotesNotifier, List<Quote>>(QuotesNotifier.new);
