import 'package:eventpro/features/billing/invoice_detail_screen.dart';
import 'package:eventpro/features/billing/invoices_screen.dart';
import 'package:eventpro/features/billing/models/invoice.dart';
import 'package:eventpro/features/billing/models/invoice_item.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:eventpro/features/billing/new_invoice_screen.dart';
import 'package:eventpro/features/billing/providers/invoice_provider.dart';
import 'package:eventpro/features/billing/providers/quote_invoice_provider.dart';
import 'package:eventpro/features/billing/quote_invoices_screen.dart';
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
import 'fakes/billing_repository_test_overrides.dart';
import 'fakes/fake_invoice_item_repository.dart';
import 'fakes/fake_invoice_repository.dart';

Quote buildTestQuote({String id = 'quote-1'}) {
  final now = DateTime(2026, 7, 17, 12);
  return Quote(
    id: id,
    number: 'ORC-001',
    status: QuoteStatus.approved,
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
        newStatus: QuoteStatus.approved,
        changedAt: now,
      ),
    ],
    createdAt: now,
    updatedAt: now,
  );
}

Invoice buildTestInvoice({
  String id = 'invoice-1',
  String quoteId = 'quote-1',
  String invoiceNumber = 'INV-2026-0001',
  InvoiceStatus status = InvoiceStatus.draft,
  InvoiceType type = InvoiceType.service,
  int subtotalCents = 10000,
  int taxCents = 0,
  int discountCents = 0,
  int totalCents = 10000,
  DateTime? issueDate,
  DateTime? paidAt,
}) {
  final now = DateTime(2026, 7, 17, 12);
  return Invoice(
    id: id,
    quoteId: quoteId,
    invoiceNumber: invoiceNumber,
    type: type,
    status: status,
    subtotalCents: subtotalCents,
    taxCents: taxCents,
    discountCents: discountCents,
    totalCents: totalCents,
    issueDate: issueDate,
    paidAt: paidAt,
    createdAt: now,
    updatedAt: now,
  );
}

InvoiceItem buildTestInvoiceItem({
  String id = 'item-1',
  String invoiceId = 'invoice-1',
  String description = 'Som',
  double quantity = 1,
  int unitPriceCents = 10000,
}) {
  return InvoiceItem(
    id: id,
    invoiceId: invoiceId,
    description: description,
    quantity: quantity,
    unitPriceCents: unitPriceCents,
    totalPriceCents: (quantity * unitPriceCents).round(),
  );
}

Future<ProviderContainer> pumpBillingApp(
  WidgetTester tester, {
  List<Invoice> invoices = const [],
  List<InvoiceItem> items = const [],
  List<Quote> quotes = const [],
  String initialLocation = '/invoices',
  List<Override> extraOverrides = const [],
  FakeInvoiceRepository? invoiceRepository,
  FakeInvoiceItemRepository? itemRepository,
  FakeQuoteRepository? quoteRepository,
  DateTime Function()? clock,
}) async {
  final invoiceRepo =
      invoiceRepository ?? FakeInvoiceRepository(initialInvoices: invoices);
  final itemRepo =
      itemRepository ?? FakeInvoiceItemRepository(initialItems: items);
  final quoteRepo =
      quoteRepository ?? FakeQuoteRepository(initialQuotes: quotes);

  final container = ProviderContainer(
    overrides: [
      ...billingRepositoryOverrides(
        invoiceRepository: invoiceRepo,
        itemRepository: itemRepo,
        quoteRepository: quoteRepo,
        clock: clock ?? () => DateTime(2026, 7, 17, 12),
      ),
      ...extraOverrides,
    ],
  );

  await container.read(invoiceProvider.future);
  if (initialLocation.contains('/invoices') &&
      initialLocation.startsWith('/quotes/')) {
    final quoteId = initialLocation.split('/')[2];
    await container.read(quoteInvoiceProvider(quoteId).future);
  }

  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/invoices',
        builder: (context, state) => const InvoicesScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) {
              final quoteId = state.uri.queryParameters['quoteId'];
              return NewInvoiceScreen(initialQuoteId: quoteId);
            },
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => InvoiceDetailScreen(
              invoiceId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/quotes/:id/invoices',
        builder: (context, state) => QuoteInvoicesScreen(
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
