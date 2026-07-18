import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/repositories/drift_equipment_category_repository.dart';
import '../data/repositories/equipment_category_repository.dart';

final equipmentCategoryRepositoryProvider =
    Provider<EquipmentCategoryRepository>((ref) {
      final database = ref.watch(appDatabaseProvider);
      return DriftEquipmentCategoryRepository(database);
    });
