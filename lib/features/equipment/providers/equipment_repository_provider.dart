import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/repositories/drift_equipment_repository.dart';
import '../data/repositories/equipment_repository.dart';

final equipmentRepositoryProvider = Provider<EquipmentRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftEquipmentRepository(database);
});
