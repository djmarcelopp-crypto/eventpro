import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'legacy_tables_v11.dart';

part 'legacy_app_database_v11.g.dart';

/// Frozen AppDatabase at schemaVersion 11 (TASK-031 complete, pre billing).
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
    LegacyContractTemplates,
    LegacyContracts,
  ],
)
class LegacyAppDatabaseV11 extends _$LegacyAppDatabaseV11 {
  LegacyAppDatabaseV11(super.executor);

  factory LegacyAppDatabaseV11.forTesting(File file) {
    return LegacyAppDatabaseV11(NativeDatabase.createInBackground(file));
  }

  @override
  int get schemaVersion => 11;

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
