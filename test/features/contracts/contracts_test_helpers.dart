import 'package:eventpro/features/contracts/contract_detail_screen.dart';
import 'package:eventpro/features/contracts/contract_templates_screen.dart';
import 'package:eventpro/features/contracts/contracts_screen.dart';
import 'package:eventpro/features/contracts/models/contract.dart';
import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/models/contract_template.dart';
import 'package:eventpro/features/contracts/providers/contract_provider.dart';
import 'package:eventpro/features/contracts/providers/contract_template_provider.dart';
import 'package:eventpro/features/contracts/providers/quote_contract_provider.dart';
import 'package:eventpro/features/contracts/quote_contracts_screen.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:eventpro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../quotes/fakes/fake_quote_repository.dart';
import 'fakes/contracts_repository_test_overrides.dart';
import 'fakes/fake_contract_repository.dart';
import 'fakes/fake_contract_template_repository.dart';

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

ContractTemplate buildTestTemplate({
  String id = 'template-1',
  String name = 'Padrão',
  bool active = true,
}) {
  final now = DateTime(2026, 1, 1);
  return ContractTemplate(
    id: id,
    name: name,
    description: 'Modelo padrão',
    active: active,
    createdAt: now,
    updatedAt: now,
  );
}

Contract buildTestContract({
  String id = 'contract-1',
  String quoteId = 'quote-1',
  String contractNumber = 'CTR-2026-0001',
  ContractStatus status = ContractStatus.draft,
  String? templateId,
  DateTime? generatedAt,
  DateTime? sentAt,
  DateTime? signedAt,
  DateTime? expiresAt,
}) {
  final now = DateTime(2026, 1, 1, 12);
  return Contract(
    id: id,
    quoteId: quoteId,
    templateId: templateId,
    contractNumber: contractNumber,
    status: status,
    generatedAt: generatedAt,
    sentAt: sentAt,
    signedAt: signedAt,
    expiresAt: expiresAt,
    createdAt: now,
    updatedAt: now,
  );
}

Future<ProviderContainer> pumpContractsApp(
  WidgetTester tester, {
  List<Contract> contracts = const [],
  List<ContractTemplate>? templates,
  List<Quote> quotes = const [],
  String initialLocation = '/contracts',
  List<Override> extraOverrides = const [],
  FakeContractRepository? contractRepository,
  FakeContractTemplateRepository? templateRepository,
  FakeQuoteRepository? quoteRepository,
  DateTime Function()? clock,
}) async {
  final resolvedTemplates = templates ?? [buildTestTemplate()];
  final contractRepo =
      contractRepository ?? FakeContractRepository(initialContracts: contracts);
  final templateRepo = templateRepository ??
      FakeContractTemplateRepository(initialTemplates: resolvedTemplates);
  final quoteRepo =
      quoteRepository ?? FakeQuoteRepository(initialQuotes: quotes);

  final container = ProviderContainer(
    overrides: [
      ...contractsRepositoryOverrides(
        contractRepository: contractRepo,
        templateRepository: templateRepo,
        quoteRepository: quoteRepo,
        clock: clock ?? () => DateTime(2026, 7, 17, 12),
      ),
      ...extraOverrides,
    ],
  );

  await container.read(contractProvider.future);
  await container.read(contractTemplateProvider.future);
  if (initialLocation.contains('/contracts') &&
      initialLocation.startsWith('/quotes/')) {
    final quoteId = initialLocation.split('/')[2];
    await container.read(quoteContractProvider(quoteId).future);
  }

  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/contracts',
        builder: (context, state) => const ContractsScreen(),
        routes: [
          GoRoute(
            path: 'templates',
            builder: (context, state) => const ContractTemplatesScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => ContractDetailScreen(
              contractId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/quotes/:id/contracts',
        builder: (context, state) => QuoteContractsScreen(
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
