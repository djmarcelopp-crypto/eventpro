import 'vehicle_event_period.dart';

/// A quote that plans to use a vehicle in a logistics period.
///
/// DTO only — never persisted as availability state.
class VehicleConsumingQuote {
  const VehicleConsumingQuote({
    required this.quoteId,
    required this.eventPeriod,
    this.quoteNumber,
    this.eventName,
    this.freightCostCents = 0,
  });

  final String quoteId;
  final String? quoteNumber;
  final String? eventName;
  final VehicleEventPeriod eventPeriod;
  final int freightCostCents;
}
