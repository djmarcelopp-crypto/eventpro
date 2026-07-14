import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_line_item.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/pdf/models/quote_pdf_document_data.dart';
import 'package:eventpro/features/quotes/pdf/services/quote_pdf_generator_service.dart';
import 'package:eventpro/features/quotes/pdf/theme/quote_pdf_fonts.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_document_builder.dart';

import '../quotes_test_helpers.dart';
import 'quote_pdf_test_helpers.dart';

void main() {
  group('QuotePdfGeneratorService acceptance rendering', () {
    late QuotePdfGeneratorService generator;
    late QuotePdfFonts fonts;

    setUpAll(() async {
      fonts = await loadQuotePdfTestFonts();
      generator = const QuotePdfGeneratorService();
    });

    Future<Uint8List> generateData(QuotePdfDocumentData data) {
      return generator.generate(data: data, fonts: fonts);
    }

    Future<Uint8List> generateQuote({
      QuoteStatus status = QuoteStatus.sent,
      QuoteClientSnapshot? clientSnapshot,
      QuoteCompanySnapshot? companySnapshot,
      DateTime? approvedAt,
      List<QuoteLineItem>? items,
      bool clearApprovedAt = false,
    }) async {
      final quote = sampleQuoteDraft(
        status: status,
        companySnapshot: companySnapshot ?? sampleCompanySnapshot(),
        items: items ?? [sampleLineItem()],
      ).copyWith(
        number: 'ORC-2026-0001',
        clientSnapshot: clientSnapshot,
        approvedAt: approvedAt,
        clearApprovedAt: clearApprovedAt,
        subtotalCents: 300_000,
        discountCents: 0,
        freightCents: 0,
        totalCents: 300_000,
      );

      final data = (QuotePdfDocumentBuilder.build(quote) as QuotePdfBuildSuccess)
          .data;
      return generateData(data);
    }

    test('gera PDF válido com aceite de Enviado', () async {
      final bytes = await generateQuote(status: QuoteStatus.sent);

      expect(bytes, isNotEmpty);
      expect(hasPdfSignature(bytes), isTrue);
    });

    test('gera PDF válido com aceite de Aprovado e approvedAt', () async {
      final bytes = await generateQuote(
        status: QuoteStatus.approved,
        approvedAt: DateTime(2026, 7, 13, 14, 30),
      );

      expect(bytes, isNotEmpty);
      expect(hasPdfSignature(bytes), isTrue);
    });

    test('gera PDF quando acceptanceSection é null', () async {
      final data = buildSamplePdfDocumentData(status: QuoteStatus.draft);

      expect(data.acceptanceSection, isNull);

      final bytes = await generateData(data);

      expect(bytes, isNotEmpty);
      expect(hasPdfSignature(bytes), isTrue);
    });

    test('gera multipágina com 30 itens e aceite sem exceção', () async {
      final quote = sampleQuoteDraft(
        status: QuoteStatus.sent,
        companySnapshot: sampleCompanySnapshot(),
        items: buildManyQuoteLineItems(count: 30),
      ).copyWith(
        subtotalCents: 3_000_000,
        totalCents: 3_000_000,
      );

      final data =
          (QuotePdfDocumentBuilder.build(quote) as QuotePdfBuildSuccess).data;
      expect(data.acceptanceSection, isNotNull);

      final bytes = await generateData(data);

      expect(hasPdfSignature(bytes), isTrue);
      expect(estimatePdfPageCount(bytes), greaterThan(1));
    });

    test('aceite com 30 itens permanece na última página do documento', () async {
      final withAcceptance = await generateQuote(
        status: QuoteStatus.sent,
        items: buildManyQuoteLineItems(count: 30),
      );
      final withoutAcceptance = await generateQuote(
        status: QuoteStatus.draft,
        items: buildManyQuoteLineItems(count: 30),
      );

      final pagesWith = estimatePdfPageCount(withAcceptance);
      final pagesWithout = estimatePdfPageCount(withoutAcceptance);

      expect(pagesWith, greaterThanOrEqualTo(pagesWithout));
      expect(pagesWith, greaterThan(1));
    });

    test('suporta nomes e razões sociais longos sem overflow', () async {
      const longName =
          'Associação Beneficente de Eventos e Festas do Centro-Oeste LTDA';
      const longRepresentative =
          'Dr. Marcelo de Oliveira Pires Pereira Junior';

      final company = QuoteCompanySnapshot(
        identification: const QuoteCompanyIdentification(
          tradeName: 'DJ Marcelo PP',
          legalName: longName,
          cnpjDigits: '11222333000181',
        ),
        contact: const QuoteCompanyContact(),
        address: const QuoteCompanyAddress(),
        legalRepresentative: const QuoteCompanyLegalRepresentative(
          fullName: longRepresentative,
          cpfDigits: '52998224725',
          role: 'Diretor presidente e responsável legal',
        ),
        captureStatus: QuoteCompanyCaptureStatus.configured,
        capturedAt: DateTime(2026, 7, 13),
      );

      final client = QuoteClientSnapshot.fromClient(
        Client(
          id: 'client-long',
          createdAt: DateTime(2026, 1, 1),
          type: ClientType.company,
          name: longName,
          tradeName: 'Festas Premium',
          document: '11222333000181',
        ),
      );

      final bytes = await generateQuote(
        clientSnapshot: client,
        companySnapshot: company,
      );

      expect(hasPdfSignature(bytes), isTrue);
    });

    test('gera com representante completo', () async {
      final bytes = await generateQuote();

      expect(hasPdfSignature(bytes), isTrue);
    });

    test('gera com representante parcial', () async {
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

      final bytes = await generateQuote(companySnapshot: company);

      expect(hasPdfSignature(bytes), isTrue);
    });

    test('gera sem representante legal', () async {
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

      final bytes = await generateQuote(companySnapshot: company);

      expect(hasPdfSignature(bytes), isTrue);
    });

    test('Aprovado sem approvedAt gera PDF com aceite', () async {
      final quote = sampleQuoteDraft(
        status: QuoteStatus.approved,
        companySnapshot: sampleCompanySnapshot(),
      ).copyWith(clearApprovedAt: true);

      final data =
          (QuotePdfDocumentBuilder.build(quote) as QuotePdfBuildSuccess).data;

      expect(data.acceptanceSection, isNotNull);
      expect(data.acceptanceSection!.approvedAtLabel, isNull);

      final bytes = await generateData(data);

      expect(hasPdfSignature(bytes), isTrue);
    });

    test('Rascunho, Recusado e Cancelado geram PDF sem aceite', () async {
      for (final status in [
        QuoteStatus.draft,
        QuoteStatus.rejected,
        QuoteStatus.cancelled,
      ]) {
        final data = buildSamplePdfDocumentData(status: status);
        expect(data.acceptanceSection, isNull);

        final bytes = await generateData(data);
        expect(hasPdfSignature(bytes), isTrue, reason: status.name);
      }
    });

    test('regressão: documento mínimo sem aceite mantém geração válida', () async {
      final draftBytes = await generateData(
        buildSamplePdfDocumentData(status: QuoteStatus.draft),
      );

      expect(estimatePdfPageCount(draftBytes), greaterThanOrEqualTo(1));
      expect(hasPdfSignature(draftBytes), isTrue);
    });
  });
}
