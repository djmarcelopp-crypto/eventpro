import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/team/data/repositories/drift_quote_team_repository.dart';
import 'package:eventpro/features/team/models/quote_team_member.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftQuoteTeamRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftQuoteTeamRepository repository;

    final stamp = DateTime(2026, 7, 1, 9);

    Future<void> seedParents() async {
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
      await database.into(database.quotes).insert(
            QuotesCompanion.insert(
              id: 'quote-2',
              number: 'ORC-2026-0002',
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
      await database.into(database.teamMembers).insert(
            TeamMembersCompanion.insert(
              id: 'member-2',
              name: 'Bruno',
              phone: '11888888888',
              roleId: 'role-1',
              dailyRate: 15_000,
              status: 'active',
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
    }

    QuoteTeamMember buildLink({
      required String id,
      required String quoteId,
      required String teamMemberId,
      int dailyRate = 25_000,
    }) {
      return QuoteTeamMember(
        id: id,
        quoteId: quoteId,
        teamMemberId: teamMemberId,
        roleId: 'role-1',
        dailyRate: dailyRate,
        createdAt: stamp,
        updatedAt: stamp,
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('quote_team_repo_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      repository = DriftQuoteTeamRepository(database);
      await seedParents();
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('CRUD isolates lines by quote and orders by createdAt', () async {
      await repository.insert(
        buildLink(id: 'link-1', quoteId: 'quote-1', teamMemberId: 'member-1'),
      );
      await repository.insert(
        buildLink(
          id: 'link-2',
          quoteId: 'quote-2',
          teamMemberId: 'member-2',
          dailyRate: 15_000,
        ),
      );

      expect(
        (await repository.listByQuoteId('quote-1')).single.id,
        'link-1',
      );
      expect((await repository.findById('link-2'))?.dailyRate, 15_000);

      await repository.update(
        buildLink(
          id: 'link-1',
          quoteId: 'quote-1',
          teamMemberId: 'member-1',
          dailyRate: 30_000,
        ),
      );
      expect((await repository.findById('link-1'))?.dailyRate, 30_000);

      await repository.delete('link-1');
      expect(await repository.findById('link-1'), isNull);
      expect((await repository.listAll()).single.id, 'link-2');
    });

    test('FK cascade deletes links when quote is deleted', () async {
      await repository.insert(
        buildLink(id: 'link-1', quoteId: 'quote-1', teamMemberId: 'member-1'),
      );

      await (database.delete(database.quotes)
            ..where((tbl) => tbl.id.equals('quote-1')))
          .go();

      expect(await repository.listByQuoteId('quote-1'), isEmpty);
    });

    test('FK restrict blocks deleting a member still linked to a quote',
        () async {
      await repository.insert(
        buildLink(id: 'link-1', quoteId: 'quote-1', teamMemberId: 'member-1'),
      );

      await expectLater(
        (database.delete(database.teamMembers)
              ..where((tbl) => tbl.id.equals('member-1')))
            .go(),
        throwsA(anything),
      );
    });

    test('rejects insert with unknown foreign keys', () async {
      await expectLater(
        repository.insert(
          buildLink(
            id: 'bad',
            quoteId: 'missing-quote',
            teamMemberId: 'member-1',
          ),
        ),
        throwsA(anything),
      );
    });
  });
}
