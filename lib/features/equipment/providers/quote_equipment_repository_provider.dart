import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/repositories/drift_quote_equipment_repository.dart';
import '../data/repositories/quote_equipment_repository.dart';

final quoteEquipmentRepositoryProvider = Provider<QuoteEquipmentRepository>((
  ref,
) {
  final database = ref.watch(appDatabaseProvider);
  return DriftQuoteEquipmentRepository(database);
});
