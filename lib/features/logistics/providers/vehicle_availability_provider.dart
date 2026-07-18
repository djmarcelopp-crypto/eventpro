import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/logistics_plan_summary.dart';
import '../models/vehicle_availability.dart';
import '../models/vehicle_availability_summary.dart';
import 'vehicle_availability_service_provider.dart';

/// Loads dynamic availability for every vehicle (computed, not stored).
final vehicleAvailabilityProvider =
    FutureProvider<List<VehicleAvailability>>((ref) {
  return ref.watch(vehicleAvailabilityServiceProvider).listAll();
});

/// Aggregate available / unavailable / conflict counts and percentage.
final vehicleAvailabilitySummaryProvider =
    FutureProvider<VehicleAvailabilitySummary>((ref) async {
  final items = await ref.watch(vehicleAvailabilityProvider.future);
  return VehicleAvailabilitySummary.fromItems(items);
});

/// Planning summary including maintenance count and planned freight cost.
final logisticsPlanSummaryProvider =
    FutureProvider<LogisticsPlanSummary>((ref) {
  return ref.watch(vehicleAvailabilityServiceProvider).planSummary();
});
