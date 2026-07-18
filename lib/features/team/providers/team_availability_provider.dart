import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/team_availability.dart';
import '../models/team_availability_summary.dart';
import 'team_availability_service_provider.dart';

/// Loads dynamic availability for every roster member (computed, not stored).
final teamAvailabilityProvider =
    FutureProvider<List<TeamAvailability>>((ref) {
  return ref.watch(teamAvailabilityServiceProvider).listAll();
});

/// Aggregate available / unavailable / conflict counts and percentage.
final teamAvailabilitySummaryProvider =
    FutureProvider<TeamAvailabilitySummary>((ref) async {
  final items = await ref.watch(teamAvailabilityProvider.future);
  return TeamAvailabilitySummary.fromItems(items);
});
