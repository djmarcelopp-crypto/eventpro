import 'package:eventpro/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/drift_quote_vehicle_repository.dart';
import '../data/repositories/quote_vehicle_repository.dart';

final quoteVehicleRepositoryProvider = Provider<QuoteVehicleRepository>((ref) {
  return DriftQuoteVehicleRepository(ref.watch(appDatabaseProvider));
});
