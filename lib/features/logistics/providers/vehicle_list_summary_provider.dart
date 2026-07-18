import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/vehicle_list_summary.dart';
import 'vehicle_provider.dart';
import 'vehicle_type_provider.dart';

final vehicleListSummaryProvider = Provider<AsyncValue<VehicleListSummary>>((
  ref,
) {
  final vehiclesAsync = ref.watch(vehicleProvider);
  final typesAsync = ref.watch(vehicleTypeProvider);
  return vehiclesAsync.whenData(
    (vehicles) => VehicleListSummary.fromVehicles(
      vehicles,
      typeCount: typesAsync.value?.length ?? 0,
    ),
  );
});
