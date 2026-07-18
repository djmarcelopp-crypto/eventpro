import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../quotes/providers/quote_repository_provider.dart';
import '../utils/quote_equipment_service.dart';
import 'equipment_clock_provider.dart';
import 'equipment_repository_provider.dart';
import 'quote_equipment_repository_provider.dart';

final quoteEquipmentServiceProvider = Provider<QuoteEquipmentService>((ref) {
  return QuoteEquipmentService(
    quoteEquipmentRepository: ref.watch(quoteEquipmentRepositoryProvider),
    equipmentRepository: ref.watch(equipmentRepositoryProvider),
    quoteRepository: ref.watch(quoteRepositoryProvider),
    clock: ref.watch(equipmentClockProvider),
  );
});
