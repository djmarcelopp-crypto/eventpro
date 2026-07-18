import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/vehicle_filters.dart';
import '../models/vehicle_status.dart';

class VehicleFiltersNotifier extends Notifier<VehicleFilters> {
  @override
  VehicleFilters build() => VehicleFilters.empty;

  void setVehicleTypeId(String? vehicleTypeId) {
    state = state.copyWith(
      vehicleTypeId: vehicleTypeId,
      clearVehicleTypeId: vehicleTypeId == null,
    );
  }

  void setStatus(VehicleStatus? status) {
    state = state.copyWith(
      status: status,
      clearStatus: status == null,
    );
  }

  void setPlateQuery(String query) {
    state = state.copyWith(plateQuery: query);
  }

  void clear() {
    state = VehicleFilters.empty;
  }
}

final vehicleFiltersProvider =
    NotifierProvider<VehicleFiltersNotifier, VehicleFilters>(
      VehicleFiltersNotifier.new,
    );
