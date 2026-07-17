// TASK-029 CP-D — migração real schema v7 -> v8 (quote_team_members).
import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'legacy_schema/legacy_app_database_v7.dart';

void main() {
  group('schema migration v7 -> v8 (QuoteTeamMembers)', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'eventpro_quote_team_migration_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'upgrading a genuine v7 database creates quote_team_members and preserves data',
      () async {
        final legacy = LegacyAppDatabaseV7.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyQuotes,
            LegacyQuotesCompanion.insert(
              id: 'quote-v7',
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
              id: 'role-v7',
              name: 'DJ',
              active: true,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyTeamMembers,
            LegacyTeamMembersCompanion.insert(
              id: 'member-v7',
              name: 'Ana',
              phone: '11999999999',
              roleId: 'role-v7',
              dailyRate: 25_000,
              status: 'active',
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
        });
        expect(legacy.schemaVersion, 7);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        expect(upgraded.schemaVersion, 10);

        expect(
          (await upgraded.select(upgraded.quotes).get()).single.id,
          'quote-v7',
        );
        expect(
          (await upgraded.select(upgraded.teamMembers).get()).single.id,
          'member-v7',
        );

        final links = await upgraded.select(upgraded.quoteTeamMembers).get();
        expect(links, isEmpty);

        final integrity = await upgraded
            .customSelect('PRAGMA integrity_check')
            .getSingle();
        expect(integrity.data.values.single, 'ok');

        await upgraded.into(upgraded.quoteTeamMembers).insert(
              QuoteTeamMembersCompanion.insert(
                id: 'link-1',
                quoteId: 'quote-v7',
                teamMemberId: 'member-v7',
                roleId: 'role-v7',
                dailyRate: 25_000,
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );

        expect(
          (await upgraded.select(upgraded.quoteTeamMembers).getSingle())
              .dailyRate,
          25_000,
        );
      },
    );
  });
}
