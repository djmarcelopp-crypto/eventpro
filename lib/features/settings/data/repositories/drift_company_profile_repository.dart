import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/settings/data/mappers/company_profile_mapper.dart';
import 'package:eventpro/features/settings/data/repositories/company_profile_repository.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';

class DriftCompanyProfileRepository implements CompanyProfileRepository {
  DriftCompanyProfileRepository(this._database);

  final AppDatabase _database;

  @override
  Future<CompanyProfile?> get() async {
    final row = await _database.companyProfilesDao.getSingleton();
    if (row == null) {
      return null;
    }
    return CompanyProfileMapper.toDomain(row);
  }

  @override
  Future<void> upsert(CompanyProfile profile) async {
    await _database.companyProfilesDao.upsertRow(
      CompanyProfileMapper.toUpsertCompanion(profile),
    );
  }
}
