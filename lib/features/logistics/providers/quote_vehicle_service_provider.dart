import 'package:eventpro/features/quotes/providers/quote_repository_provider.dart';
import 'package:eventpro/features/team/providers/team_member_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/quote_vehicle_service.dart';
import 'logistics_clock_provider.dart';
import 'quote_vehicle_repository_provider.dart';
import 'vehicle_repository_provider.dart';

final quoteVehicleServiceProvider = Provider<QuoteVehicleService>((ref) {
  return QuoteVehicleService(
    quoteVehicleRepository: ref.watch(quoteVehicleRepositoryProvider),
    vehicleRepository: ref.watch(vehicleRepositoryProvider),
    quoteRepository: ref.watch(quoteRepositoryProvider),
    teamMemberRepository: ref.watch(teamMemberRepositoryProvider),
    clock: ref.watch(logisticsClockProvider),
  );
});
