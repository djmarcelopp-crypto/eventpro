import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:drift/native.dart';

import 'database_path.dart';
import 'tables.dart';

part 'app_database.g.dart';
part 'daos/clients_dao.dart';
part 'daos/company_profiles_dao.dart';
part 'daos/catalog_dao.dart';
part 'daos/quotes_dao.dart';
part 'daos/agenda_blocks_dao.dart';
part 'daos/financial_categories_dao.dart';
part 'daos/financial_entries_dao.dart';

@DriftDatabase(
  tables: [
    Clients,
    CatalogItems,
    CatalogPackageComponents,
    CompanyProfiles,
    Quotes,
    QuoteClientSnapshots,
    QuoteEventSnapshots,
    QuoteCompanySnapshots,
    QuoteLineItems,
    QuoteLinePackageComponents,
    QuoteStatusHistory,
    QuoteNumberSequences,
    AgendaBlocks,
    FinancialCategories,
    FinancialEntries,
  ],
  daos: [
    ClientsDao,
    CompanyProfilesDao,
    CatalogDao,
    QuotesDao,
    AgendaBlocksDao,
    FinancialCategoriesDao,
    FinancialEntriesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.open({QueryExecutor? executor}) {
    return AppDatabase(executor ?? _openConnection());
  }

  factory AppDatabase.forTesting(File file) {
    return AppDatabase(NativeDatabase.createInBackground(file));
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
    onUpgrade: (Migrator migrator, int from, int to) async {
      // TASK-025 CP-A — primeira migração real do projeto: v1 (schema
      // congelado da TASK-024) não tinha `agenda_blocks`. Nenhuma tabela
      // existente é alterada; apenas a tabela nova é criada.
      if (from == 1 && to >= 2) {
        await migrator.createTable(agendaBlocks);
      }
      // TASK-027 CP-B — v2 (schema após a TASK-025) não tinha as tabelas do
      // domínio Financeiro. Nenhuma tabela existente é alterada; apenas as
      // tabelas novas são criadas. Cobre tanto quem já estava na v2 quanto
      // quem ainda está na v1 e salta direto para a v3.
      if (from <= 2 && to >= 3) {
        await migrator.createTable(financialCategories);
        await migrator.createTable(financialEntries);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'eventpro',
      native: DriftNativeOptions(
        databasePath: () async => (await resolveDatabaseFile()).path,
      ),
    );
  }
}

Future<bool> isForeignKeyEnforcementEnabled(AppDatabase database) async {
  final row = await database.customSelect('PRAGMA foreign_keys').getSingle();
  return row.read<int>('foreign_keys') == 1;
}
