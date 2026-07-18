import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:eventpro/features/team/models/quote_team_member.dart';
import 'package:eventpro/features/team/models/team_availability.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/utils/team_availability_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../fakes/fake_quote_team_repository.dart';
import '../fakes/fake_team_member_repository.dart';
import '../team_test_helpers.dart';

void main() {
  group('TeamAvailabilityService', () {
    late FakeTeamMemberRepository memberRepository;
    late FakeQuoteTeamRepository quoteTeamRepository;
    late FakeQuoteRepository quoteRepository;
    late TeamAvailabilityService service;
    final now = DateTime(2026, 1, 1);

    Quote consumingQuote({
      required String id,
      required DateTime eventDate,
      QuoteStatus status = QuoteStatus.approved,
    }) {
      return Quote(
        id: id,
        number: 'ORC-$id',
        status: status,
        clientSnapshot: const QuoteClientSnapshot(
          sourceClientId: 'c1',
          type: QuoteClientType.individual,
          displayName: 'Cliente',
          phone: '67999990000',
        ),
        eventSnapshot: QuoteEventSnapshot(
          name: 'Evento $id',
          date: eventDate,
        ),
        items: const [],
        subtotalCents: 0,
        discountCents: 0,
        freightCents: 0,
        totalCents: 0,
        statusHistory: [
          QuoteStatusHistoryEntry(
            previousStatus: null,
            newStatus: status,
            changedAt: now,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );
    }

    setUp(() {
      memberRepository = FakeTeamMemberRepository(
        initialMembers: [
          buildTestMember(id: 'free', name: 'Livre'),
          buildTestMember(id: 'busy', name: 'Ocupado'),
        ],
      );
      quoteTeamRepository = FakeQuoteTeamRepository();
      quoteRepository = FakeQuoteRepository();
      service = TeamAvailabilityService(
        memberRepository: memberRepository,
        quoteTeamRepository: quoteTeamRepository,
        quoteRepository: quoteRepository,
      );
    });

    test('listAll and summary with no links keep everyone available', () async {
      final items = await service.listAll();
      expect(items, hasLength(2));
      expect(items.every((item) => item.isAvailable), isTrue);

      final summary = await service.summary();
      expect(summary.availableCount, 2);
      expect(summary.unavailableCount, 0);
      expect(summary.conflictCount, 0);
      expect(summary.availabilityPercent, 100);
    });

    test('forMember returns null for unknown id', () async {
      expect(await service.forMember('missing'), isNull);
    });

    test('listAll marks linked members unavailable and counts conflicts',
        () async {
      quoteRepository = FakeQuoteRepository(
        initialQuotes: [
          consumingQuote(id: 'q1', eventDate: DateTime(2026, 8, 1)),
          consumingQuote(id: 'q2', eventDate: DateTime(2026, 8, 1)),
        ],
      );
      quoteTeamRepository = FakeQuoteTeamRepository(
        initialItems: [
          QuoteTeamMember(
            id: 'l1',
            quoteId: 'q1',
            teamMemberId: 'busy',
            roleId: 'role-dj',
            dailyRate: 25_000,
            createdAt: now,
            updatedAt: now,
          ),
          QuoteTeamMember(
            id: 'l2',
            quoteId: 'q2',
            teamMemberId: 'busy',
            roleId: 'role-dj',
            dailyRate: 25_000,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      );
      service = TeamAvailabilityService(
        memberRepository: memberRepository,
        quoteTeamRepository: quoteTeamRepository,
        quoteRepository: quoteRepository,
      );

      final busy = await service.forMember('busy');
      expect(busy!.status, TeamAvailabilityStatus.unavailable);
      expect(busy.conflicts, hasLength(2));

      final summary = await service.summary();
      expect(summary.availableCount, 1);
      expect(summary.unavailableCount, 1);
      expect(summary.conflictCount, 2);
    });

    test('TeamMemberStatus inactive does not change computed availability',
        () async {
      await memberRepository.update(
        buildTestMember(
          id: 'free',
          name: 'Livre',
          status: TeamMemberStatus.inactive,
        ),
      );

      final result = await service.forMember('free');
      expect(result!.status, TeamAvailabilityStatus.available);
    });
  });
}
