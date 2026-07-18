import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/quotes/data/mappers/quote_mapper.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_line_item.dart';
import 'package:eventpro/features/quotes/models/quote_package_component_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_pix_key_type.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:flutter_test/flutter_test.dart';

Quote _buildQuote({
  List<QuoteLineItem>? items,
  QuoteCompanySnapshot? companySnapshot,
  DateTime? validUntil,
  DateTime? approvedAt,
}) {
  return Quote(
    id: 'quote-1',
    number: 'IGNORED',
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
    items:
        items ??
        [
          QuoteLineItem(
            catalogItemId: 'item-1',
            name: 'Caixa de som',
            unit: 'Unidade',
            quantity: 2,
            unitPriceCents: 15000,
            lineTotalCents: 30000,
          ),
        ],
    subtotalCents: 30000,
    discountCents: 0,
    freightCents: 0,
    totalCents: 30000,
    statusHistory: [
      QuoteStatusHistoryEntry(
        previousStatus: null,
        newStatus: QuoteStatus.draft,
        changedAt: DateTime(2026, 7, 13, 10, 0),
      ),
    ],
    validUntil: validUntil,
    notes: 'Nota pública',
    internalNotes: 'Nota interna',
    companySnapshot: companySnapshot,
    createdAt: DateTime(2026, 7, 13, 10, 0),
    updatedAt: DateTime(2026, 7, 13, 10, 0),
    approvedAt: approvedAt,
  );
}

QuoteCompanySnapshot _fullCompanySnapshot() {
  return QuoteCompanySnapshot(
    identification: const QuoteCompanyIdentification(
      tradeName: 'DJ Marcelo PP',
      legalName: 'Marcelo PP Festas LTDA',
      cnpjDigits: '11222333000181',
      stateRegistration: '123456',
    ),
    contact: const QuoteCompanyContact(
      phoneDigits: '67999990000',
      whatsAppDigits: '67988887777',
      email: 'contato@djmarcelo.com',
      instagram: '@djmarcelo',
      website: 'djmarcelo.com',
    ),
    address: const QuoteCompanyAddress(
      postalCode: '79002010',
      street: 'Rua Example',
      number: '100',
      complement: 'Sala 1',
      neighborhood: 'Centro',
      city: 'Campo Grande',
      state: 'MS',
    ),
    legalRepresentative: const QuoteCompanyLegalRepresentative(
      fullName: 'Marcelo PP',
      cpfDigits: '52998224725',
      role: 'Sócio',
    ),
    payment: const QuoteCompanyPayment(
      pixKeyType: QuotePixKeyType.email,
      pixKey: 'pix@djmarcelo.com',
      beneficiaryName: 'DJ Marcelo PP',
      paymentTerms: '50% na assinatura',
    ),
    logoReference: 'quotes/company-assets/logo.png',
    captureStatus: QuoteCompanyCaptureStatus.configured,
    capturedAt: DateTime(2026, 7, 13, 9, 0),
  );
}

void main() {
  group('QuoteMapper', () {
    test('toQuoteCompanion converte campos escalares e datas civis', () {
      final quote = _buildQuote(validUntil: DateTime(2026, 8, 1));

      final companion = QuoteMapper.toQuoteCompanion(quote);

      expect(companion.id.value, 'quote-1');
      expect(companion.status.value, 'draft');
      expect(companion.subtotalCents.value, 30000);
      expect(companion.validUntil.value, '2026-08-01');
      expect(companion.notes.value, 'Nota pública');
      expect(companion.internalNotes.value, 'Nota interna');
      expect(companion.approvedAt.value, isNull);
    });

    test('toQuoteCompanion converte approvedAt quando presente', () {
      final quote = _buildQuote(approvedAt: DateTime(2026, 7, 14, 8, 0));
      final companion = QuoteMapper.toQuoteCompanion(quote);

      expect(
        companion.approvedAt.value,
        DateTime(2026, 7, 14, 8, 0).toUtc().millisecondsSinceEpoch,
      );
    });

    test('toClientSnapshotCompanion converte campos do cliente', () {
      final companion = QuoteMapper.toClientSnapshotCompanion(_buildQuote());

      expect(companion.quoteId.value, 'quote-1');
      expect(companion.sourceClientId.value, 'client-1');
      expect(companion.type.value, 'individual');
      expect(companion.displayName.value, 'Maria Silva');
      expect(companion.phoneDigits.value, '67999998888');
    });

    test('toEventSnapshotCompanion converte campos do evento', () {
      final companion = QuoteMapper.toEventSnapshotCompanion(_buildQuote());

      expect(companion.quoteId.value, 'quote-1');
      expect(companion.name.value, 'Casamento');
      expect(companion.guestCount.value, 100);
      expect(companion.eventDate.value, isNull);
    });

    test('toCompanySnapshotCompanion retorna null quando snapshot é null', () {
      expect(QuoteMapper.toCompanySnapshotCompanion(_buildQuote()), isNull);
    });

    test(
      'toCompanySnapshotCompanion converte snapshot completo com representante e pagamento',
      () {
        final quote = _buildQuote(companySnapshot: _fullCompanySnapshot());
        final companion = QuoteMapper.toCompanySnapshotCompanion(quote)!;

        expect(companion.quoteId.value, 'quote-1');
        expect(companion.identTradeName.value, 'DJ Marcelo PP');
        expect(companion.identCnpjDigits.value, '11222333000181');
        expect(companion.contactEmail.value, 'contato@djmarcelo.com');
        expect(companion.addrCity.value, 'Campo Grande');
        expect(companion.repFullName.value, 'Marcelo PP');
        expect(companion.repCpfDigits.value, '52998224725');
        expect(companion.payPixKeyType.value, 'email');
        expect(companion.payPixKey.value, 'pix@djmarcelo.com');
        expect(companion.captureStatus.value, 'configured');
      },
    );

    test('generateLineItemIds gera a quantidade solicitada de ids únicos', () {
      final ids = QuoteMapper.generateLineItemIds(3);

      expect(ids, hasLength(3));
      expect(ids.toSet(), hasLength(3));
    });

    test('toLineItemCompanions preserva sortOrder e vincula aos ids gerados', () {
      final quote = _buildQuote(
        items: [
          QuoteLineItem(
            name: 'Item A',
            unit: 'un',
            quantity: 1,
            unitPriceCents: 1000,
            lineTotalCents: 1000,
          ),
          QuoteLineItem(
            name: 'Item B',
            unit: 'un',
            quantity: 2,
            unitPriceCents: 2000,
            lineTotalCents: 4000,
          ),
        ],
      );
      final ids = QuoteMapper.generateLineItemIds(quote.items.length);

      final companions = QuoteMapper.toLineItemCompanions(quote, ids);

      expect(companions, hasLength(2));
      expect(companions[0].id.value, ids[0]);
      expect(companions[0].sortOrder.value, 0);
      expect(companions[0].name.value, 'Item A');
      expect(companions[1].id.value, ids[1]);
      expect(companions[1].sortOrder.value, 1);
      expect(companions[1].name.value, 'Item B');
    });

    test(
      'toPackageComponentCompanions só gera linhas para itens de pacote e vincula lineItemId correto',
      () {
        final quote = _buildQuote(
          items: [
            QuoteLineItem(
              name: 'Item simples',
              unit: 'un',
              quantity: 1,
              unitPriceCents: 1000,
              lineTotalCents: 1000,
            ),
            QuoteLineItem(
              name: 'Pacote',
              unit: 'pacote',
              quantity: 1,
              unitPriceCents: 5000,
              lineTotalCents: 5000,
              packageComponents: const [
                QuotePackageComponentSnapshot(
                  catalogItemId: 'component-1',
                  name: 'Caixa',
                  unit: 'un',
                  typeLabel: 'Equipamento',
                  categoryLabel: 'Som',
                  quantityPerPackage: 2,
                ),
              ],
            ),
          ],
        );
        final ids = QuoteMapper.generateLineItemIds(quote.items.length);

        final componentCompanions = QuoteMapper.toPackageComponentCompanions(
          quote,
          ids,
        );

        expect(componentCompanions, hasLength(1));
        expect(componentCompanions.single.lineItemId.value, ids[1]);
        expect(componentCompanions.single.catalogItemId.value, 'component-1');
        expect(componentCompanions.single.quantityPerPackage.value, 2);
      },
    );

    test('toStatusHistoryCompanions preserva sortOrder e transições', () {
      final quote = _buildQuote().copyWith(
        statusHistory: [
          QuoteStatusHistoryEntry(
            previousStatus: null,
            newStatus: QuoteStatus.draft,
            changedAt: DateTime(2026, 7, 13),
          ),
          QuoteStatusHistoryEntry(
            previousStatus: QuoteStatus.draft,
            newStatus: QuoteStatus.sent,
            changedAt: DateTime(2026, 7, 14),
          ),
        ],
      );

      final companions = QuoteMapper.toStatusHistoryCompanions(quote);

      expect(companions, hasLength(2));
      expect(companions[0].sortOrder.value, 0);
      expect(companions[0].previousStatus.value, isNull);
      expect(companions[0].newStatus.value, 'draft');
      expect(companions[1].sortOrder.value, 1);
      expect(companions[1].previousStatus.value, 'draft');
      expect(companions[1].newStatus.value, 'sent');
    });

    test('toDomain reconstrói orçamento completo sem companySnapshot', () {
      final quoteRow = QuoteRow(
        id: 'quote-2',
        number: 'ORC-2026-0001',
        status: 'sent',
        subtotalCents: 30000,
        discountCents: 1000,
        freightCents: 500,
        totalCents: 29500,
        validUntil: '2026-08-01',
        notes: 'Nota',
        internalNotes: 'Interna',
        createdAt: DateTime(2026, 7, 13).toUtc().millisecondsSinceEpoch,
        updatedAt: DateTime(2026, 7, 14).toUtc().millisecondsSinceEpoch,
        approvedAt: null,
      );
      final clientRow = QuoteClientSnapshotRow(
        quoteId: 'quote-2',
        sourceClientId: 'client-1',
        type: 'individual',
        displayName: 'Maria Silva',
      );
      final eventRow = QuoteEventSnapshotRow(quoteId: 'quote-2');
      final lineItemRow = QuoteLineItemRow(
        id: 'line-1',
        quoteId: 'quote-2',
        sortOrder: 0,
        name: 'Caixa de som',
        unit: 'Unidade',
        quantity: 2,
        unitPriceCents: 15000,
        lineTotalCents: 30000,
      );
      final historyRow = QuoteStatusHistoryRow(
        id: 'history-1',
        quoteId: 'quote-2',
        sortOrder: 0,
        previousStatus: 'draft',
        newStatus: 'sent',
        changedAt: DateTime(2026, 7, 14).toUtc().millisecondsSinceEpoch,
      );

      final quote = QuoteMapper.toDomain(
        quote: quoteRow,
        clientSnapshot: clientRow,
        eventSnapshot: eventRow,
        companySnapshot: null,
        lineItems: [lineItemRow],
        packageComponentsByLineItemId: const {},
        statusHistory: [historyRow],
      );

      expect(quote.id, 'quote-2');
      expect(quote.number, 'ORC-2026-0001');
      expect(quote.status, QuoteStatus.sent);
      expect(quote.companySnapshot, isNull);
      expect(quote.validUntil, DateTime(2026, 8, 1));
      expect(quote.items, hasLength(1));
      expect(quote.items.single.packageComponents, isNull);
      expect(quote.statusHistory.single.previousStatus, QuoteStatus.draft);
    });

    test(
      'toDomain reconstrói companySnapshot completo (representante e pagamento)',
      () {
        final quoteRow = QuoteRow(
          id: 'quote-3',
          number: 'ORC-2026-0002',
          status: 'draft',
          subtotalCents: 0,
          discountCents: 0,
          freightCents: 0,
          totalCents: 0,
          createdAt: DateTime(2026, 7, 13).toUtc().millisecondsSinceEpoch,
          updatedAt: DateTime(2026, 7, 13).toUtc().millisecondsSinceEpoch,
        );
        final clientRow = QuoteClientSnapshotRow(
          quoteId: 'quote-3',
          type: 'individual',
          displayName: 'Cliente',
        );
        final eventRow = QuoteEventSnapshotRow(quoteId: 'quote-3');
        final companyRow = QuoteCompanySnapshotRow(
          quoteId: 'quote-3',
          captureStatus: 'configured',
          capturedAt: DateTime(2026, 7, 13).toUtc().millisecondsSinceEpoch,
          identTradeName: 'DJ Marcelo PP',
          repFullName: 'Marcelo PP',
          repCpfDigits: '52998224725',
          payPixKeyType: 'email',
          payPixKey: 'pix@djmarcelo.com',
        );

        final quote = QuoteMapper.toDomain(
          quote: quoteRow,
          clientSnapshot: clientRow,
          eventSnapshot: eventRow,
          companySnapshot: companyRow,
          lineItems: const [],
          packageComponentsByLineItemId: const {},
          statusHistory: const [],
        );

        expect(quote.companySnapshot, isNotNull);
        expect(
          quote.companySnapshot!.legalRepresentative?.fullName,
          'Marcelo PP',
        );
        expect(
          quote.companySnapshot!.payment?.pixKeyType,
          QuotePixKeyType.email,
        );
      },
    );

    test(
      'toDomain trata legalRepresentative e payment como null quando todos os campos são nulos',
      () {
        final quoteRow = QuoteRow(
          id: 'quote-4',
          number: 'ORC-2026-0003',
          status: 'draft',
          subtotalCents: 0,
          discountCents: 0,
          freightCents: 0,
          totalCents: 0,
          createdAt: DateTime(2026, 7, 13).toUtc().millisecondsSinceEpoch,
          updatedAt: DateTime(2026, 7, 13).toUtc().millisecondsSinceEpoch,
        );
        final clientRow = QuoteClientSnapshotRow(
          quoteId: 'quote-4',
          type: 'individual',
          displayName: 'Cliente',
        );
        final eventRow = QuoteEventSnapshotRow(quoteId: 'quote-4');
        final companyRow = QuoteCompanySnapshotRow(
          quoteId: 'quote-4',
          captureStatus: 'incomplete',
          capturedAt: DateTime(2026, 7, 13).toUtc().millisecondsSinceEpoch,
          identTradeName: 'Empresa',
        );

        final quote = QuoteMapper.toDomain(
          quote: quoteRow,
          clientSnapshot: clientRow,
          eventSnapshot: eventRow,
          companySnapshot: companyRow,
          lineItems: const [],
          packageComponentsByLineItemId: const {},
          statusHistory: const [],
        );

        expect(quote.companySnapshot!.legalRepresentative, isNull);
        expect(quote.companySnapshot!.payment, isNull);
      },
    );

    test('toDomain agrupa componentes de pacote por linha corretamente', () {
      final quoteRow = QuoteRow(
        id: 'quote-5',
        number: 'ORC-2026-0004',
        status: 'draft',
        subtotalCents: 0,
        discountCents: 0,
        freightCents: 0,
        totalCents: 0,
        createdAt: DateTime(2026, 7, 13).toUtc().millisecondsSinceEpoch,
        updatedAt: DateTime(2026, 7, 13).toUtc().millisecondsSinceEpoch,
      );
      final clientRow = QuoteClientSnapshotRow(
        quoteId: 'quote-5',
        type: 'individual',
        displayName: 'Cliente',
      );
      final eventRow = QuoteEventSnapshotRow(quoteId: 'quote-5');
      final lineItemRow = QuoteLineItemRow(
        id: 'line-pkg',
        quoteId: 'quote-5',
        sortOrder: 0,
        name: 'Pacote',
        unit: 'pacote',
        quantity: 1,
        unitPriceCents: 5000,
        lineTotalCents: 5000,
      );
      final componentRow = QuoteLinePackageComponentRow(
        id: 'comp-1',
        lineItemId: 'line-pkg',
        sortOrder: 0,
        name: 'Caixa',
        unit: 'un',
        typeLabel: 'Equipamento',
        categoryLabel: 'Som',
        quantityPerPackage: 2,
      );

      final quote = QuoteMapper.toDomain(
        quote: quoteRow,
        clientSnapshot: clientRow,
        eventSnapshot: eventRow,
        companySnapshot: null,
        lineItems: [lineItemRow],
        packageComponentsByLineItemId: {'line-pkg': [componentRow]},
        statusHistory: const [],
      );

      expect(quote.items.single.isPackageLine, isTrue);
      expect(quote.items.single.packageComponents, hasLength(1));
      expect(
        quote.items.single.packageComponents!.single.catalogItemId,
        isNull,
      );
      expect(quote.items.single.packageComponents!.single.name, 'Caixa');
    });
  });
}
