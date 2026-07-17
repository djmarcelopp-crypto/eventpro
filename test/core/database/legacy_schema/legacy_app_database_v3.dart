// Banco de dados congelado representando o schema real v3 (TASK-027 CP-B/
// CP-C), usado exclusivamente para criar um arquivo SQLite legado GENUÍNO em
// test/core/database/financial_entry_quote_link_migration_test.dart,
// permitindo testar a migração real 3 -> 4 (TASK-027 CP-D) contra um banco
// de fato produzido pelo schema anterior — não uma simulação manual de SQL.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'legacy_tables_v3.dart';

part 'legacy_app_database_v3.g.dart';

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
class LegacyAppDatabaseV3 extends _$LegacyAppDatabaseV3 {
  LegacyAppDatabaseV3(super.executor);

  factory LegacyAppDatabaseV3.forTesting(File file) {
    return LegacyAppDatabaseV3(NativeDatabase.createInBackground(file));
  }

  @override
  int get schemaVersion => 3;

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
