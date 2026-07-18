import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'legacy_tables_v10.dart';

part 'legacy_app_database_v10.g.dart';

/// Frozen AppDatabase at schemaVersion 10 (TASK-030 complete, pre contracts).
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
    LegacyTeamRoles,
    LegacyTeamMembers,
    LegacyQuoteTeamMembers,
    LegacyVehicleTypes,
    LegacyVehicles,
    LegacyQuoteVehicles,
  ],
)
class LegacyAppDatabaseV10 extends _$LegacyAppDatabaseV10 {
  LegacyAppDatabaseV10(super.executor);

  factory LegacyAppDatabaseV10.forTesting(File file) {
    return LegacyAppDatabaseV10(NativeDatabase.createInBackground(file));
  }

  @override
  int get schemaVersion => 10;

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
