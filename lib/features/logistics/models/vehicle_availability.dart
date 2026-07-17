import 'vehicle_consuming_quote.dart';
import 'vehicle_schedule_conflict.dart';
import 'vehicle_status.dart';

/// Temporal availability derived from quote links — independent of
/// automatically mutating [VehicleStatus].
enum VehicleAvailabilityStatus {
  /// Operationally eligible and no consuming quote demand for the scope.
  available,

  /// Not operationally eligible and/or occupied by consuming quotes.
  unavailable,
}

/// Dynamic availability snapshot for one [Vehicle].
///
/// Computed in memory from quote vehicle links and logistics periods —
/// never stored.
class VehicleAvailability {
  const VehicleAvailability({
    required this.vehicleId,
    required this.operationalStatus,
    required this.status,
    required this.consumingQuotes,
    required this.conflicts,
  });

  final String vehicleId;

  /// Snapshot of [Vehicle.status] at calculation time (not mutated).
  final VehicleStatus operationalStatus;

  final VehicleAvailabilityStatus status;
  final List<VehicleConsumingQuote> consumingQuotes;
  final List<VehicleScheduleConflict> conflicts;

  bool get hasConflicts => conflicts.isNotEmpty;
  bool get isAvailable => status == VehicleAvailabilityStatus.available;
  bool get isUnavailable => status == VehicleAvailabilityStatus.unavailable;
  bool get isOperationallyEligible =>
      operationalStatus == VehicleStatus.available;
}
