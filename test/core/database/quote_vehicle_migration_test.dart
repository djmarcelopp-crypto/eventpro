// TASK-030 CP-D — migração real schema v9 -> v10 (quote_vehicles).
import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'legacy_schema/legacy_app_database_v9.dart';

void main() {
  group('schema migration v9 -> v10 (QuoteVehicles)', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'eventpro_quote_vehicle_migration_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'upgrading a genuine v9 database creates quote_vehicles and preserves data',
      () async {
        final legacy = LegacyAppDatabaseV9.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyQuotes,
            LegacyQuotesCompanion.insert(
              id: 'quote-v9',
              number: 'ORC-2026-0001',
              status: 'draft',
              subtotalCents: 0,
              discountCents: 0,
              freightCents: 0,
              totalCents: 0,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyVehicleTypes,
            LegacyVehicleTypesCompanion.insert(
              id: 'type-v9',
              name: 'Van',
              active: true,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyVehicles,
            LegacyVehiclesCompanion.insert(
              id: 'vehicle-v9',
              plate: 'ABC1D23',
              description: '',
              vehicleTypeId: 'type-v9',
              payloadCapacityKg: 800,
              volumeCapacityM3: 8,
              status: 'available',
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
        });
        expect(legacy.schemaVersion, 9);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        expect(upgraded.schemaVersion, 10);
        expect(
          (await upgraded.select(upgraded.vehicles).get()).single.id,
          'vehicle-v9',
        );
        expect(await upgraded.select(upgraded.quoteVehicles).get(), isEmpty);

        final integrity = await upgraded
            .customSelect('PRAGMA integrity_check')
            .getSingle();
        expect(integrity.data.values.single, 'ok');
      },
    );
  });
}
