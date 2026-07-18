import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/providers/team_member_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'team_test_helpers.dart';

void main() {
  testWidgets('shows empty state when there are no members', (tester) async {
    await pumpTeamApp(tester);

    expect(find.text('Nenhum colaborador cadastrado'), findsOneWidget);
    expect(find.byKey(const Key('team_empty_new_button')), findsOneWidget);
  });

  testWidgets('shows summary cards and member list', (tester) async {
    await pumpTeamApp(
      tester,
      members: [
        buildTestMember(id: 'm-1', name: 'Ana Silva'),
        buildTestMember(
          id: 'm-2',
          name: 'Bruno Costa',
          status: TeamMemberStatus.unavailable,
        ),
      ],
    );

    expect(find.byKey(const Key('team_summary_active')), findsOneWidget);
    expect(find.byKey(const Key('team_summary_unavailable')), findsOneWidget);
    expect(find.byKey(const Key('team_summary_roles')), findsOneWidget);
    expect(find.byKey(const Key('team_list')), findsOneWidget);
    expect(find.text('Ana Silva'), findsOneWidget);
    expect(find.text('Bruno Costa'), findsOneWidget);
  });

  testWidgets('filters members by name query', (tester) async {
    await pumpTeamApp(
      tester,
      members: [
        buildTestMember(id: 'm-1', name: 'Ana Silva'),
        buildTestMember(id: 'm-2', name: 'Bruno Costa'),
      ],
    );

    await tester.enterText(
      find.byKey(const Key('team_filter_search')),
      'bruno',
    );
    await tester.pumpAndSettle();

    expect(find.text('Bruno Costa'), findsOneWidget);
    expect(find.text('Ana Silva'), findsNothing);
  });

  testWidgets('creates member via notifier and refreshes list', (tester) async {
    final container = await pumpTeamApp(tester);

    final result = await container.read(teamMemberProvider.notifier).addMember(
          buildTestMember(id: '', name: 'Diego Luz'),
        );
    expect(result.isSuccess, isTrue);

    await tester.pumpAndSettle();

    expect(container.read(teamMemberProvider).value, hasLength(1));
    expect(find.text('Diego Luz'), findsOneWidget);
  });

  testWidgets('opens new member form from empty state', (tester) async {
    await pumpTeamApp(tester);

    await tester.tap(find.byKey(const Key('team_empty_new_button')));
    await tester.pumpAndSettle();

    expect(find.text('Novo colaborador'), findsOneWidget);
    expect(find.byKey(const Key('team_form_save')), findsOneWidget);
  });

  testWidgets('opens roles screen from team list', (tester) async {
    await pumpTeamApp(tester);

    await tester.tap(find.byKey(const Key('team_roles_button')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Funções'), findsWidgets);
    expect(find.text('DJ'), findsOneWidget);
  });
}
