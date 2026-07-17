import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuoteTeamMembersDao', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('quote_team_dao_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      await database.into(database.quotes).insert(
            QuotesCompanion.insert(
              id: 'quote-1',
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
      await database.into(database.teamRoles).insert(
            TeamRolesCompanion.insert(
              id: 'role-1',
              name: 'DJ',
              active: true,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
      await database.into(database.teamMembers).insert(
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
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('DAO CRUD and list by quote id', () async {
      final dao = database.quoteTeamMembersDao;

      await dao.insertRow(
        QuoteTeamMembersCompanion.insert(
          id: 'link-1',
          quoteId: 'quote-1',
          teamMemberId: 'member-1',
          roleId: 'role-1',
          dailyRate: 25_000,
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_000_000,
        ),
      );

      expect((await dao.getAllOrdered()).single.dailyRate, 25_000);
      expect((await dao.getById('link-1'))?.teamMemberId, 'member-1');
      expect((await dao.getAllByQuoteId('quote-1')).single.id, 'link-1');

      final updated = await dao.updateRow(
        QuoteTeamMembersCompanion.insert(
          id: 'link-1',
          quoteId: 'quote-1',
          teamMemberId: 'member-1',
          roleId: 'role-1',
          dailyRate: 30_000,
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_100_000,
        ),
      );
      expect(updated, isTrue);
      expect((await dao.getById('link-1'))?.dailyRate, 30_000);

      expect(await dao.deleteById('link-1'), isTrue);
      expect(await dao.getById('link-1'), isNull);
    });
  });
}
