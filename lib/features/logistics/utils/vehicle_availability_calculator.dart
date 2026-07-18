import '../../quotes/models/quote.dart';
import '../../quotes/models/quote_status.dart';
import '../models/logistics_plan_summary.dart';
import '../models/quote_vehicle.dart';
import '../models/vehicle.dart';
import '../models/vehicle_availability.dart';
import '../models/vehicle_availability_summary.dart';
import '../models/vehicle_consuming_quote.dart';
import '../models/vehicle_event_period.dart';
import '../models/vehicle_schedule_conflict.dart';
import '../models/vehicle_status.dart';
import 'vehicle_event_period_resolver.dart';

class _Assignment {
  const _Assignment({
    required this.quote,
    required this.link,
    required this.period,
  });

  final Quote quote;
  final QuoteVehicle link;
  final VehicleEventPeriod period;
}

/// Pure calculator for dynamic vehicle logistics availability.
///
/// Uses [QuoteVehicle] links and logistics periods. Does **not** persist
/// results or mutate [Vehicle.status].
abstract class VehicleAvailabilityCalculator {
  /// Quote statuses that occupy a vehicle for overlapping periods.
  static const consumingStatuses = <QuoteStatus>{
    QuoteStatus.draft,
    QuoteStatus.sent,
    QuoteStatus.approved,
  };

  static const partialOverlapReason =
      'Sobreposição parcial de período com outro orçamento';
  static const totalOverlapReason =
      'Sobreposição total de período com outro orçamento';

  static VehicleAvailabilitySummary summarize(
    List<VehicleAvailability> items,
  ) {
    return VehicleAvailabilitySummary.fromItems(items);
  }

  static LogisticsPlanSummary planSummary(
    List<VehicleAvailability> items, {
    required int plannedFreightCostCents,
  }) {
    return LogisticsPlanSummary.fromAvailability(
      items: items,
      plannedFreightCostCents: plannedFreightCostCents,
    );
  }

  static List<VehicleAvailability> calculateAll({
    required List<Vehicle> vehicles,
    required List<QuoteVehicle> quoteVehicles,
    required List<Quote> quotes,
    VehicleEventPeriod? queryPeriod,
  }) {
    final quotesById = <String, Quote>{
      for (final quote in quotes) quote.id: quote,
    };

    return [
      for (final vehicle in vehicles)
        calculateForVehicle(
          vehicle: vehicle,
          quoteVehicles: quoteVehicles,
          quotesById: quotesById,
          queryPeriod: queryPeriod,
        ),
    ];
  }

  static VehicleAvailability calculateForVehicle({
    required Vehicle vehicle,
    required List<QuoteVehicle> quoteVehicles,
    required Map<String, Quote> quotesById,
    VehicleEventPeriod? queryPeriod,
  }) {
    final assignments = <_Assignment>[];

    for (final link in quoteVehicles) {
      if (link.vehicleId != vehicle.id) {
        continue;
      }
      final quote = quotesById[link.quoteId];
      if (quote == null) {
        continue;
      }
      if (!consumingStatuses.contains(quote.status)) {
        continue;
      }
      final period = VehicleEventPeriodResolver.resolve(
        link: link,
        quote: quote,
      );
      if (period == null) {
        continue;
      }
      assignments.add(
        _Assignment(quote: quote, link: link, period: period),
      );
    }

    assignments.sort((a, b) => a.period.start.compareTo(b.period.start));

    final consumingQuotes = [
      for (final assignment in assignments)
        VehicleConsumingQuote(
          quoteId: assignment.quote.id,
          quoteNumber: assignment.quote.number,
          eventName: assignment.quote.eventSnapshot.name,
          eventPeriod: assignment.period,
          freightCostCents: assignment.link.freightCostCents,
        ),
    ];

    final conflicts = <VehicleScheduleConflict>[];
    for (var i = 0; i < assignments.length; i++) {
      for (var j = i + 1; j < assignments.length; j++) {
        final first = assignments[i];
        final second = assignments[j];
        if (!_periodsOverlap(first.period, second.period)) {
          continue;
        }
        final reason = _overlapReason(first.period, second.period);
        conflicts.add(
          VehicleScheduleConflict(
            vehicleId: vehicle.id,
            quoteId: first.quote.id,
            eventPeriod: first.period,
            reason: reason,
          ),
        );
        conflicts.add(
          VehicleScheduleConflict(
            vehicleId: vehicle.id,
            quoteId: second.quote.id,
            eventPeriod: second.period,
            reason: reason,
          ),
        );
      }
    }

    final relevantAssignments = queryPeriod == null
        ? assignments
        : [
            for (final assignment in assignments)
              if (_periodsOverlap(assignment.period, queryPeriod)) assignment,
          ];

    final operationallyEligible =
        vehicle.status == VehicleStatus.available;
    final status = operationallyEligible && relevantAssignments.isEmpty
        ? VehicleAvailabilityStatus.available
        : VehicleAvailabilityStatus.unavailable;

    return VehicleAvailability(
      vehicleId: vehicle.id,
      operationalStatus: vehicle.status,
      status: status,
      consumingQuotes: List<VehicleConsumingQuote>.unmodifiable(consumingQuotes),
      conflicts: List<VehicleScheduleConflict>.unmodifiable(conflicts),
    );
  }

  static bool _periodsOverlap(
    VehicleEventPeriod first,
    VehicleEventPeriod second,
  ) {
    return first.start.isBefore(second.end) && second.start.isBefore(first.end);
  }

  static String _overlapReason(
    VehicleEventPeriod first,
    VehicleEventPeriod second,
  ) {
    final firstContainsSecond = !first.start.isAfter(second.start) &&
        !first.end.isBefore(second.end);
    final secondContainsFirst = !second.start.isAfter(first.start) &&
        !second.end.isBefore(first.end);
    if (firstContainsSecond || secondContainsFirst) {
      return totalOverlapReason;
    }
    return partialOverlapReason;
  }
}
