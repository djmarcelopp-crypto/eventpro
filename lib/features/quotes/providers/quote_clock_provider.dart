import 'package:flutter_riverpod/flutter_riverpod.dart';

final quoteClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);
