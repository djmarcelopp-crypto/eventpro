import 'vehicle_availability.dart';
import 'vehicle_availability_summary.dart';
import 'vehicle_status.dart';

/// Planning snapshot combining temporal availability, operational counts and
/// planned freight cost. Never persisted.
class LogisticsPlanSummary {
  const LogisticsPlanSummary({
    required this.availability,
    required this.totalVehicles,
    required this.availableCount,
    required this.unavailableCount,
    required this.maintenanceCount,
    required this.conflictCount,
    required this.availabilityPercent,
    required this.plannedFreightCostCents,
  });

  factory LogisticsPlanSummary.fromAvailability({
    required List<VehicleAvailability> items,
    required int plannedFreightCostCents,
  }) {
    final availability = VehicleAvailabilitySummary.fromItems(items);
    var maintenanceCount = 0;
    for (final item in items) {
      if (item.operationalStatus == VehicleStatus.maintenance) {
        maintenanceCount++;
      }
    }

    return LogisticsPlanSummary(
      availability: availability,
      totalVehicles: availability.totalVehicles,
      availableCount: availability.availableCount,
      unavailableCount: availability.unavailableCount,
      maintenanceCount: maintenanceCount,
      conflictCount: availability.conflictCount,
      availabilityPercent: availability.availabilityPercent,
      plannedFreightCostCents: plannedFreightCostCents < 0
          ? 0
          : plannedFreightCostCents,
    );
  }

  static const empty = LogisticsPlanSummary(
    availability: VehicleAvailabilitySummary.empty,
    totalVehicles: 0,
    availableCount: 0,
    unavailableCount: 0,
    maintenanceCount: 0,
    conflictCount: 0,
    availabilityPercent: 0,
    plannedFreightCostCents: 0,
  );

  final VehicleAvailabilitySummary availability;
  final int totalVehicles;
  final int availableCount;
  final int unavailableCount;
  final int maintenanceCount;
  final int conflictCount;
  final double availabilityPercent;
  final int plannedFreightCostCents;
}
