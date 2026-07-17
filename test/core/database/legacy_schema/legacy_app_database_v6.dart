import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'legacy_tables_v6.dart';

part 'legacy_app_database_v6.g.dart';

@DriftDatabase(
  tables: [
    LegacyClients,
    LegacyCatalogItems,
    LegacyCatalogPackageComponents,
    LegacyCompanyProfiles,
    LegacyQuotes,
    LegacyQuoteClientSnapshots,
    LegacyQuoteEventSnapshots,
    LegacyQuoteCompanySnapshots,
    LegacyQuoteLineItems,
    LegacyQuoteLinePackageComponents,
    LegacyQuoteStatusHistory,
    LegacyQuoteNumberSequences,
    LegacyAgendaBlocks,
    LegacyFinancialCategories,
    LegacyFinancialEntries,
    LegacyEquipmentCategories,
    LegacyEquipments,
    LegacyQuoteEquipmentItems,
  ],
)
class LegacyAppDatabaseV6 extends _$LegacyAppDatabaseV6 {
  LegacyAppDatabaseV6(super.executor);

  factory LegacyAppDatabaseV6.forTesting(File file) {
    return LegacyAppDatabaseV6(NativeDatabase.createInBackground(file));
  }

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
    },
  );
}
