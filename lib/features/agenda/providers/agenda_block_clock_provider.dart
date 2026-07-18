import 'package:flutter_riverpod/flutter_riverpod.dart';

final agendaBlockClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);
