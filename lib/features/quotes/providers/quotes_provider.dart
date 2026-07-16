import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/quote_repository.dart';
import '../models/quote.dart';
import '../models/quote_status.dart';
import '../models/quote_status_history_entry.dart';
import '../utils/quote_calculator.dart';
import '../utils/quote_status_transitions.dart';
import 'quote_clock_provider.dart';
import 'quote_repository_provider.dart';

class QuotesNotifier extends Notifier<List<Quote>> {
  QuoteRepository get _repository => ref.read(quoteRepositoryProvider);

  @override
  List<Quote> build() => [];

  DateTime _now() => ref.read(quoteClockProvider)();

  Future<bool> addQuote(Quote draft) async {
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

    try {
      final persisted = await _repository.insert(quote);
      state = [...state, persisted];
      return true;
    } catch (_) {
      return false;
    }
  }

  Quote? findById(String id) {
    for (final quote in state) {
      if (quote.id == id) {
        return quote;
      }
    }
    return null;
  }

  Future<bool> updateQuote(Quote quote) async {
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
      companySnapshot: existing.companySnapshot,
      createdAt: existing.createdAt,
      updatedAt: _now(),
      approvedAt: existing.approvedAt,
    );

    try {
      await _repository.update(updated);
      state = [
        for (final current in state)
          if (current.id == updated.id) updated else current,
      ];
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> transitionStatus(String id, QuoteStatus target) async {
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

    final reopeningForEditing =
        existing.status == QuoteStatus.approved && target == QuoteStatus.draft;

    final updated = existing.copyWith(
      status: target,
      updatedAt: now,
      approvedAt: target == QuoteStatus.approved ? now : null,
      clearApprovedAt: reopeningForEditing,
      statusHistory: [...existing.statusHistory, historyEntry],
    );

    try {
      await _repository.update(updated);
      state = [
        for (final current in state)
          if (current.id == updated.id) updated else current,
      ];
      return true;
    } catch (_) {
      return false;
    }
  }
}

final quotesProvider =
    NotifierProvider<QuotesNotifier, List<Quote>>(QuotesNotifier.new);
