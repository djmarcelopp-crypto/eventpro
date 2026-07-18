import 'package:flutter_riverpod/flutter_riverpod.dart';

final equipmentClockProvider = Provider<DateTime Function()>((ref) {
  return DateTime.now;
});
