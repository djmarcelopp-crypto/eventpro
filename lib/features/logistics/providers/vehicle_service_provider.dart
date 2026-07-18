import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/vehicle_service.dart';
import 'logistics_clock_provider.dart';
import 'vehicle_repository_provider.dart';
import 'vehicle_type_repository_provider.dart';

final vehicleServiceProvider = Provider<VehicleService>((ref) {
  return VehicleService(
    vehicleRepository: ref.watch(vehicleRepositoryProvider),
    typeRepository: ref.watch(vehicleTypeRepositoryProvider),
    clock: ref.watch(logisticsClockProvider),
  );
});
