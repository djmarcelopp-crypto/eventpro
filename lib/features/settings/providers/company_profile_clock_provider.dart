import 'package:flutter_riverpod/flutter_riverpod.dart';

final companyProfileClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);
