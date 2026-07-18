import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'legacy_tables_v9.dart';

part 'legacy_app_database_v9.g.dart';

/// Frozen AppDatabase at schemaVersion 8 (schemaVersion 9 with vehicles, pre quote_vehicles).
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
  ],
)
class LegacyAppDatabaseV9 extends _$LegacyAppDatabaseV9 {
  LegacyAppDatabaseV9(super.executor);

  factory LegacyAppDatabaseV9.forTesting(File file) {
    return LegacyAppDatabaseV9(NativeDatabase.createInBackground(file));
  }

  @override
  int get schemaVersion => 9;

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
