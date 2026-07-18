import 'package:flutter_riverpod/flutter_riverpod.dart';

final contractsClockProvider = Provider<DateTime Function()>((ref) {
  return DateTime.now;
});
