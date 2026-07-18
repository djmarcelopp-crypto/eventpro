import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/company_profile_repository.dart';
import '../models/company_profile.dart';
import 'company_profile_clock_provider.dart';
import 'company_profile_repository_provider.dart';

class CompanyProfileNotifier extends Notifier<CompanyProfile?> {
  CompanyProfileRepository get _repository =>
      ref.read(companyProfileRepositoryProvider);

  DateTime _now() => ref.read(companyProfileClockProvider)();

  @override
  CompanyProfile? build() => null;

  void hydrate(CompanyProfile? profile) {
    state = profile;
  }

  Future<bool> save(CompanyProfile draft) async {
    final existing = state;
    final now = _now();

    final profileToSave = existing == null
        ? draft.copyWith(createdAt: now, updatedAt: now)
        : draft.copyWith(
            createdAt: existing.createdAt,
            updatedAt: now,
            logoReference: draft.logoReference ?? existing.logoReference,
          );

    try {
      await _repository.upsert(profileToSave);
      state = profileToSave;
      return true;
    } catch (_) {
      return false;
    }
  }
}

final companyProfileProvider =
    NotifierProvider<CompanyProfileNotifier, CompanyProfile?>(
      CompanyProfileNotifier.new,
    );
