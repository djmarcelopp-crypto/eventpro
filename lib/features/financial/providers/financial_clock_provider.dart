import 'package:flutter_riverpod/flutter_riverpod.dart';

final financialClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);
