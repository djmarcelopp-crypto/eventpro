import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/equipment_category_service.dart';
import 'equipment_category_repository_provider.dart';
import 'equipment_clock_provider.dart';
import 'equipment_repository_provider.dart';

final equipmentCategoryServiceProvider = Provider<EquipmentCategoryService>((
  ref,
) {
  return EquipmentCategoryService(
    categoryRepository: ref.watch(equipmentCategoryRepositoryProvider),
    equipmentRepository: ref.watch(equipmentRepositoryProvider),
    clock: ref.watch(equipmentClockProvider),
  );
});
