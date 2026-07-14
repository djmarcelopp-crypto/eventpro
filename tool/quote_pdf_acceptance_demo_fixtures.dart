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

const acceptanceDemoDiscountCents = 10_000;
const acceptanceDemoFreightCents = 5_000;

const _demoCompanyTradeName = 'Estúdio Aurora Demo';
const _demoCompanyLegalName = 'Aurora Eventos de Demonstração LTDA';
const _demoCompanyCnpj = '11222333000181';
const _demoRepresentativeName = 'Carlos Demonstração';
const _demoRepresentativeCpf = '39053344705';
const _demoRepresentativeRole = 'Representante legal';

const _longCompanyLegalName =
    'Associação Beneficente de Eventos e Festas do Centro-Oeste Demonstração LTDA';
const _longRepresentativeName =
    'Dr. Carlos Eduardo de Souza Pereira Demonstração';

List<QuoteLineItem> buildAcceptanceDemoItems({int count = 4}) {
  return [
    for (var i = 1; i <= count; i++)
      QuoteLineItem(
        catalogItemId: 'demo-item-$i',
        name: 'Item demonstrativo $i',
        description: count > 4
            ? 'Descrição extensa do item $i com especificações técnicas, '
                'montagem, operação e observações para validar quebra de página.'
            : 'Descrição resumida do item $i para revisão visual.',
        unit: 'Unidade',
        quantity: i % 2 == 0 ? 2 : 1,
        unitPriceCents: 20_000 + (i * 500),
        lineTotalCents: (i % 2 == 0 ? 2 : 1) * (20_000 + (i * 500)),
      ),
  ];
}

int computeAcceptanceDemoSubtotal(List<QuoteLineItem> items) {
  return items.fold<int>(0, (sum, item) => sum + item.lineTotalCents);
}

QuoteCompanySnapshot buildAcceptanceDemoCompanySnapshot({
  bool withRepresentative = true,
  bool longNames = false,
}) {
  return QuoteCompanySnapshot(
    identification: QuoteCompanyIdentification(
      tradeName: _demoCompanyTradeName,
      legalName: longNames ? _longCompanyLegalName : _demoCompanyLegalName,
      cnpjDigits: _demoCompanyCnpj,
    ),
    contact: const QuoteCompanyContact(
      phoneDigits: '11999990000',
      whatsAppDigits: '11988887777',
      email: 'contato@demo-ficticio.example',
      website: 'https://demo-ficticio.example',
    ),
    address: const QuoteCompanyAddress(
      street: 'Rua Fictícia',
      number: '100',
      neighborhood: 'Centro Demo',
      city: 'Cidade Exemplo',
      state: 'EX',
      postalCode: '00000000',
    ),
    payment: const QuoteCompanyPayment(
      paymentTerms: '50% na reserva e 50% no dia do evento',
      pixKeyType: QuotePixKeyType.email,
      pixKey: 'pix@demo-ficticio.example',
      beneficiaryName: 'Aurora Eventos de Demonstração LTDA',
    ),
    legalRepresentative: withRepresentative
        ? QuoteCompanyLegalRepresentative(
            fullName: longNames ? _longRepresentativeName : _demoRepresentativeName,
            cpfDigits: _demoRepresentativeCpf,
            role: _demoRepresentativeRole,
          )
        : null,
    captureStatus: QuoteCompanyCaptureStatus.configured,
    capturedAt: DateTime(2026, 7, 13, 10, 0),
  );
}

QuoteClientSnapshot buildAcceptanceDemoIndividualClient() {
  return QuoteClientSnapshot.fromClient(
    Client(
      id: 'demo-client-pf',
      createdAt: DateTime(2026, 1, 1),
      type: ClientType.individual,
      name: 'Ana Demonstração',
      phone: '11999998888',
      whatsApp: '11999998888',
      email: 'ana@demo-ficticio.example',
      document: '11144477735',
      address: const ClientAddress(
        street: 'Rua Fictícia',
        number: '200',
        city: 'Cidade Exemplo',
        state: 'EX',
      ),
    ),
  );
}

QuoteClientSnapshot buildAcceptanceDemoCompanyClient({bool longNames = false}) {
  return QuoteClientSnapshot.fromClient(
    Client(
      id: 'demo-client-pj',
      createdAt: DateTime(2026, 1, 1),
      type: ClientType.company,
      name: longNames
          ? 'Aurora Eventos de Demonstração LTDA'
          : 'Aurora Eventos de Demonstração LTDA',
      tradeName: 'Festas Aurora Demo',
      phone: '11977776666',
      email: 'pj@demo-ficticio.example',
      document: _demoCompanyCnpj,
      address: const ClientAddress(
        street: 'Avenida Exemplo',
        number: '500',
        city: 'Cidade Exemplo',
        state: 'EX',
      ),
    ),
  );
}

Quote _buildAcceptanceDemoQuote({
  required QuoteStatus status,
  required QuoteClientSnapshot clientSnapshot,
  required List<QuoteLineItem> items,
  DateTime? approvedAt,
  bool longCompanyNames = false,
}) {
  final subtotalCents = computeAcceptanceDemoSubtotal(items);
  final totalCents = subtotalCents -
      acceptanceDemoDiscountCents +
      acceptanceDemoFreightCents;

  return Quote(
    id: 'demo-acceptance-${status.name}',
    number: 'ORC-2026-DEMO',
    status: status,
    clientSnapshot: clientSnapshot,
    eventSnapshot: const QuoteEventSnapshot(
      name: 'Evento Demonstração',
      type: 'Corporativo',
      date: null,
      venueName: 'Salão Fictício',
      addressSummary: 'Rua Fictícia, 100 • Cidade Exemplo - EX',
      guestCount: 120,
    ),
    items: items,
    subtotalCents: subtotalCents,
    discountCents: acceptanceDemoDiscountCents,
    freightCents: acceptanceDemoFreightCents,
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
        changedAt: DateTime(2026, 7, 12),
      ),
      if (status == QuoteStatus.approved)
        QuoteStatusHistoryEntry(
          previousStatus: QuoteStatus.sent,
          newStatus: QuoteStatus.approved,
          changedAt: approvedAt ?? DateTime(2026, 7, 13, 14, 30),
        ),
    ],
    companySnapshot: buildAcceptanceDemoCompanySnapshot(
      longNames: longCompanyNames,
    ),
    notes:
        'Observações públicas de demonstração — condições especiais fictícias.',
    validUntil: DateTime(2026, 8, 1),
    createdAt: DateTime(2026, 7, 13),
    updatedAt: DateTime(2026, 7, 13),
    approvedAt: approvedAt,
  );
}

Quote buildAcceptanceSentDemoQuote() {
  return _buildAcceptanceDemoQuote(
    status: QuoteStatus.sent,
    clientSnapshot: buildAcceptanceDemoIndividualClient(),
    items: buildAcceptanceDemoItems(count: 4),
  );
}

Quote buildAcceptanceApprovedDemoQuote() {
  return _buildAcceptanceDemoQuote(
    status: QuoteStatus.approved,
    clientSnapshot: buildAcceptanceDemoCompanyClient(longNames: true),
    items: buildAcceptanceDemoItems(count: 4),
    approvedAt: DateTime(2026, 7, 13, 14, 30),
    longCompanyNames: true,
  );
}

Quote buildAcceptanceMultipageDemoQuote() {
  return _buildAcceptanceDemoQuote(
    status: QuoteStatus.sent,
    clientSnapshot: buildAcceptanceDemoIndividualClient(),
    items: buildAcceptanceDemoItems(count: 30),
  );
}
