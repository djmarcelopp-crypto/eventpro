// TASK-029 CP-B — migração real schema v6 -> v7 (team_roles / team_members).
import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'legacy_schema/legacy_app_database_v6.dart';

void main() {
  group('schema migration v6 -> v7 (TeamRoles, TeamMembers)', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'eventpro_team_migration_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'upgrading a genuine v6 database creates team tables and preserves data',
      () async {
        final legacy = LegacyAppDatabaseV6.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyQuotes,
            LegacyQuotesCompanion.insert(
              id: 'quote-v6',
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
            legacy.legacyEquipmentCategories,
            LegacyEquipmentCategoriesCompanion.insert(
              id: 'eq-cat-v6',
              name: 'Som',
              active: true,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyEquipments,
            LegacyEquipmentsCompanion.insert(
              id: 'eq-v6',
              name: 'Caixa',
              description: '',
              categoryId: 'eq-cat-v6',
              totalQuantity: 2,
              status: 'available',
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyQuoteEquipmentItems,
            LegacyQuoteEquipmentItemsCompanion.insert(
              id: 'link-v6',
              quoteId: 'quote-v6',
              equipmentId: 'eq-v6',
              quantity: 1,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
        });
        expect(legacy.schemaVersion, 6);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        expect(upgraded.schemaVersion, 7);

        expect(
          (await upgraded.select(upgraded.quotes).get()).single.id,
          'quote-v6',
        );
        expect(
          (await upgraded.select(upgraded.equipments).get()).single.id,
          'eq-v6',
        );
        expect(
          (await upgraded.select(upgraded.quoteEquipmentItems).get())
              .single
              .id,
          'link-v6',
        );

        final roles = await upgraded.select(upgraded.teamRoles).get();
        expect(roles, isEmpty);
        final members = await upgraded.select(upgraded.teamMembers).get();
        expect(members, isEmpty);

        final integrity = await upgraded
            .customSelect('PRAGMA integrity_check')
            .getSingle();
        expect(integrity.data.values.single, 'ok');

        await upgraded.into(upgraded.teamRoles).insert(
              TeamRolesCompanion.insert(
                id: 'role-1',
                name: 'DJ',
                active: true,
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );
        await upgraded.into(upgraded.teamMembers).insert(
              TeamMembersCompanion.insert(
                id: 'member-1',
                name: 'Ana',
                phone: '11999999999',
                roleId: 'role-1',
                dailyRate: 25_000,
                status: 'active',
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );

        expect(
          (await upgraded.select(upgraded.teamMembers).getSingle()).roleId,
          'role-1',
        );
      },
    );
  });
}
