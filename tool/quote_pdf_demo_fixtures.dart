import 'dart:io';
import 'dart:typed_data';

import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/models/client_address.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_line_item.dart';
import 'package:eventpro/features/quotes/models/quote_pix_key_type.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';

const demoDiscountCents = 12_000;
const demoFreightCents = 8_000;

List<QuoteLineItem> buildDemoQuoteItems({int count = 30}) {
  return [
    for (var i = 1; i <= count; i++)
      QuoteLineItem(
        catalogItemId: 'item-$i',
        name: 'Serviço profissional $i',
        description:
            'Descrição detalhada do item $i com especificações técnicas, '
            'montagem, operação e observações para validar quebra de página.',
        unit: 'Unidade',
        quantity: i % 2 == 0 ? 2 : 1,
        unitPriceCents: 25_000 + (i * 1_000),
        lineTotalCents: (i % 2 == 0 ? 2 : 1) * (25_000 + (i * 1_000)),
      ),
  ];
}

int computeDemoSubtotalCents(List<QuoteLineItem> items) {
  return items.fold<int>(0, (sum, item) => sum + item.lineTotalCents);
}

int computeDemoTotalCents({
  required int subtotalCents,
  int discountCents = demoDiscountCents,
  int freightCents = demoFreightCents,
}) {
  return subtotalCents - discountCents + freightCents;
}

Quote buildDemoQuote({int itemCount = 30}) {
  final items = buildDemoQuoteItems(count: itemCount);
  final subtotalCents = computeDemoSubtotalCents(items);
  final totalCents = computeDemoTotalCents(subtotalCents: subtotalCents);

  return Quote(
    id: 'demo-quote',
    number: 'ORC-2026-0001',
    status: QuoteStatus.sent,
    clientSnapshot: QuoteClientSnapshot.fromClient(
      Client(
        id: 'client-demo',
        createdAt: DateTime(2026, 1, 1),
        type: ClientType.individual,
        name: 'Maria Silva',
        phone: '67999998888',
        whatsApp: '67999998888',
        email: 'maria@example.com',
        document: '52998224725',
        address: const ClientAddress(
          street: 'Rua das Flores',
          number: '100',
          city: 'Campo Grande',
          state: 'MS',
        ),
      ),
    ),
    eventSnapshot: QuoteEventSnapshot(
      name: 'Casamento Ana & João',
      type: 'Social',
      date: DateTime(2026, 9, 15),
      startTime: '18:00',
      endTime: '23:00',
      venueName: 'Espaço Garden',
      addressSummary: 'Rua das Flores, 100 • Campo Grande - MS',
      guestCount: 150,
    ),
    items: items,
    subtotalCents: subtotalCents,
    discountCents: demoDiscountCents,
    freightCents: demoFreightCents,
    totalCents: totalCents,
    statusHistory: [
      QuoteStatusHistoryEntry(
        previousStatus: null,
        newStatus: QuoteStatus.draft,
        changedAt: DateTime(2026, 7, 10),
      ),
      QuoteStatusHistoryEntry(
        previousStatus: QuoteStatus.draft,
        newStatus: QuoteStatus.sent,
        changedAt: DateTime(2026, 7, 13),
      ),
    ],
    companySnapshot: QuoteCompanySnapshot(
      identification: const QuoteCompanyIdentification(
        tradeName: 'DJ Marcelo PP',
        legalName: 'Marcelo PP Festas LTDA',
        cnpjDigits: '11222333000181',
        stateRegistration: '123456789',
      ),
      contact: const QuoteCompanyContact(
        phoneDigits: '67999990000',
        whatsAppDigits: '67999990000',
        email: 'contato@djmarcelo.com',
        website: 'https://djmarcelo.com',
        instagram: '@djmarcelopp',
      ),
      address: const QuoteCompanyAddress(
        street: 'Rua Example',
        number: '100',
        neighborhood: 'Centro',
        city: 'Campo Grande',
        state: 'MS',
        postalCode: '79002010',
      ),
      payment: const QuoteCompanyPayment(
        paymentTerms: '50% na reserva e 50% no dia do evento',
        pixKeyType: QuotePixKeyType.email,
        pixKey: 'pix@empresa.com',
        beneficiaryName: 'Marcelo PP Festas LTDA',
      ),
      captureStatus: QuoteCompanyCaptureStatus.configured,
      capturedAt: DateTime(2026, 7, 13),
    ),
    notes:
        'Proposta válida em Campo Grande — condição especial à disposição do cliente.',
    validUntil: DateTime(2026, 8, 1),
    createdAt: DateTime(2026, 7, 13),
    updatedAt: DateTime(2026, 7, 13),
  );
}

Future<Uint8List> loadDemoLogoPngBytes({
  String fixturePath = 'test/fixtures/demo_logo.png',
}) async {
  return File(fixturePath).readAsBytes();
}
