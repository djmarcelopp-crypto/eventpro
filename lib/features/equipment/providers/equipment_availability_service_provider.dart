import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../quotes/providers/quote_repository_provider.dart';
import '../utils/equipment_availability_service.dart';
import 'equipment_repository_provider.dart';
import 'quote_equipment_repository_provider.dart';

final equipmentAvailabilityServiceProvider =
    Provider<EquipmentAvailabilityService>((ref) {
      return EquipmentAvailabilityService(
        equipmentRepository: ref.watch(equipmentRepositoryProvider),
        quoteEquipmentRepository: ref.watch(quoteEquipmentRepositoryProvider),
        quoteRepository: ref.watch(quoteRepositoryProvider),
      );
    });
