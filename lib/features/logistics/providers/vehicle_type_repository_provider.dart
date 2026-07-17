import 'package:eventpro/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/drift_vehicle_type_repository.dart';
import '../data/repositories/vehicle_type_repository.dart';

final vehicleTypeRepositoryProvider = Provider<VehicleTypeRepository>((ref) {
  return DriftVehicleTypeRepository(ref.watch(appDatabaseProvider));
});
