import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/equipment_list_summary.dart';
import 'filtered_equipment_provider.dart';

final equipmentListSummaryProvider =
    Provider<AsyncValue<EquipmentListSummary>>((ref) {
      final itemsAsync = ref.watch(filteredEquipmentProvider);
      return itemsAsync.whenData(EquipmentListSummary.fromItems);
    });
