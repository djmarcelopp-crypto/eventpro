import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/vehicle_type_service.dart';
import 'logistics_clock_provider.dart';
import 'vehicle_repository_provider.dart';
import 'vehicle_type_repository_provider.dart';

final vehicleTypeServiceProvider = Provider<VehicleTypeService>((ref) {
  return VehicleTypeService(
    typeRepository: ref.watch(vehicleTypeRepositoryProvider),
    vehicleRepository: ref.watch(vehicleRepositoryProvider),
    clock: ref.watch(logisticsClockProvider),
  );
});
