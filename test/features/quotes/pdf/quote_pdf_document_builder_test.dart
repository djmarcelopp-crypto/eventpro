import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_pix_key_type.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_document_builder.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_eligibility.dart';

import '../quotes_test_helpers.dart';

void main() {
  group('QuotePdfDocumentBuilder', () {
    Quote buildRichQuote({
      QuoteStatus status = QuoteStatus.sent,
      bool withCompanySnapshot = true,
      String? notes,
      String? internalNotes,
      DateTime? createdAt,
    }) {
      final created = createdAt ?? DateTime(2026, 7, 13);
      return sampleQuoteDraft(
        id: 'quote-pdf',
        status: status,
        createdAt: created,
        companySnapshot:
            withCompanySnapshot ? sampleCompanySnapshot() : null,
      ).copyWith(
        number: 'ORC-2026-0001',
        notes: notes,
        internalNotes: internalNotes,
        validUntil: DateTime(2026, 7, 20),
        eventSnapshot: QuoteEventSnapshot(
          name: 'Casamento Ana',
          type: 'Social',
          date: DateTime(2026, 9, 15),
          startTime: '18:00',
          endTime: '23:00',
          venueName: 'Espaço Garden',
          addressSummary: 'Rua das Flores, 100 • Campo Grande - MS',
          guestCount: 150,
        ),
        subtotalCents: 300_000,
        discountCents: 10_000,
        freightCents: 5_000,
        totalCents: 295_000,
        approvedAt: null,
      );
    }

    test('bloqueia orçamento sem companySnapshot', () {
      final result = QuotePdfDocumentBuilder.build(
        buildRichQuote(withCompanySnapshot: false),
      );

      expect(result, isA<QuotePdfBuildBlocked>());
      expect(
        (result as QuotePdfBuildBlocked).message,
        QuotePdfEligibility.missingCompanySnapshotMessage,
      );
    });

    test('monta documento completo com snapshots congelados', () {
      final result = QuotePdfDocumentBuilder.build(buildRichQuote());

      expect(result, isA<QuotePdfBuildSuccess>());
      final data = (result as QuotePdfBuildSuccess).data;

      expect(data.quoteNumber, 'ORC-2026-0001');
      expect(data.proposalDateLabel, '13 de julho de 2026');
      expect(data.validityDateLabel, '20 de julho de 2026');
      expect(data.statusLabel, 'Enviado');
      expect(data.company.tradeName, 'DJ Marcelo PP');
      expect(data.company.cnpj, '11.222.333/0001-81');
      expect(data.client.name, 'Maria Silva');
      expect(data.event, isNotNull);
      expect(data.event!.name, 'Casamento Ana');
      expect(data.lines, hasLength(1));
      expect(data.lines.first.unit, 'un.');
      expect(data.financial.subtotalLabel, 'R\$ 3.000,00');
      expect(data.financial.discountLabel, 'R\$ 100,00');
      expect(data.financial.freightLabel, 'R\$ 50,00');
      expect(data.financial.totalLabel, 'R\$ 2.950,00');
      expect(data.footerProposalDateLabel, '13 de julho de 2026');
    });

    test('usa createdAt como data oficial da proposta', () {
      final result = QuotePdfDocumentBuilder.build(
        buildRichQuote(createdAt: DateTime(2025, 1, 5)),
      );

      final data = (result as QuotePdfBuildSuccess).data;
      expect(data.proposalDateLabel, '5 de janeiro de 2025');
      expect(data.footerProposalDateLabel, '5 de janeiro de 2025');
    });

    test('inclui observações da proposta e exclui internalNotes', () {
      final result = QuotePdfDocumentBuilder.build(
        buildRichQuote(
          notes: 'Pagamento em até 3 dias úteis.',
          internalNotes: 'Cliente pediu desconto extra.',
        ),
      );

      final data = (result as QuotePdfBuildSuccess).data;
      expect(data.proposalNotes, 'Pagamento em até 3 dias úteis.');
    });

    test('snapshot incompleto oculta campos vazios da empresa', () {
      final snapshot = QuoteCompanySnapshot(
        identification: const QuoteCompanyIdentification(
          tradeName: 'DJ Marcelo PP',
        ),
        contact: const QuoteCompanyContact(phoneDigits: '67999990000'),
        address: const QuoteCompanyAddress(),
        captureStatus: QuoteCompanyCaptureStatus.incomplete,
        capturedAt: DateTime(2026, 7, 13),
      );

      final result = QuotePdfDocumentBuilder.build(
        buildRichQuote().copyWith(companySnapshot: snapshot),
      );

      final company = (result as QuotePdfBuildSuccess).data.company;
      expect(company.legalName, isNull);
      expect(company.cnpj, isNull);
      expect(company.address, isNull);
      expect(company.contactLines, isNotEmpty);
    });

    test('omite desconto e frete quando zero', () {
      final quote = buildRichQuote().copyWith(
        discountCents: 0,
        freightCents: 0,
        totalCents: 300_000,
      );

      final result = QuotePdfDocumentBuilder.build(quote);
      final data = (result as QuotePdfBuildSuccess).data;

      expect(data.financial.discountLabel, isNull);
      expect(data.financial.freightLabel, isNull);
    });

    test('inclui pagamento com chave PIX completa', () {
      final snapshot = QuoteCompanySnapshot(
        identification: const QuoteCompanyIdentification(
          tradeName: 'DJ Marcelo PP',
        ),
        contact: const QuoteCompanyContact(),
        address: const QuoteCompanyAddress(),
        payment: const QuoteCompanyPayment(
          pixKeyType: QuotePixKeyType.email,
          pixKey: 'pix@empresa.com',
          beneficiaryName: 'Empresa LTDA',
          paymentTerms: '50% na reserva e 50% no dia do evento',
        ),
        captureStatus: QuoteCompanyCaptureStatus.configured,
        capturedAt: DateTime(2026, 7, 13),
      );

      final result = QuotePdfDocumentBuilder.build(
        buildRichQuote().copyWith(companySnapshot: snapshot),
      );

      final payment = (result as QuotePdfBuildSuccess).data.payment!;
      expect(payment.pixKey, 'pix@empresa.com');
      expect(payment.pixKeyTypeLabel, 'E-mail');
      expect(payment.beneficiaryName, 'Empresa LTDA');
      expect(payment.paymentTerms, contains('50%'));
    });

    test('omite seção de evento quando vazia', () {
      final quote = buildRichQuote().copyWith(
        eventSnapshot: QuoteEventSnapshot.empty,
      );

      final result = QuotePdfDocumentBuilder.build(quote);
      final data = (result as QuotePdfBuildSuccess).data;

      expect(data.event, isNull);
    });

    test('aplica overlay de rascunho no documento', () {
      final result = QuotePdfDocumentBuilder.build(
        buildRichQuote(status: QuoteStatus.draft),
      );

      final overlay = (result as QuotePdfBuildSuccess).data.statusOverlay;
      expect(overlay.watermarkText, 'RASCUNHO');
      expect(overlay.badgeText, isNull);
    });

    test('preserva textos acentuados no view model', () {
      final quote = buildRichQuote(
        notes: 'Proposta válida em São Paulo — condição especial.',
      ).copyWith(
        eventSnapshot: QuoteEventSnapshot(
          name: 'Ação beneficente',
          type: 'Corporativo',
        ),
      );

      final result = QuotePdfDocumentBuilder.build(quote);
      final data = (result as QuotePdfBuildSuccess).data;

      expect(data.proposalNotes, contains('São Paulo'));
      expect(data.event!.name, 'Ação beneficente');
    });
  });
}
