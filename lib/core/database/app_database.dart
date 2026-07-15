import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:drift/native.dart';

import 'database_path.dart';
import 'tables.dart';

part 'app_database.g.dart';
part 'daos/clients_dao.dart';

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
  ],
  daos: [ClientsDao],
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
