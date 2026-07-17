// TASK-030 CP-B — migração real schema v8 -> v9 (vehicle_types / vehicles).
import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'legacy_schema/legacy_app_database_v8.dart';

void main() {
  group('schema migration v8 -> v9 (VehicleTypes, Vehicles)', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'eventpro_vehicle_migration_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'upgrading a genuine v8 database creates vehicle tables and preserves data',
      () async {
        final legacy = LegacyAppDatabaseV8.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyQuotes,
            LegacyQuotesCompanion.insert(
              id: 'quote-v8',
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
            legacy.legacyTeamRoles,
            LegacyTeamRolesCompanion.insert(
              id: 'role-v8',
              name: 'DJ',
              active: true,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyTeamMembers,
            LegacyTeamMembersCompanion.insert(
              id: 'member-v8',
              name: 'Ana',
              phone: '11999999999',
              roleId: 'role-v8',
              dailyRate: 25_000,
              status: 'active',
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyQuoteTeamMembers,
            LegacyQuoteTeamMembersCompanion.insert(
              id: 'link-v8',
              quoteId: 'quote-v8',
              teamMemberId: 'member-v8',
              roleId: 'role-v8',
              dailyRate: 25_000,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
        });
        expect(legacy.schemaVersion, 8);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        expect(upgraded.schemaVersion, 10);

        expect(
          (await upgraded.select(upgraded.quotes).get()).single.id,
          'quote-v8',
        );
        expect(
          (await upgraded.select(upgraded.quoteTeamMembers).get()).single.id,
          'link-v8',
        );

        expect(await upgraded.select(upgraded.vehicleTypes).get(), isEmpty);
        expect(await upgraded.select(upgraded.vehicles).get(), isEmpty);

        final integrity = await upgraded
            .customSelect('PRAGMA integrity_check')
            .getSingle();
        expect(integrity.data.values.single, 'ok');

        await upgraded.into(upgraded.vehicleTypes).insert(
              VehicleTypesCompanion.insert(
                id: 'type-1',
                name: 'Van',
                active: true,
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );
        await upgraded.into(upgraded.vehicles).insert(
              VehiclesCompanion.insert(
                id: 'vehicle-1',
                plate: 'ABC1D23',
                description: 'Van branca',
                vehicleTypeId: 'type-1',
                payloadCapacityKg: 800,
                volumeCapacityM3: 8.5,
                status: 'available',
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );

        expect(
          (await upgraded.select(upgraded.vehicles).getSingle()).vehicleTypeId,
          'type-1',
        );
      },
    );
  });
}
