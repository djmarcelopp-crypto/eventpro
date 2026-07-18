// Banco de dados congelado representando o schema real v4 (TASK-027),
// usado exclusivamente para criar um arquivo SQLite legado GENUÍNO em
// test/core/database/equipment_migration_test.dart, permitindo testar a
// migração real 4 -> 5 (TASK-028 CP-B) contra um banco de fato produzido
// pelo schema anterior — não uma simulação manual de SQL.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'legacy_tables_v4.dart';

part 'legacy_app_database_v4.g.dart';

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
  ],
)
class LegacyAppDatabaseV4 extends _$LegacyAppDatabaseV4 {
  LegacyAppDatabaseV4(super.executor);

  factory LegacyAppDatabaseV4.forTesting(File file) {
    return LegacyAppDatabaseV4(NativeDatabase.createInBackground(file));
  }

  @override
  int get schemaVersion => 4;

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
