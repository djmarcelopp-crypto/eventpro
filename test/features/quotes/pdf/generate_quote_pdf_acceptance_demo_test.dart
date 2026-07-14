import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/pdf/services/quote_pdf_generator_service.dart';
import 'package:eventpro/features/quotes/pdf/theme/quote_pdf_fonts.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_document_builder.dart';

import '../../../../tool/quote_pdf_acceptance_demo_fixtures.dart';
import '../../../../tool/quote_pdf_demo_fixtures.dart';
import 'quote_pdf_test_helpers.dart';

void main() {
  group('Quote PDF acceptance demos', () {
    late QuotePdfFonts fonts;
    const generator = QuotePdfGeneratorService();

    setUpAll(() async {
      fonts = await loadQuotePdfTestFonts();
    });

    Future<void> writeDemoPdf({
      required String path,
      required Quote quote,
      int? expectedMinPages,
    }) async {
      final buildResult = QuotePdfDocumentBuilder.build(quote);
      expect(buildResult, isA<QuotePdfBuildSuccess>());

      final data = (buildResult as QuotePdfBuildSuccess).data;
      expect(data.acceptanceSection, isNotNull);

      final logoBytes = await loadDemoLogoPngBytes();
      final bytes = await generator.generate(
        data: data,
        fonts: fonts,
        logoBytes: logoBytes,
      );

      expect(bytes, isNotEmpty);
      expect(hasPdfSignature(bytes), isTrue);

      final pageCount = estimatePdfPageCount(bytes);
      if (expectedMinPages != null) {
        expect(pageCount, greaterThanOrEqualTo(expectedMinPages));
      }

      final output = File(path);
      await output.parent.create(recursive: true);
      await output.writeAsBytes(bytes, flush: true);

      expect(await output.exists(), isTrue);
      expect(await output.length(), greaterThan(1000));
    }

    test('gera demo Enviado PF com aceite', () async {
      await writeDemoPdf(
        path: 'build/quote_pdf_acceptance_sent.pdf',
        quote: buildAcceptanceSentDemoQuote(),
      );
    });

    test('gera demo Aprovado PJ com approvedAt e nomes longos', () async {
      final quote = buildAcceptanceApprovedDemoQuote();
      final data = (QuotePdfDocumentBuilder.build(quote) as QuotePdfBuildSuccess)
          .data;

      expect(data.acceptanceSection!.approvedAtLabel, isNotNull);
      expect(
        data.acceptanceSection!.contractorBlock.identificationLines.first,
        'Aurora Eventos de Demonstração LTDA',
      );

      await writeDemoPdf(
        path: 'build/quote_pdf_acceptance_approved.pdf',
        quote: quote,
      );
    });

    test('gera demo multipágina com aceite na última página', () async {
      await writeDemoPdf(
        path: 'build/quote_pdf_acceptance_multipage.pdf',
        quote: buildAcceptanceMultipageDemoQuote(),
        expectedMinPages: 2,
      );
    });

    test('demo anterior da TASK-020 continua funcionando', () async {
      final quote = buildDemoQuote();
      final buildResult = QuotePdfDocumentBuilder.build(quote);
      expect(buildResult, isA<QuotePdfBuildSuccess>());

      final bytes = await generator.generate(
        data: (buildResult as QuotePdfBuildSuccess).data,
        fonts: fonts,
        logoBytes: await loadDemoLogoPngBytes(),
      );

      expect(hasPdfSignature(bytes), isTrue);

      final output = File('build/quote_pdf_demo.pdf');
      await output.parent.create(recursive: true);
      await output.writeAsBytes(bytes, flush: true);

      expect(await output.exists(), isTrue);
      expect(await output.length(), greaterThan(1000));
    });
  });
}
