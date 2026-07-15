part of '../app_database.dart';

@DriftAccessor(tables: [CompanyProfiles])
class CompanyProfilesDao extends DatabaseAccessor<AppDatabase>
    with _$CompanyProfilesDaoMixin {
  CompanyProfilesDao(super.db);

  Future<CompanyProfileRow?> getSingleton() {
    return (select(
      companyProfiles,
    )..where((row) => row.id.equals('default'))).getSingleOrNull();
  }

  Future<void> upsertRow(CompanyProfilesCompanion row) {
    return into(companyProfiles).insertOnConflictUpdate(row);
  }
}
