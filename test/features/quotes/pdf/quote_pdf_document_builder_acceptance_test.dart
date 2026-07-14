import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/models/client_address.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_document_builder.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_formatter.dart';

import '../quotes_test_helpers.dart';

void main() {
  group('QuotePdfDocumentBuilder acceptance integration', () {
    Quote buildQuote({
      QuoteStatus status = QuoteStatus.sent,
      QuoteClientSnapshot? clientSnapshot,
      QuoteCompanySnapshot? companySnapshot,
      DateTime? approvedAt,
      String? internalNotes,
    }) {
      return sampleQuoteDraft(
        status: status,
        companySnapshot: companySnapshot ?? sampleCompanySnapshot(),
      ).copyWith(
        number: 'ORC-2026-0001',
        clientSnapshot: clientSnapshot ??
            QuoteClientSnapshot.fromClient(
              Client(
                id: 'client-pf',
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
        internalNotes: internalNotes ?? 'Nota interna sigilosa',
        approvedAt: approvedAt,
        subtotalCents: 300_000,
        discountCents: 0,
        freightCents: 0,
        totalCents: 300_000,
      );
    }

    QuotePdfBuildSuccess buildSuccess(Quote quote) {
      final result = QuotePdfDocumentBuilder.build(quote);
      expect(result, isA<QuotePdfBuildSuccess>());
      return result as QuotePdfBuildSuccess;
    }

    test('Enviado PF monta acceptanceSection com contratante identificado', () {
      final data = buildSuccess(buildQuote()).data;

      expect(data.acceptanceSection, isNotNull);
      expect(data.acceptanceSection!.contractorBlock.identificationLines, [
        'Maria Silva',
        'CPF 529.982.247-25',
      ]);
      expect(data.acceptanceSection!.approvedAtLabel, isNull);
    });

    test('Enviado PJ usa razão social e CNPJ do snapshot', () {
      final client = QuoteClientSnapshot.fromClient(
        Client(
          id: 'client-pj',
          createdAt: DateTime(2026, 1, 1),
          type: ClientType.company,
          name: 'Festas Premium Eventos LTDA',
          tradeName: 'Festas Premium',
          document: '11222333000181',
          phone: '67999990000',
        ),
      );

      final data = buildSuccess(
        buildQuote(clientSnapshot: client),
      ).data;

      expect(data.acceptanceSection!.contractorBlock.identificationLines, [
        'Festas Premium Eventos LTDA',
        'CNPJ 11.222.333/0001-81',
      ]);
      expect(data.acceptanceSection!.approvedAtLabel, isNull);
    });

    test('Enviado ignora approvedAt mesmo quando preenchido', () {
      final data = buildSuccess(
        buildQuote(
          approvedAt: DateTime(2026, 7, 13, 14, 30),
        ),
      ).data;

      expect(data.acceptanceSection, isNotNull);
      expect(data.acceptanceSection!.approvedAtLabel, isNull);
    });

    test('Aprovado com approvedAt inclui linha operacional', () {
      final data = buildSuccess(
        buildQuote(
          status: QuoteStatus.approved,
          approvedAt: DateTime(2026, 7, 13, 14, 30),
        ),
      ).data;

      expect(data.acceptanceSection, isNotNull);
      expect(
        data.acceptanceSection!.approvedAtLabel,
        'Aprovado no sistema em: 13 de julho de 2026 às 14:30',
      );
    });

    test('Aprovado sem approvedAt omite linha operacional', () {
      final data = buildSuccess(
        buildQuote(status: QuoteStatus.approved).copyWith(
          clearApprovedAt: true,
        ),
      ).data;

      expect(data.acceptanceSection, isNotNull);
      expect(data.acceptanceSection!.approvedAtLabel, isNull);
    });

    test('empresa com representante legal monta bloco da contratada', () {
      final data = buildSuccess(buildQuote()).data;
      final acceptance = data.acceptanceSection!;

      expect(acceptance.contracteeBlock.roleLabel, 'Contratada');
      expect(acceptance.contracteeBlock.identificationLines, [
        'Marcelo PP',
        'CPF 529.982.247-25',
        'Marcelo PP Festas LTDA',
        'CNPJ 11.222.333/0001-81',
      ]);
    });

    test('empresa sem representante usa rótulo Representante da contratada', () {
      final company = QuoteCompanySnapshot(
        identification: const QuoteCompanyIdentification(
          tradeName: 'DJ Marcelo PP',
          legalName: 'Marcelo PP Festas LTDA',
          cnpjDigits: '11222333000181',
        ),
        contact: const QuoteCompanyContact(),
        address: const QuoteCompanyAddress(),
        captureStatus: QuoteCompanyCaptureStatus.configured,
        capturedAt: DateTime(2026, 7, 13),
      );

      final data = buildSuccess(
        buildQuote(companySnapshot: company),
      ).data;

      expect(
        data.acceptanceSection!.contracteeBlock.roleLabel,
        'Representante da contratada',
      );
      expect(data.acceptanceSection!.contracteeBlock.identificationLines, [
        'Marcelo PP Festas LTDA',
        'CNPJ 11.222.333/0001-81',
      ]);
    });

    test('representante parcial omite campos ausentes', () {
      final company = QuoteCompanySnapshot(
        identification: const QuoteCompanyIdentification(
          tradeName: 'DJ Marcelo PP',
          legalName: 'Marcelo PP Festas LTDA',
          cnpjDigits: '11222333000181',
        ),
        contact: const QuoteCompanyContact(),
        address: const QuoteCompanyAddress(),
        legalRepresentative: const QuoteCompanyLegalRepresentative(
          fullName: 'Marcelo PP',
          role: 'Procurador',
        ),
        captureStatus: QuoteCompanyCaptureStatus.configured,
        capturedAt: DateTime(2026, 7, 13),
      );

      final data = buildSuccess(
        buildQuote(companySnapshot: company),
      ).data;

      expect(data.acceptanceSection!.contracteeBlock.identificationLines, [
        'Marcelo PP',
        'Procurador',
        'Marcelo PP Festas LTDA',
        'CNPJ 11.222.333/0001-81',
      ]);
    });

    test('documentos ausentes omitem linhas de CPF e CNPJ', () {
      final client = const QuoteClientSnapshot(
        type: QuoteClientType.individual,
        displayName: 'Maria Silva',
      );
      final company = QuoteCompanySnapshot(
        identification: const QuoteCompanyIdentification(
          tradeName: 'DJ Marcelo PP',
          legalName: 'Marcelo PP Festas LTDA',
        ),
        contact: const QuoteCompanyContact(),
        address: const QuoteCompanyAddress(),
        captureStatus: QuoteCompanyCaptureStatus.configured,
        capturedAt: DateTime(2026, 7, 13),
      );

      final data = buildSuccess(
        buildQuote(
          clientSnapshot: client,
          companySnapshot: company,
        ),
      ).data;

      expect(
        data.acceptanceSection!.contractorBlock.identificationLines,
        ['Maria Silva'],
      );
      expect(
        data.acceptanceSection!.contracteeBlock.identificationLines,
        ['Marcelo PP Festas LTDA'],
      );
    });

    test('Rascunho, Recusado e Cancelado não montam acceptanceSection', () {
      for (final status in [
        QuoteStatus.draft,
        QuoteStatus.rejected,
        QuoteStatus.cancelled,
      ]) {
        final data = buildSuccess(buildQuote(status: status)).data;
        expect(data.acceptanceSection, isNull, reason: status.name);
      }
    });

    test('internalNotes não aparece no document data nem na seção de aceite', () {
      final data = buildSuccess(
        buildQuote(internalNotes: 'Segredo interno do time'),
      ).data;
      final acceptance = data.acceptanceSection!;

      expect(data.proposalNotes, isNull);
      expect(acceptance.declarationText, isNot(contains('Segredo interno')));
      expect(acceptance.disclaimerText, isNot(contains('Segredo interno')));
    });

    test('local e data permanecem em branco no template fixo', () {
      final acceptance = buildSuccess(buildQuote()).data.acceptanceSection!;

      expect(
        acceptance.localAndDateLine,
        QuotePdfFormatter.acceptanceLocalAndDateLine,
      );
      expect(acceptance.localAndDateLine, contains('__________________________________________'));
      expect(acceptance.localAndDateLine.toLowerCase(), isNot(contains('campo grande')));
    });

    test('seção de aceite não inclui telefone, endereço ou PIX do cliente', () {
      final acceptance = buildSuccess(buildQuote()).data.acceptanceSection!;
      final joined = [
        acceptance.declarationText,
        acceptance.localAndDateLine,
        acceptance.disclaimerText,
        ...acceptance.contractorBlock.identificationLines,
        ...acceptance.contracteeBlock.identificationLines,
        if (acceptance.approvedAtLabel != null) acceptance.approvedAtLabel!,
      ].join(' ');

      expect(joined, isNot(contains('67999998888')));
      expect(joined, isNot(contains('maria@example.com')));
      expect(joined, isNot(contains('Rua das Flores')));
      expect(joined, isNot(contains('pix@')));
    });

    test('isolamento: mesmo Quote produz mesmo acceptanceSection', () {
      final quote = buildQuote(
        status: QuoteStatus.approved,
        approvedAt: DateTime(2026, 7, 13, 14, 30),
      );

      final first = buildSuccess(quote).data.acceptanceSection;
      final second = buildSuccess(quote).data.acceptanceSection;

      expect(first!.approvedAtLabel, second!.approvedAtLabel);
      expect(
        first.contractorBlock.identificationLines,
        second.contractorBlock.identificationLines,
      );
      expect(
        first.contracteeBlock.identificationLines,
        second.contracteeBlock.identificationLines,
      );
    });

    test('isolamento: alterações externas não alteram document data do Quote congelado', () {
      final frozenQuote = buildQuote(status: QuoteStatus.sent);
      final baseline = buildSuccess(frozenQuote).data;

      final alteredClient = QuoteClientSnapshot.fromClient(
        Client(
          id: 'other-client',
          createdAt: DateTime(2026, 1, 1),
          type: ClientType.individual,
          name: 'Outro Cliente Qualquer',
          document: '11144477735',
        ),
      );

      expect(alteredClient.displayName, isNot(frozenQuote.clientSnapshot.displayName));

      final rebuilt = buildSuccess(frozenQuote).data;

      expect(rebuilt.quoteNumber, baseline.quoteNumber);
      expect(rebuilt.proposalDateLabel, baseline.proposalDateLabel);
      expect(rebuilt.company.tradeName, baseline.company.tradeName);
      expect(rebuilt.client.name, baseline.client.name);
      expect(
        rebuilt.acceptanceSection!.contractorBlock.identificationLines,
        baseline.acceptanceSection!.contractorBlock.identificationLines,
      );
    });

    test('regressão: campos existentes da TASK-020 permanecem inalterados', () {
      final data = buildSuccess(buildQuote()).data;

      expect(data.quoteNumber, 'ORC-2026-0001');
      expect(data.statusLabel, 'Enviado');
      expect(data.company.tradeName, 'DJ Marcelo PP');
      expect(data.company.cnpj, '11.222.333/0001-81');
      expect(data.client.name, 'Maria Silva');
      expect(data.lines, hasLength(1));
      expect(data.financial.totalLabel, 'R\$ 3.000,00');
      expect(data.footerProposalDateLabel, isNotEmpty);
    });
  });
}
