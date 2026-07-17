import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/team/data/mappers/quote_team_member_mapper.dart';
import 'package:eventpro/features/team/models/quote_team_member.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuoteTeamMemberMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    final createdAt = DateTime(2026, 7, 1, 12);
    final updatedAt = DateTime(2026, 7, 2, 15);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('quote_team_mapper_');
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

    test('round-trips all fields including nullable notes', () async {
      final original = QuoteTeamMember(
        id: 'link-1',
        quoteId: 'quote-1',
        teamMemberId: 'member-1',
        roleId: 'role-1',
        dailyRate: 25_000,
        notes: 'Lead',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      await database.into(database.quoteTeamMembers).insert(
            QuoteTeamMemberMapper.toInsertCompanion(original),
          );
      final row = await (database.select(database.quoteTeamMembers)
            ..where((tbl) => tbl.id.equals(original.id)))
          .getSingle();
      final restored = QuoteTeamMemberMapper.toDomain(row);

      expect(restored, original);

      await database.quoteTeamMembersDao.deleteById('link-1');

      final withoutNotes = original.copyWith(
        id: 'link-2',
        clearNotes: true,
      );
      await database.into(database.quoteTeamMembers).insert(
            QuoteTeamMemberMapper.toInsertCompanion(withoutNotes),
          );
      final restoredEmpty = QuoteTeamMemberMapper.toDomain(
        await (database.select(database.quoteTeamMembers)
              ..where((tbl) => tbl.id.equals('link-2')))
            .getSingle(),
      );
      expect(restoredEmpty.notes, isNull);
    });
  });
}
