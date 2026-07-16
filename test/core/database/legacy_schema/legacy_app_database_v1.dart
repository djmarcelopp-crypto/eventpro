// Banco de dados congelado representando o schema real v1 (TASK-024, CP-A a
// CP-H), usado exclusivamente para criar um arquivo SQLite legado GENUÍNO em
// test/core/database/agenda_migration_test.dart, permitindo testar a
// migração real 1 -> 2 (TASK-025 CP-A) contra um banco de fato produzido
// pelo schema anterior — não uma simulação manual de SQL.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'legacy_tables_v1.dart';

part 'legacy_app_database_v1.g.dart';

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
  ],
)
class LegacyAppDatabaseV1 extends _$LegacyAppDatabaseV1 {
  LegacyAppDatabaseV1(super.executor);

  factory LegacyAppDatabaseV1.forTesting(File file) {
    return LegacyAppDatabaseV1(NativeDatabase.createInBackground(file));
  }

  @override
  int get schemaVersion => 1;

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
