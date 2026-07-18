import '../../quotes/models/quote.dart';
import '../../quotes/models/quote_status.dart';
import '../models/equipment.dart';
import '../models/equipment_availability.dart';
import '../models/equipment_availability_summary.dart';
import '../models/equipment_consuming_quote.dart';
import '../models/equipment_event_period.dart';
import '../models/equipment_reservation_conflict.dart';
import '../models/quote_equipment.dart';
import 'equipment_event_period_resolver.dart';

class _Demand {
  const _Demand({
    required this.quote,
    required this.quantity,
    required this.period,
  });

  final Quote quote;
  final int quantity;
  final EquipmentEventPeriod period;
}

/// Pure calculator for dynamic equipment availability.
///
/// Uses [Equipment.totalQuantity], [QuoteEquipment] lines and quote event
/// periods. Does **not** persist results or mutate [Equipment.status].
abstract class EquipmentAvailabilityCalculator {
  /// Quote statuses that consume stock for overlapping periods.
  static const consumingStatuses = <QuoteStatus>{
    QuoteStatus.draft,
    QuoteStatus.sent,
    QuoteStatus.approved,
  };

  static EquipmentAvailabilitySummary summarize(
    List<EquipmentAvailability> items,
  ) {
    return EquipmentAvailabilitySummary.fromItems(items);
  }

  static List<EquipmentAvailability> calculateAll({
    required List<Equipment> equipment,
    required List<QuoteEquipment> quoteEquipment,
    required List<Quote> quotes,
  }) {
    final quotesById = <String, Quote>{
      for (final quote in quotes) quote.id: quote,
    };

    return [
      for (final item in equipment)
        calculateForEquipment(
          equipment: item,
          quoteEquipment: quoteEquipment,
          quotesById: quotesById,
        ),
    ];
  }

  static EquipmentAvailability calculateForEquipment({
    required Equipment equipment,
    required List<QuoteEquipment> quoteEquipment,
    required Map<String, Quote> quotesById,
  }) {
    final demands = <_Demand>[];

    for (final line in quoteEquipment) {
      if (line.equipmentId != equipment.id) {
        continue;
      }
      final quote = quotesById[line.quoteId];
      if (quote == null) {
        continue;
      }
      if (!consumingStatuses.contains(quote.status)) {
        continue;
      }
      final period = EquipmentEventPeriodResolver.resolve(quote.eventSnapshot);
      if (period == null) {
        continue;
      }
      demands.add(
        _Demand(quote: quote, quantity: line.quantity, period: period),
      );
    }

    demands.sort((a, b) => a.period.start.compareTo(b.period.start));

    final reservedQuantity = _peakConcurrentQuantity(demands);
    final availableQuantity = equipment.totalQuantity - reservedQuantity < 0
        ? 0
        : equipment.totalQuantity - reservedQuantity;
    final level = _level(
      totalQuantity: equipment.totalQuantity,
      reservedQuantity: reservedQuantity,
    );

    final consumingQuotes = [
      for (final demand in demands)
        EquipmentConsumingQuote(
          quoteId: demand.quote.id,
          quoteNumber: demand.quote.number,
          quantity: demand.quantity,
          periodStart: demand.period.start,
          periodEnd: demand.period.end,
        ),
    ];

    final conflicts = <EquipmentReservationConflict>[];
    for (final demand in demands) {
      final reservedByOthers = _reservedByOverlappingOthers(
        demand: demand,
        all: demands,
      );
      final availableForQuote = equipment.totalQuantity - reservedByOthers < 0
          ? 0
          : equipment.totalQuantity - reservedByOthers;
      if (demand.quantity > availableForQuote) {
        conflicts.add(
          EquipmentReservationConflict(
            quoteId: demand.quote.id,
            equipmentId: equipment.id,
            requestedQuantity: demand.quantity,
            availableQuantity: availableForQuote,
            periodStart: demand.period.start,
            periodEnd: demand.period.end,
          ),
        );
      }
    }

    return EquipmentAvailability(
      equipmentId: equipment.id,
      totalQuantity: equipment.totalQuantity,
      reservedQuantity: reservedQuantity,
      availableQuantity: availableQuantity,
      level: level,
      consumingQuotes: List<EquipmentConsumingQuote>.unmodifiable(
        consumingQuotes,
      ),
      conflicts: List<EquipmentReservationConflict>.unmodifiable(conflicts),
    );
  }

  static EquipmentAvailabilityLevel _level({
    required int totalQuantity,
    required int reservedQuantity,
  }) {
    if (reservedQuantity <= 0) {
      return EquipmentAvailabilityLevel.fullyAvailable;
    }
    if (reservedQuantity >= totalQuantity) {
      return EquipmentAvailabilityLevel.unavailable;
    }
    return EquipmentAvailabilityLevel.partiallyAvailable;
  }

  static bool _periodsOverlap(
    EquipmentEventPeriod first,
    EquipmentEventPeriod second,
  ) {
    return first.start.isBefore(second.end) && second.start.isBefore(first.end);
  }

  static int _reservedByOverlappingOthers({
    required _Demand demand,
    required List<_Demand> all,
  }) {
    var total = 0;
    for (final other in all) {
      if (identical(other, demand)) {
        continue;
      }
      if (_periodsOverlap(demand.period, other.period)) {
        total += other.quantity;
      }
    }
    return total;
  }

  /// Sweep-line peak concurrent quantity across demand periods.
  static int _peakConcurrentQuantity(List<_Demand> demands) {
    if (demands.isEmpty) {
      return 0;
    }

    final events = <({DateTime at, int delta})>[];
    for (final demand in demands) {
      events.add((at: demand.period.start, delta: demand.quantity));
      events.add((at: demand.period.end, delta: -demand.quantity));
    }

    events.sort((a, b) {
      final byTime = a.at.compareTo(b.at);
      if (byTime != 0) {
        return byTime;
      }
      // Process releases (-delta) before acquisitions (+delta) at same instant
      // so touching intervals do not count as overlapping.
      return a.delta.compareTo(b.delta);
    });

    var current = 0;
    var peak = 0;
    for (final event in events) {
      current += event.delta;
      if (current > peak) {
        peak = current;
      }
    }
    return peak;
  }
}
