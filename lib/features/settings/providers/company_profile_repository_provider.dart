import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eventpro/core/database/database_provider.dart';
import 'package:eventpro/features/settings/data/repositories/company_profile_repository.dart';
import 'package:eventpro/features/settings/data/repositories/drift_company_profile_repository.dart';

final companyProfileRepositoryProvider = Provider<CompanyProfileRepository>((
  ref,
) {
  final database = ref.watch(appDatabaseProvider);
  return DriftCompanyProfileRepository(database);
});
