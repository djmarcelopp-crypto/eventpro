import 'vehicle_event_period.dart';

/// Schedule conflict when a vehicle is linked to overlapping quote periods.
///
/// Pure domain value — never persisted.
class VehicleScheduleConflict {
  const VehicleScheduleConflict({
    required this.vehicleId,
    required this.quoteId,
    required this.eventPeriod,
    required this.reason,
  });

  final String vehicleId;
  final String quoteId;
  final VehicleEventPeriod eventPeriod;

  /// Human-readable conflict reason (partial vs total overlap).
  final String reason;
}
