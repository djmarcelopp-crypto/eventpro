import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/company_profile.dart';
import 'company_profile_clock_provider.dart';

class CompanyProfileNotifier extends Notifier<CompanyProfile?> {
  @override
  CompanyProfile? build() => null;

  DateTime _now() => ref.read(companyProfileClockProvider)();

  bool save(CompanyProfile draft) {
    final existing = state;
    final now = _now();

    if (existing == null) {
      state = draft.copyWith(
        createdAt: now,
        updatedAt: now,
      );
      return true;
    }

    state = draft.copyWith(
      createdAt: existing.createdAt,
      updatedAt: now,
      logoReference: draft.logoReference ?? existing.logoReference,
    );
    return true;
  }
}

final companyProfileProvider =
    NotifierProvider<CompanyProfileNotifier, CompanyProfile?>(
  CompanyProfileNotifier.new,
);
