import 'package:eventpro/features/settings/models/company_profile.dart';

abstract class CompanyProfileRepository {
  Future<CompanyProfile?> get();

  Future<void> upsert(CompanyProfile profile);
}
