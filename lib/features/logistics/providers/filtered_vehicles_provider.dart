import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/vehicle.dart';
import '../utils/vehicle_list_filter.dart';
import 'vehicle_filters_provider.dart';
import 'vehicle_provider.dart';

final filteredVehiclesProvider = Provider<AsyncValue<List<Vehicle>>>((ref) {
  final filters = ref.watch(vehicleFiltersProvider);
  return ref.watch(vehicleProvider).whenData(
        (vehicles) => VehicleListFilter.apply(vehicles, filters),
      );
});
