import 'package:eventpro/features/settings/data/repositories/company_profile_repository.dart';
import 'package:eventpro/features/settings/providers/company_profile_repository_provider.dart';
import 'package:flutter_riverpod/misc.dart';

import 'fake_company_profile_repository.dart';

List<Override> companyProfileRepositoryOverrides({
  CompanyProfileRepository? repository,
}) {
  return [
    companyProfileRepositoryProvider.overrideWithValue(
      repository ?? FakeCompanyProfileRepository(),
    ),
  ];
}
