import 'package:eventpro/features/quotes/providers/quote_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/vehicle_availability_service.dart';
import 'quote_vehicle_repository_provider.dart';
import 'vehicle_repository_provider.dart';

final vehicleAvailabilityServiceProvider =
    Provider<VehicleAvailabilityService>((ref) {
  return VehicleAvailabilityService(
    vehicleRepository: ref.watch(vehicleRepositoryProvider),
    quoteVehicleRepository: ref.watch(quoteVehicleRepositoryProvider),
    quoteRepository: ref.watch(quoteRepositoryProvider),
  );
});
