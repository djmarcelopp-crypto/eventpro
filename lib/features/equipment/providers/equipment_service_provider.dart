import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/equipment_service.dart';
import 'equipment_category_repository_provider.dart';
import 'equipment_clock_provider.dart';
import 'equipment_repository_provider.dart';

final equipmentServiceProvider = Provider<EquipmentService>((ref) {
  return EquipmentService(
    equipmentRepository: ref.watch(equipmentRepositoryProvider),
    categoryRepository: ref.watch(equipmentCategoryRepositoryProvider),
    clock: ref.watch(equipmentClockProvider),
  );
});
