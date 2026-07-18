import 'package:flutter_riverpod/flutter_riverpod.dart';

final billingClockProvider = Provider<DateTime Function()>((ref) {
  return DateTime.now;
});
