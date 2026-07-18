import 'package:flutter_riverpod/flutter_riverpod.dart';

final teamClockProvider = Provider<DateTime Function()>((ref) {
  return DateTime.now;
});
