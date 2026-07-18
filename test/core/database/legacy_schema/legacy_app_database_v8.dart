import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'legacy_tables_v8.dart';

part 'legacy_app_database_v8.g.dart';

/// Frozen AppDatabase at schemaVersion 8 (pre TASK-030 logistics tables).
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
  ],
)
class LegacyAppDatabaseV8 extends _$LegacyAppDatabaseV8 {
  LegacyAppDatabaseV8(super.executor);

  factory LegacyAppDatabaseV8.forTesting(File file) {
    return LegacyAppDatabaseV8(NativeDatabase.createInBackground(file));
  }

  @override
  int get schemaVersion => 8;

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
