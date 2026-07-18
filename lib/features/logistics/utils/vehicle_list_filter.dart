import '../models/vehicle.dart';
import '../models/vehicle_filters.dart';

abstract class VehicleListFilter {
  static List<Vehicle> apply(List<Vehicle> vehicles, VehicleFilters filters) {
    final query = filters.plateQuery.trim().toLowerCase();
    return [
      for (final vehicle in vehicles)
        if (_matches(vehicle, filters, query)) vehicle,
    ];
  }

  static bool _matches(
    Vehicle vehicle,
    VehicleFilters filters,
    String query,
  ) {
    if (filters.vehicleTypeId != null &&
        vehicle.vehicleTypeId != filters.vehicleTypeId) {
      return false;
    }
    if (filters.status != null && vehicle.status != filters.status) {
      return false;
    }
    if (query.isNotEmpty &&
        !vehicle.plate.toLowerCase().contains(query) &&
        !vehicle.description.toLowerCase().contains(query)) {
      return false;
    }
    return true;
  }
}
