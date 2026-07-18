import 'package:eventpro/features/team/models/quote_team_member.dart';
import 'package:eventpro/features/team/providers/quote_team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'team_test_helpers.dart';

void main() {
  testWidgets('shows empty quote team state', (tester) async {
    await pumpTeamApp(
      tester,
      quotes: [buildTestQuote()],
      members: [buildTestMember()],
      initialLocation: '/quotes/quote-1/team',
    );

    expect(
      find.textContaining('Nenhum colaborador associado'),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('quote_team_empty_add_button')),
      findsOneWidget,
    );
  });

  testWidgets('lists associated quote team with summary cost', (tester) async {
    final now = DateTime(2026, 1, 1);
    await pumpTeamApp(
      tester,
      quotes: [buildTestQuote()],
      members: [buildTestMember(name: 'Ana Silva')],
      quoteTeam: [
        QuoteTeamMember(
          id: 'qt-1',
          quoteId: 'quote-1',
          teamMemberId: 'member-1',
          roleId: 'role-dj',
          dailyRate: 25_000,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      initialLocation: '/quotes/quote-1/team',
    );

    expect(find.byKey(const Key('quote_team_list')), findsOneWidget);
    expect(find.text('Ana Silva'), findsOneWidget);
    expect(find.byKey(const Key('quote_team_summary_total')), findsOneWidget);
  });

  testWidgets('adds member to quote through notifier and refreshes UI',
      (tester) async {
    final container = await pumpTeamApp(
      tester,
      quotes: [buildTestQuote()],
      members: [buildTestMember(name: 'Ana Silva')],
      initialLocation: '/quotes/quote-1/team',
    );

    final result = await container
        .read(quoteTeamProvider('quote-1').notifier)
        .add(teamMemberId: 'member-1');
    expect(result.isSuccess, isTrue);

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('quote_team_list')), findsOneWidget);
    expect(find.text('Ana Silva'), findsOneWidget);
  });

  testWidgets('opens add dialog from empty state', (tester) async {
    await pumpTeamApp(
      tester,
      quotes: [buildTestQuote()],
      members: [buildTestMember(name: 'Ana Silva')],
      initialLocation: '/quotes/quote-1/team',
    );

    await tester.tap(find.byKey(const Key('quote_team_empty_add_button')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Adicionar'), findsWidgets);
    expect(
      find.byKey(const Key('quote_team_add_save_button')),
      findsOneWidget,
    );
  });
}
