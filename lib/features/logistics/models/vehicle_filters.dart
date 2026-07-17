import '../models/vehicle_status.dart';

/// Presentation filters for the vehicles list (UI only).
class VehicleFilters {
  const VehicleFilters({
    this.vehicleTypeId,
    this.status,
    this.plateQuery = '',
  });

  static const empty = VehicleFilters();

  final String? vehicleTypeId;
  final VehicleStatus? status;
  final String plateQuery;

  bool get hasActiveFilters =>
      vehicleTypeId != null ||
      status != null ||
      plateQuery.trim().isNotEmpty;

  VehicleFilters copyWith({
    String? vehicleTypeId,
    VehicleStatus? status,
    String? plateQuery,
    bool clearVehicleTypeId = false,
    bool clearStatus = false,
  }) {
    return VehicleFilters(
      vehicleTypeId:
          clearVehicleTypeId ? null : (vehicleTypeId ?? this.vehicleTypeId),
      status: clearStatus ? null : (status ?? this.status),
      plateQuery: plateQuery ?? this.plateQuery,
    );
  }
}
