import 'package:eventpro/features/logistics/providers/logistics_clock_provider.dart';
import 'package:eventpro/features/logistics/providers/quote_vehicle_repository_provider.dart';
import 'package:eventpro/features/logistics/providers/vehicle_repository_provider.dart';
import 'package:eventpro/features/logistics/providers/vehicle_type_repository_provider.dart';
import 'package:eventpro/features/quotes/providers/quote_repository_provider.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import 'fake_quote_vehicle_repository.dart';
import 'fake_vehicle_repository.dart';
import 'fake_vehicle_type_repository.dart';

List<Override> logisticsRepositoryOverrides({
  FakeVehicleRepository? vehicleRepository,
  FakeVehicleTypeRepository? typeRepository,
  FakeQuoteVehicleRepository? quoteVehicleRepository,
  FakeQuoteRepository? quoteRepository,
  DateTime Function()? clock,
}) {
  return [
    vehicleRepositoryProvider.overrideWithValue(
      vehicleRepository ?? FakeVehicleRepository(),
    ),
    vehicleTypeRepositoryProvider.overrideWithValue(
      typeRepository ?? FakeVehicleTypeRepository(),
    ),
    quoteVehicleRepositoryProvider.overrideWithValue(
      quoteVehicleRepository ?? FakeQuoteVehicleRepository(),
    ),
    quoteRepositoryProvider.overrideWithValue(
      quoteRepository ?? FakeQuoteRepository(),
    ),
    if (clock != null) logisticsClockProvider.overrideWithValue(clock),
  ];
}
