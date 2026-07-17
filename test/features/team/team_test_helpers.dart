import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:eventpro/features/team/models/quote_team_member.dart';
import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/models/team_role.dart';
import 'package:eventpro/features/team/new_team_member_screen.dart';
import 'package:eventpro/features/team/providers/quote_team_provider.dart';
import 'package:eventpro/features/team/providers/team_member_provider.dart';
import 'package:eventpro/features/team/providers/team_role_provider.dart';
import 'package:eventpro/features/team/quote_team_screen.dart';
import 'package:eventpro/features/team/team_member_detail_screen.dart';
import 'package:eventpro/features/team/team_roles_screen.dart';
import 'package:eventpro/features/team/team_screen.dart';
import 'package:eventpro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../quotes/fakes/fake_quote_repository.dart';
import 'fakes/fake_quote_team_repository.dart';
import 'fakes/fake_team_member_repository.dart';
import 'fakes/fake_team_role_repository.dart';
import 'fakes/team_repository_test_overrides.dart';

Quote buildTestQuote({String id = 'quote-1'}) {
  final now = DateTime(2026, 7, 13, 10);
  return Quote(
    id: id,
    number: 'ORC-001',
    status: QuoteStatus.draft,
    clientSnapshot: const QuoteClientSnapshot(
      sourceClientId: 'client-1',
      type: QuoteClientType.individual,
      displayName: 'Maria Silva',
      phone: '67999998888',
    ),
    eventSnapshot: const QuoteEventSnapshot(
      name: 'Casamento',
      date: null,
      guestCount: 100,
    ),
    items: const [],
    subtotalCents: 0,
    discountCents: 0,
    freightCents: 0,
    totalCents: 0,
    statusHistory: [
      QuoteStatusHistoryEntry(
        previousStatus: null,
        newStatus: QuoteStatus.draft,
        changedAt: now,
      ),
    ],
    createdAt: now,
    updatedAt: now,
  );
}

TeamRole buildTestRole({
  String id = 'role-dj',
  String name = 'DJ',
  bool active = true,
}) {
  final now = DateTime(2026, 1, 1);
  return TeamRole(
    id: id,
    name: name,
    active: active,
    createdAt: now,
    updatedAt: now,
  );
}

TeamMember buildTestMember({
  String id = 'member-1',
  String name = 'Ana Silva',
  String roleId = 'role-dj',
  int dailyRate = 25_000,
  TeamMemberStatus status = TeamMemberStatus.active,
}) {
  final now = DateTime(2026, 1, 1);
  return TeamMember(
    id: id,
    name: name,
    phone: '11999999999',
    roleId: roleId,
    dailyRate: dailyRate,
    status: status,
    createdAt: now,
    updatedAt: now,
  );
}

Future<ProviderContainer> pumpTeamApp(
  WidgetTester tester, {
  List<TeamMember> members = const [],
  List<TeamRole>? roles,
  List<Quote> quotes = const [],
  List<QuoteTeamMember> quoteTeam = const [],
  String initialLocation = '/team',
  List<Override> extraOverrides = const [],
  FakeTeamMemberRepository? memberRepository,
  FakeTeamRoleRepository? roleRepository,
  FakeQuoteTeamRepository? quoteTeamRepository,
  FakeQuoteRepository? quoteRepository,
  DateTime Function()? clock,
}) async {
  final resolvedRoles = roles ?? [buildTestRole()];

  final memberRepo =
      memberRepository ?? FakeTeamMemberRepository(initialMembers: members);
  final roleRepo =
      roleRepository ?? FakeTeamRoleRepository(initialRoles: resolvedRoles);
  final quoteTeamRepo =
      quoteTeamRepository ??
      FakeQuoteTeamRepository(initialItems: quoteTeam);
  final quoteRepo =
      quoteRepository ?? FakeQuoteRepository(initialQuotes: quotes);

  final container = ProviderContainer(
    overrides: [
      ...teamRepositoryOverrides(
        memberRepository: memberRepo,
        roleRepository: roleRepo,
        quoteTeamRepository: quoteTeamRepo,
        quoteRepository: quoteRepo,
        clock: clock ?? () => DateTime(2030, 1, 1, 12),
      ),
      ...extraOverrides,
    ],
  );

  await container.read(teamMemberProvider.future);
  await container.read(teamRoleProvider.future);
  if (initialLocation.contains('/team') &&
      initialLocation.startsWith('/quotes/')) {
    final quoteId = initialLocation.split('/')[2];
    await container.read(quoteTeamProvider(quoteId).future);
  }

  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/team',
        builder: (context, state) => const TeamScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const NewTeamMemberScreen(),
          ),
          GoRoute(
            path: 'roles',
            builder: (context, state) => const TeamRolesScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => TeamMemberDetailScreen(
              memberId: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => NewTeamMemberScreen(
                  memberId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/quotes/:id/team',
        builder: (context, state) => QuoteTeamScreen(
          quoteId: state.pathParameters['id']!,
        ),
      ),
    ],
  );

  await tester.binding.setSurfaceSize(const Size(1280, 900));
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        scaffoldMessengerKey: EventProApp.scaffoldMessengerKey,
        locale: const Locale('pt', 'BR'),
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();

  addTearDown(container.dispose);
  return container;
}
