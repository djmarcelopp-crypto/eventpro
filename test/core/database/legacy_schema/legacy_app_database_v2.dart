// Banco de dados congelado representando o schema real v2 (TASK-025 CP-A),
// usado exclusivamente para criar um arquivo SQLite legado GENUÍNO em
// test/core/database/financial_migration_test.dart, permitindo testar a
// migração real 2 -> 3 (TASK-027 CP-B) contra um banco de fato produzido
// pelo schema anterior — não uma simulação manual de SQL.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'legacy_tables_v2.dart';

part 'legacy_app_database_v2.g.dart';

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
  ],
)
class LegacyAppDatabaseV2 extends _$LegacyAppDatabaseV2 {
  LegacyAppDatabaseV2(super.executor);

  factory LegacyAppDatabaseV2.forTesting(File file) {
    return LegacyAppDatabaseV2(NativeDatabase.createInBackground(file));
  }

  @override
  int get schemaVersion => 2;

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
