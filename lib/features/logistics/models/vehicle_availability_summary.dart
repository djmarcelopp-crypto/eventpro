import 'vehicle_availability.dart';

/// Aggregate vehicle availability counters for UI / reports.
class VehicleAvailabilitySummary {
  const VehicleAvailabilitySummary({
    required this.items,
    required this.totalVehicles,
    required this.availableCount,
    required this.unavailableCount,
    required this.conflictCount,
    required this.availabilityPercent,
  });

  factory VehicleAvailabilitySummary.fromItems(List<VehicleAvailability> items) {
    var availableCount = 0;
    var unavailableCount = 0;
    var conflictCount = 0;

    for (final item in items) {
      if (item.isAvailable) {
        availableCount++;
      } else {
        unavailableCount++;
      }
      conflictCount += item.conflicts.length;
    }

    final totalVehicles = items.length;
    final availabilityPercent = totalVehicles == 0
        ? 0.0
        : (availableCount * 100.0) / totalVehicles;

    return VehicleAvailabilitySummary(
      items: List<VehicleAvailability>.unmodifiable(items),
      totalVehicles: totalVehicles,
      availableCount: availableCount,
      unavailableCount: unavailableCount,
      conflictCount: conflictCount,
      availabilityPercent: availabilityPercent,
    );
  }

  static const empty = VehicleAvailabilitySummary(
    items: [],
    totalVehicles: 0,
    availableCount: 0,
    unavailableCount: 0,
    conflictCount: 0,
    availabilityPercent: 0,
  );

  final List<VehicleAvailability> items;
  final int totalVehicles;
  final int availableCount;
  final int unavailableCount;
  final int conflictCount;

  /// `availableCount / totalVehicles * 100` (0 when empty).
  final double availabilityPercent;
}
