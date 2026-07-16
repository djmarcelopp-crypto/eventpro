import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';

import '../utils/agenda_event_interval_resolver.dart';
import 'agenda_block.dart';

enum AgendaOccupancyKind { proposal, confirmed, block }

/// Read-only, computed occupancy entry. Never persisted directly — always
/// derived from a [Quote] (proposal/confirmed) or an [AgendaBlock] (manual
/// block), combined in `agendaOccupancyProvider`.
class AgendaOccupancy {
  const AgendaOccupancy({
    required this.id,
    required this.kind,
    required this.title,
    required this.start,
    required this.end,
    this.sourceQuoteId,
    this.sourceBlockId,
  });

  final String id;
  final AgendaOccupancyKind kind;
  final String title;
  final DateTime start;
  final DateTime end;
  final String? sourceQuoteId;
  final String? sourceBlockId;

  /// Returns `null` when the quote's status is ignored for agenda purposes
  /// (rejected/cancelled) or when the event snapshot has no date.
  static AgendaOccupancy? fromQuote(Quote quote) {
    final kind = _kindForStatus(quote.status);
    if (kind == null) {
      return null;
    }

    final interval = AgendaEventIntervalResolver.resolve(quote.eventSnapshot);
    if (interval == null) {
      return null;
    }

    final snapshotName = quote.eventSnapshot.name?.trim();
    final title = (snapshotName == null || snapshotName.isEmpty)
        ? quote.number
        : snapshotName;

    return AgendaOccupancy(
      id: 'quote-${quote.id}',
      kind: kind,
      title: title,
      start: interval.start,
      end: interval.end,
      sourceQuoteId: quote.id,
    );
  }

  static AgendaOccupancy fromBlock(AgendaBlock block) {
    return AgendaOccupancy(
      id: 'block-${block.id}',
      kind: AgendaOccupancyKind.block,
      title: block.title,
      start: block.start,
      end: block.end,
      sourceBlockId: block.id,
    );
  }

  static AgendaOccupancyKind? _kindForStatus(QuoteStatus status) {
    switch (status) {
      case QuoteStatus.draft:
      case QuoteStatus.sent:
        return AgendaOccupancyKind.proposal;
      case QuoteStatus.approved:
        return AgendaOccupancyKind.confirmed;
      case QuoteStatus.rejected:
      case QuoteStatus.cancelled:
        return null;
    }
  }
}
