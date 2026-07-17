import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/equipment_availability.dart';
import '../models/equipment_availability_summary.dart';
import 'equipment_availability_service_provider.dart';

/// Loads dynamic availability for every equipment item (computed, not stored).
final equipmentAvailabilityProvider =
    FutureProvider<List<EquipmentAvailability>>((ref) {
      return ref.watch(equipmentAvailabilityServiceProvider).listAll();
    });

/// Aggregate fully / partially / unavailable counts.
final equipmentAvailabilitySummaryProvider =
    FutureProvider<EquipmentAvailabilitySummary>((ref) async {
      final items = await ref.watch(equipmentAvailabilityProvider.future);
      return EquipmentAvailabilitySummary.fromItems(items);
    });
