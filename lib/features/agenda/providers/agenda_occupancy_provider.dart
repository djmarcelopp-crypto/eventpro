import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';

import '../models/agenda_occupancy.dart';
import 'agenda_blocks_provider.dart';

/// Computed, read-only occupancy list combining [quotesProvider] (proposals
/// and confirmed events) with [agendaBlocksProvider] (manual blocks). Holds
/// no state of its own and persists nothing — it is purely derived.
final agendaOccupancyProvider = Provider<AsyncValue<List<AgendaOccupancy>>>((
  ref,
) {
  final quotes = ref.watch(quotesProvider);
  final blocksAsync = ref.watch(agendaBlocksProvider);

  return blocksAsync.whenData((blocks) {
    final occupancies = <AgendaOccupancy>[];

    for (final quote in quotes) {
      final occupancy = AgendaOccupancy.fromQuote(quote);
      if (occupancy != null) {
        occupancies.add(occupancy);
      }
    }

    for (final block in blocks) {
      occupancies.add(AgendaOccupancy.fromBlock(block));
    }

    occupancies.sort((a, b) => a.start.compareTo(b.start));
    return occupancies;
  });
});
