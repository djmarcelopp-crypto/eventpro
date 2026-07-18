// TASK-031 CP-B — migração real schema v10 -> v11 (contract_templates / contracts).
import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'legacy_schema/legacy_app_database_v10.dart';

void main() {
  group('schema migration v10 -> v11 (ContractTemplates, Contracts)', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'eventpro_contract_migration_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'upgrading a genuine v10 database creates contract tables and preserves data',
      () async {
        final legacy = LegacyAppDatabaseV10.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyQuotes,
            LegacyQuotesCompanion.insert(
              id: 'quote-v10',
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
              id: 'type-v10',
              name: 'Van',
              active: true,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyVehicles,
            LegacyVehiclesCompanion.insert(
              id: 'vehicle-v10',
              plate: 'ABC1D23',
              description: '',
              vehicleTypeId: 'type-v10',
              payloadCapacityKg: 800,
              volumeCapacityM3: 8,
              status: 'available',
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyQuoteVehicles,
            LegacyQuoteVehiclesCompanion.insert(
              id: 'qv-v10',
              quoteId: 'quote-v10',
              vehicleId: 'vehicle-v10',
              freightCostCents: 0,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
        });
        expect(legacy.schemaVersion, 10);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        expect(upgraded.schemaVersion, 11);
        expect(
          (await upgraded.select(upgraded.quotes).get()).single.id,
          'quote-v10',
        );
        expect(
          (await upgraded.select(upgraded.quoteVehicles).get()).single.id,
          'qv-v10',
        );
        expect(await upgraded.select(upgraded.contractTemplates).get(), isEmpty);
        expect(await upgraded.select(upgraded.contracts).get(), isEmpty);

        final integrity = await upgraded
            .customSelect('PRAGMA integrity_check')
            .getSingle();
        expect(integrity.data.values.single, 'ok');

        await upgraded.into(upgraded.contractTemplates).insert(
              ContractTemplatesCompanion.insert(
                id: 'tpl-1',
                name: 'Padrão',
                active: true,
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );
        await upgraded.into(upgraded.contracts).insert(
              ContractsCompanion.insert(
                id: 'ctr-1',
                quoteId: 'quote-v10',
                contractNumber: 'CTR-2026-0001',
                status: 'draft',
                notes: '',
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );

        expect(
          (await upgraded.select(upgraded.contracts).get()).single.contractNumber,
          'CTR-2026-0001',
        );
      },
    );
  });
}
