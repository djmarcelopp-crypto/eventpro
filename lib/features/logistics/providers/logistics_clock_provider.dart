import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Injectable clock for logistics write services. Override in tests.
final logisticsClockProvider = Provider<DateTime Function()>((ref) {
  return DateTime.now;
});
