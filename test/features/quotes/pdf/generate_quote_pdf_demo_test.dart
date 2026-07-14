import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/pdf/services/quote_pdf_generator_service.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_document_builder.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_formatter.dart';

import '../../../../tool/quote_pdf_demo_fixtures.dart';
import 'quote_pdf_test_helpers.dart';

void main() {
  group('Quote PDF demo fixture', () {
    test('mantém subtotal e total consistentes com as linhas', () {
      final quote = buildDemoQuote();
      final items = quote.items;

      final expectedSubtotal = computeDemoSubtotalCents(items);
      final expectedTotal = computeDemoTotalCents(
        subtotalCents: expectedSubtotal,
      );

      expect(expectedSubtotal, 1_830_000);
      expect(quote.subtotalCents, expectedSubtotal);
      expect(quote.totalCents, expectedTotal);
      expect(quote.totalCents, 1_826_000);

      final buildResult = QuotePdfDocumentBuilder.build(quote);
      expect(buildResult, isA<QuotePdfBuildSuccess>());

      final data = (buildResult as QuotePdfBuildSuccess).data;
      expect(data.financial.subtotalLabel, QuotePdfFormatter.formatMoney(1_830_000));
      expect(data.financial.discountLabel, QuotePdfFormatter.formatMoney(demoDiscountCents));
      expect(data.financial.freightLabel, QuotePdfFormatter.formatMoney(demoFreightCents));
      expect(data.financial.totalLabel, QuotePdfFormatter.formatMoney(1_826_000));
    });

    test('gera PDF de demonstração para revisão visual', () async {
      final fonts = await loadQuotePdfTestFonts();
      const generator = QuotePdfGeneratorService();
      final quote = buildDemoQuote();
      final logoBytes = await loadDemoLogoPngBytes();

      final buildResult = QuotePdfDocumentBuilder.build(quote);
      expect(buildResult, isA<QuotePdfBuildSuccess>());

      final bytes = await generator.generate(
        data: (buildResult as QuotePdfBuildSuccess).data,
        fonts: fonts,
        logoBytes: logoBytes,
      );

      expect(bytes, isNotEmpty);
      expect(hasPdfSignature(bytes), isTrue);
      expect(estimatePdfPageCount(bytes), greaterThan(1));
      expect(logoBytes.length, greaterThan(100));

      final output = File('build/quote_pdf_demo.pdf');
      await output.parent.create(recursive: true);
      await output.writeAsBytes(bytes, flush: true);

      expect(await output.exists(), isTrue);
      expect(await output.length(), greaterThan(1000));
    });
  });
}
