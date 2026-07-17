import '../../quotes/data/repositories/quote_repository.dart';
import '../../quotes/models/quote.dart';
import '../data/repositories/quote_vehicle_repository.dart';
import '../data/repositories/vehicle_repository.dart';
import '../models/logistics_plan_summary.dart';
import '../models/quote_vehicle.dart';
import '../models/vehicle_availability.dart';
import '../models/vehicle_availability_summary.dart';
import '../models/vehicle_event_period.dart';
import 'vehicle_availability_calculator.dart';

/// Loads fleet and quote vehicle links, then delegates to
/// [VehicleAvailabilityCalculator].
///
/// Does **not** persist availability or change [Vehicle.status].
class VehicleAvailabilityService {
  VehicleAvailabilityService({
    required this._vehicleRepository,
    required this._quoteVehicleRepository,
    required this._quoteRepository,
  });

  final VehicleRepository _vehicleRepository;
  final QuoteVehicleRepository _quoteVehicleRepository;
  final QuoteRepository _quoteRepository;

  Future<List<VehicleAvailability>> listAll({
    VehicleEventPeriod? queryPeriod,
  }) async {
    final vehicles = await _vehicleRepository.listAll();
    final quoteVehicles = await _quoteVehicleRepository.listAll();
    final quotes = await _quoteRepository.listAll();
    return VehicleAvailabilityCalculator.calculateAll(
      vehicles: vehicles,
      quoteVehicles: quoteVehicles,
      quotes: quotes,
      queryPeriod: queryPeriod,
    );
  }

  Future<VehicleAvailability?> forVehicle(
    String vehicleId, {
    VehicleEventPeriod? queryPeriod,
  }) async {
    final vehicle = await _vehicleRepository.findById(vehicleId);
    if (vehicle == null) {
      return null;
    }
    final quoteVehicles = await _quoteVehicleRepository.listAll();
    final quotes = await _quoteRepository.listAll();
    return VehicleAvailabilityCalculator.calculateForVehicle(
      vehicle: vehicle,
      quoteVehicles: quoteVehicles,
      quotesById: <String, Quote>{
        for (final quote in quotes) quote.id: quote,
      },
      queryPeriod: queryPeriod,
    );
  }

  Future<VehicleAvailabilitySummary> summary({
    VehicleEventPeriod? queryPeriod,
  }) async {
    final items = await listAll(queryPeriod: queryPeriod);
    return VehicleAvailabilityCalculator.summarize(items);
  }

  Future<LogisticsPlanSummary> planSummary({
    VehicleEventPeriod? queryPeriod,
  }) async {
    final vehicles = await _vehicleRepository.listAll();
    final quoteVehicles = await _quoteVehicleRepository.listAll();
    final quotes = await _quoteRepository.listAll();
    final items = VehicleAvailabilityCalculator.calculateAll(
      vehicles: vehicles,
      quoteVehicles: quoteVehicles,
      quotes: quotes,
      queryPeriod: queryPeriod,
    );
    return VehicleAvailabilityCalculator.planSummary(
      items,
      plannedFreightCostCents: _plannedFreightCostCents(
        quoteVehicles: quoteVehicles,
        quotes: quotes,
      ),
    );
  }

  /// Sums freight for links whose quote is in a consuming status.
  static int _plannedFreightCostCents({
    required List<QuoteVehicle> quoteVehicles,
    required List<Quote> quotes,
  }) {
    final quotesById = <String, Quote>{
      for (final quote in quotes) quote.id: quote,
    };
    var total = 0;
    for (final link in quoteVehicles) {
      final quote = quotesById[link.quoteId];
      if (quote == null) {
        continue;
      }
      if (!VehicleAvailabilityCalculator.consumingStatuses.contains(
        quote.status,
      )) {
        continue;
      }
      total += link.freightCostCents;
    }
    return total;
  }
}
