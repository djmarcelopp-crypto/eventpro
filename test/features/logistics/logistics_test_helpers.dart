import 'package:eventpro/features/logistics/models/quote_vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/models/vehicle_type.dart';
import 'package:eventpro/features/logistics/new_vehicle_screen.dart';
import 'package:eventpro/features/logistics/providers/quote_vehicle_provider.dart';
import 'package:eventpro/features/logistics/providers/vehicle_provider.dart';
import 'package:eventpro/features/logistics/providers/vehicle_type_provider.dart';
import 'package:eventpro/features/logistics/quote_vehicles_screen.dart';
import 'package:eventpro/features/logistics/vehicle_detail_screen.dart';
import 'package:eventpro/features/logistics/vehicle_types_screen.dart';
import 'package:eventpro/features/logistics/vehicles_screen.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/providers/team_member_provider.dart';
import 'package:eventpro/features/team/providers/team_member_repository_provider.dart';
import 'package:eventpro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../quotes/fakes/fake_quote_repository.dart';
import '../team/fakes/fake_team_member_repository.dart';
import 'fakes/fake_quote_vehicle_repository.dart';
import 'fakes/fake_vehicle_repository.dart';
import 'fakes/fake_vehicle_type_repository.dart';
import 'fakes/logistics_repository_test_overrides.dart';

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

VehicleType buildTestType({
  String id = 'type-van',
  String name = 'Van',
  bool active = true,
}) {
  final now = DateTime(2026, 1, 1);
  return VehicleType(
    id: id,
    name: name,
    active: active,
    createdAt: now,
    updatedAt: now,
  );
}

Vehicle buildTestVehicle({
  String id = 'vehicle-1',
  String plate = 'ABC1D23',
  String vehicleTypeId = 'type-van',
  VehicleStatus status = VehicleStatus.available,
  String description = 'Van branca',
}) {
  final now = DateTime(2026, 1, 1);
  return Vehicle(
    id: id,
    plate: plate,
    description: description,
    vehicleTypeId: vehicleTypeId,
    payloadCapacityKg: 800,
    volumeCapacityM3: 8,
    status: status,
    createdAt: now,
    updatedAt: now,
  );
}

TeamMember buildTestDriver({
  String id = 'driver-1',
  String name = 'Carlos Motorista',
}) {
  final now = DateTime(2026, 1, 1);
  return TeamMember(
    id: id,
    name: name,
    phone: '11988887777',
    roleId: 'role-driver',
    dailyRate: 20_000,
    status: TeamMemberStatus.active,
    createdAt: now,
    updatedAt: now,
  );
}

Future<ProviderContainer> pumpLogisticsApp(
  WidgetTester tester, {
  List<Vehicle> vehicles = const [],
  List<VehicleType>? types,
  List<Quote> quotes = const [],
  List<QuoteVehicle> quoteVehicles = const [],
  List<TeamMember> members = const [],
  String initialLocation = '/vehicles',
  List<Override> extraOverrides = const [],
  FakeVehicleRepository? vehicleRepository,
  FakeVehicleTypeRepository? typeRepository,
  FakeQuoteVehicleRepository? quoteVehicleRepository,
  FakeQuoteRepository? quoteRepository,
  FakeTeamMemberRepository? memberRepository,
  DateTime Function()? clock,
}) async {
  final resolvedTypes = types ?? [buildTestType()];
  final vehicleRepo =
      vehicleRepository ?? FakeVehicleRepository(initialVehicles: vehicles);
  final typeRepo =
      typeRepository ?? FakeVehicleTypeRepository(initialTypes: resolvedTypes);
  final quoteVehicleRepo = quoteVehicleRepository ??
      FakeQuoteVehicleRepository(initialItems: quoteVehicles);
  final quoteRepo =
      quoteRepository ?? FakeQuoteRepository(initialQuotes: quotes);
  final memberRepo =
      memberRepository ?? FakeTeamMemberRepository(initialMembers: members);

  final container = ProviderContainer(
    overrides: [
      ...logisticsRepositoryOverrides(
        vehicleRepository: vehicleRepo,
        typeRepository: typeRepo,
        quoteVehicleRepository: quoteVehicleRepo,
        quoteRepository: quoteRepo,
        clock: clock ?? () => DateTime(2030, 1, 1, 12),
      ),
      teamMemberRepositoryProvider.overrideWithValue(memberRepo),
      ...extraOverrides,
    ],
  );

  await container.read(vehicleProvider.future);
  await container.read(vehicleTypeProvider.future);
  await container.read(teamMemberProvider.future);
  if (initialLocation.contains('/vehicles') &&
      initialLocation.startsWith('/quotes/')) {
    final quoteId = initialLocation.split('/')[2];
    await container.read(quoteVehicleProvider(quoteId).future);
  }

  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/vehicles',
        builder: (context, state) => const VehiclesScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const NewVehicleScreen(),
          ),
          GoRoute(
            path: 'types',
            builder: (context, state) => const VehicleTypesScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => VehicleDetailScreen(
              vehicleId: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => NewVehicleScreen(
                  vehicleId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/quotes/:id/vehicles',
        builder: (context, state) => QuoteVehiclesScreen(
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
