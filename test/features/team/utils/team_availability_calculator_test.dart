import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:eventpro/features/team/models/quote_team_member.dart';
import 'package:eventpro/features/team/models/team_availability.dart';
import 'package:eventpro/features/team/models/team_event_period.dart';
import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/utils/team_availability_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 1, 1);

  TeamMember member({
    String id = 'member-1',
    TeamMemberStatus status = TeamMemberStatus.active,
  }) {
    return TeamMember(
      id: id,
      name: 'Ana',
      phone: '11999999999',
      roleId: 'role-1',
      dailyRate: 25_000,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  Quote quote({
    required String id,
    required DateTime eventDate,
    QuoteStatus status = QuoteStatus.approved,
    String? startTime,
    String? endTime,
    String eventName = 'Evento',
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
        name: '$eventName $id',
        date: eventDate,
        startTime: startTime,
        endTime: endTime,
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

  QuoteTeamMember link({
    required String id,
    required String quoteId,
    required String teamMemberId,
  }) {
    return QuoteTeamMember(
      id: id,
      quoteId: quoteId,
      teamMemberId: teamMemberId,
      roleId: 'role-1',
      dailyRate: 25_000,
      createdAt: now,
      updatedAt: now,
    );
  }

  group('TeamAvailabilityCalculator', () {
    test('member is available when not linked to consuming quotes', () {
      final result = TeamAvailabilityCalculator.calculateForMember(
        member: member(),
        quoteTeamMembers: const [],
        quotesById: const {},
      );

      expect(result.status, TeamAvailabilityStatus.available);
      expect(result.consumingQuotes, isEmpty);
      expect(result.conflicts, isEmpty);
    });

    test('member is unavailable when linked to a quote with period', () {
      final q1 = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final result = TeamAvailabilityCalculator.calculateForMember(
        member: member(),
        quoteTeamMembers: [
          link(id: 'l1', quoteId: 'q1', teamMemberId: 'member-1'),
        ],
        quotesById: {'q1': q1},
      );

      expect(result.status, TeamAvailabilityStatus.unavailable);
      expect(result.consumingQuotes, hasLength(1));
      expect(result.consumingQuotes.single.quoteNumber, 'ORC-q1');
      expect(result.consumingQuotes.single.eventName, 'Evento q1');
      expect(result.conflicts, isEmpty);
    });

    test('non-overlapping periods do not create conflicts', () {
      final q1 = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final q2 = quote(id: 'q2', eventDate: DateTime(2026, 8, 2));
      final result = TeamAvailabilityCalculator.calculateForMember(
        member: member(),
        quoteTeamMembers: [
          link(id: 'l1', quoteId: 'q1', teamMemberId: 'member-1'),
          link(id: 'l2', quoteId: 'q2', teamMemberId: 'member-1'),
        ],
        quotesById: {'q1': q1, 'q2': q2},
      );

      expect(result.status, TeamAvailabilityStatus.unavailable);
      expect(result.consumingQuotes, hasLength(2));
      expect(result.conflicts, isEmpty);
    });

    test('consecutive touching periods do not conflict', () {
      final q1 = quote(
        id: 'q1',
        eventDate: DateTime(2026, 8, 1),
        startTime: '10:00',
        endTime: '12:00',
      );
      final q2 = quote(
        id: 'q2',
        eventDate: DateTime(2026, 8, 1),
        startTime: '12:00',
        endTime: '14:00',
      );
      final result = TeamAvailabilityCalculator.calculateForMember(
        member: member(),
        quoteTeamMembers: [
          link(id: 'l1', quoteId: 'q1', teamMemberId: 'member-1'),
          link(id: 'l2', quoteId: 'q2', teamMemberId: 'member-1'),
        ],
        quotesById: {'q1': q1, 'q2': q2},
      );

      expect(result.conflicts, isEmpty);
    });

    test('total overlap creates schedule conflicts', () {
      final q1 = quote(
        id: 'q1',
        eventDate: DateTime(2026, 8, 1),
        startTime: '10:00',
        endTime: '18:00',
      );
      final q2 = quote(
        id: 'q2',
        eventDate: DateTime(2026, 8, 1),
        startTime: '10:00',
        endTime: '18:00',
      );
      final result = TeamAvailabilityCalculator.calculateForMember(
        member: member(),
        quoteTeamMembers: [
          link(id: 'l1', quoteId: 'q1', teamMemberId: 'member-1'),
          link(id: 'l2', quoteId: 'q2', teamMemberId: 'member-1'),
        ],
        quotesById: {'q1': q1, 'q2': q2},
      );

      expect(result.conflicts, hasLength(2));
      expect(
        result.conflicts.map((c) => c.quoteId).toSet(),
        {'q1', 'q2'},
      );
      expect(
        result.conflicts.every(
          (c) => c.reason == TeamAvailabilityCalculator.totalOverlapReason,
        ),
        isTrue,
      );
      expect(result.conflicts.every((c) => c.teamMemberId == 'member-1'), isTrue);
    });

    test('partial overlap creates schedule conflicts', () {
      final q1 = quote(
        id: 'q1',
        eventDate: DateTime(2026, 8, 1),
        startTime: '10:00',
        endTime: '14:00',
      );
      final q2 = quote(
        id: 'q2',
        eventDate: DateTime(2026, 8, 1),
        startTime: '12:00',
        endTime: '16:00',
      );
      final result = TeamAvailabilityCalculator.calculateForMember(
        member: member(),
        quoteTeamMembers: [
          link(id: 'l1', quoteId: 'q1', teamMemberId: 'member-1'),
          link(id: 'l2', quoteId: 'q2', teamMemberId: 'member-1'),
        ],
        quotesById: {'q1': q1, 'q2': q2},
      );

      expect(result.conflicts, hasLength(2));
      expect(
        result.conflicts.every(
          (c) => c.reason == TeamAvailabilityCalculator.partialOverlapReason,
        ),
        isTrue,
      );
    });

    test('cancelled and rejected quotes do not consume availability', () {
      final approved = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final cancelled = quote(
        id: 'q2',
        eventDate: DateTime(2026, 8, 1),
        status: QuoteStatus.cancelled,
      );
      final rejected = quote(
        id: 'q3',
        eventDate: DateTime(2026, 8, 1),
        status: QuoteStatus.rejected,
      );
      final result = TeamAvailabilityCalculator.calculateForMember(
        member: member(),
        quoteTeamMembers: [
          link(id: 'l1', quoteId: 'q1', teamMemberId: 'member-1'),
          link(id: 'l2', quoteId: 'q2', teamMemberId: 'member-1'),
          link(id: 'l3', quoteId: 'q3', teamMemberId: 'member-1'),
        ],
        quotesById: {
          'q1': approved,
          'q2': cancelled,
          'q3': rejected,
        },
      );

      expect(result.consumingQuotes.map((c) => c.quoteId), ['q1']);
      expect(result.status, TeamAvailabilityStatus.unavailable);
      expect(result.conflicts, isEmpty);
    });

    test('quotes without event date do not consume availability', () {
      final withoutDate = Quote(
        id: 'q1',
        number: 'ORC-q1',
        status: QuoteStatus.approved,
        clientSnapshot: const QuoteClientSnapshot(
          sourceClientId: 'c1',
          type: QuoteClientType.individual,
          displayName: 'Cliente',
          phone: '67999990000',
        ),
        eventSnapshot: const QuoteEventSnapshot(name: 'Sem data'),
        items: const [],
        subtotalCents: 0,
        discountCents: 0,
        freightCents: 0,
        totalCents: 0,
        statusHistory: [
          QuoteStatusHistoryEntry(
            previousStatus: null,
            newStatus: QuoteStatus.approved,
            changedAt: now,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );

      final result = TeamAvailabilityCalculator.calculateForMember(
        member: member(),
        quoteTeamMembers: [
          link(id: 'l1', quoteId: 'q1', teamMemberId: 'member-1'),
        ],
        quotesById: {'q1': withoutDate},
      );

      expect(result.status, TeamAvailabilityStatus.available);
      expect(result.consumingQuotes, isEmpty);
    });

    test('TeamMemberStatus does not affect availability calculation', () {
      final q1 = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final result = TeamAvailabilityCalculator.calculateForMember(
        member: member(status: TeamMemberStatus.inactive),
        quoteTeamMembers: [
          link(id: 'l1', quoteId: 'q1', teamMemberId: 'member-1'),
        ],
        quotesById: {'q1': q1},
      );

      expect(result.status, TeamAvailabilityStatus.unavailable);
    });

    test('query period marks member available when no overlap', () {
      final q1 = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final result = TeamAvailabilityCalculator.calculateForMember(
        member: member(),
        quoteTeamMembers: [
          link(id: 'l1', quoteId: 'q1', teamMemberId: 'member-1'),
        ],
        quotesById: {'q1': q1},
        queryPeriod: TeamEventPeriod(
          start: DateTime(2026, 9, 1),
          end: DateTime(2026, 9, 2),
        ),
      );

      expect(result.status, TeamAvailabilityStatus.available);
      expect(result.consumingQuotes, hasLength(1));
    });

    test('summary aggregates availability and conflict counts', () {
      final items = TeamAvailabilityCalculator.calculateAll(
        members: [
          member(id: 'free'),
          member(id: 'busy'),
          member(id: 'conflicted'),
        ],
        quoteTeamMembers: [
          link(id: 'l1', quoteId: 'q1', teamMemberId: 'busy'),
          link(id: 'l2', quoteId: 'q1', teamMemberId: 'conflicted'),
          link(id: 'l3', quoteId: 'q2', teamMemberId: 'conflicted'),
        ],
        quotes: [
          quote(id: 'q1', eventDate: DateTime(2026, 8, 1)),
          quote(id: 'q2', eventDate: DateTime(2026, 8, 1)),
        ],
      );

      final summary = TeamAvailabilityCalculator.summarize(items);
      expect(summary.totalMembers, 3);
      expect(summary.availableCount, 1);
      expect(summary.unavailableCount, 2);
      expect(summary.conflictCount, 2);
      expect(summary.availabilityPercent, closeTo(100 / 3, 0.001));
    });
  });
}
