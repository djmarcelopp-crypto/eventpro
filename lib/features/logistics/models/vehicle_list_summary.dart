import '../models/vehicle.dart';
import '../models/vehicle_status.dart';

/// Aggregate counters for the vehicles list header.
class VehicleListSummary {
  const VehicleListSummary({
    required this.total,
    required this.available,
    required this.maintenance,
    required this.unavailable,
    required this.inactive,
    required this.typeCount,
  });

  factory VehicleListSummary.fromVehicles(
    List<Vehicle> vehicles, {
    required int typeCount,
  }) {
    var available = 0;
    var maintenance = 0;
    var unavailable = 0;
    var inactive = 0;
    for (final vehicle in vehicles) {
      switch (vehicle.status) {
        case VehicleStatus.available:
          available++;
        case VehicleStatus.maintenance:
          maintenance++;
        case VehicleStatus.unavailable:
          unavailable++;
        case VehicleStatus.inactive:
          inactive++;
      }
    }
    return VehicleListSummary(
      total: vehicles.length,
      available: available,
      maintenance: maintenance,
      unavailable: unavailable,
      inactive: inactive,
      typeCount: typeCount,
    );
  }

  static const empty = VehicleListSummary(
    total: 0,
    available: 0,
    maintenance: 0,
    unavailable: 0,
    inactive: 0,
    typeCount: 0,
  );

  final int total;
  final int available;
  final int maintenance;
  final int unavailable;
  final int inactive;
  final int typeCount;
}
