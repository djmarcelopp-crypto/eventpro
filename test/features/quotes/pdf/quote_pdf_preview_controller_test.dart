import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/pdf/models/quote_pdf_export_result.dart';
import 'package:eventpro/features/quotes/pdf/models/quote_pdf_preview_state.dart';
import 'package:eventpro/features/quotes/pdf/providers/quote_pdf_preview_controller.dart';
import 'package:eventpro/features/quotes/pdf/providers/quote_pdf_providers.dart';
import 'package:eventpro/features/quotes/pdf/theme/quote_pdf_fonts.dart';
import 'package:eventpro/features/quotes/providers/quote_clock_provider.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';

import '../fakes/quote_repository_test_overrides.dart';
import '../quotes_test_helpers.dart';
import 'fakes/fake_quote_pdf_export_service.dart';
import 'fakes/fake_quote_pdf_generator.dart';
import 'fakes/fake_quote_pdf_logo_loader_service.dart';
import 'quote_pdf_test_helpers.dart';

void main() {
  group('QuotePdfPreviewController', () {
    late FakeQuotePdfGenerator fakeGenerator;
    late FakeQuotePdfExportService fakeExport;
    late FakeQuotePdfLogoLoaderService fakeLogoLoader;
    late QuotePdfFonts fonts;

    setUpAll(() async {
      fonts = await loadQuotePdfTestFonts();
    });

    setUp(() {
      fakeGenerator = FakeQuotePdfGenerator();
      fakeExport = FakeQuotePdfExportService();
      fakeLogoLoader = FakeQuotePdfLogoLoaderService();
    });

    Future<ProviderContainer> createContainer({
      List<Override> extraOverrides = const [],
      Quote? seededQuote,
    }) async {
      final container = ProviderContainer(
        overrides: [
          quoteClockProvider.overrideWithValue(() => DateTime(2026, 7, 13)),
          quotePdfFontsProvider.overrideWith((ref) async => fonts),
          quotePdfGeneratorProvider.overrideWithValue(fakeGenerator),
          quotePdfLogoLoaderProvider.overrideWithValue(fakeLogoLoader),
          quotePdfExportServiceProvider.overrideWithValue(fakeExport),
          ...quoteRepositoryOverrides(),
          ...extraOverrides,
        ],
      );

      if (seededQuote != null) {
        await container.read(quotesProvider.notifier).addQuote(seededQuote);
      }

      return container;
    }

    Quote eligibleQuote({String id = 'quote-pdf-1'}) {
      return buildRichQuoteAddDraft(id: id).copyWith(
        companySnapshot: sampleCompanySnapshot(),
        number: 'ORC-2026-0001',
        subtotalCents: 300_000,
        totalCents: 295_000,
      );
    }

    Future<QuotePdfPreviewState> waitForTerminalState(
      ProviderContainer container,
      String quoteId,
    ) async {
      final subscription = container.listen(
        quotePdfPreviewControllerProvider(quoteId),
        (_, _) {},
      );
      addTearDown(subscription.close);

      container.read(quotePdfPreviewControllerProvider(quoteId));

      for (var attempt = 0; attempt < 100; attempt++) {
        final current = container.read(
          quotePdfPreviewControllerProvider(quoteId),
        );
        if (current is! QuotePdfPreviewLoading) {
          return current;
        }

        await Future<void>.delayed(const Duration(milliseconds: 5));
      }

      return container.read(quotePdfPreviewControllerProvider(quoteId));
    }

    test('gera bytes uma vez e entra em estado pronto', () async {
      final container = await createContainer(seededQuote: eligibleQuote());
      addTearDown(container.dispose);

      final state = await waitForTerminalState(container, 'quote-pdf-1');

      expect(state, isA<QuotePdfPreviewReady>());
      expect(
        container.read(quotePdfPreviewControllerProvider('quote-pdf-1').notifier)
            .generationCount,
        1,
      );
      expect(fakeGenerator.generateCallCount, 1);
      expect((state as QuotePdfPreviewReady).filename,
          'orcamento_ORC-2026-0001.pdf');
    });

    test('não regenera bytes em nova leitura do provider', () async {
      final container = await createContainer(seededQuote: eligibleQuote());
      addTearDown(container.dispose);

      final subscription = container.listen(
        quotePdfPreviewControllerProvider('quote-pdf-1'),
        (_, _) {},
      );
      addTearDown(subscription.close);

      await waitForTerminalState(container, 'quote-pdf-1');
      container.read(quotePdfPreviewControllerProvider('quote-pdf-1'));
      container.read(quotePdfPreviewControllerProvider('quote-pdf-1'));

      expect(fakeGenerator.generateCallCount, 1);
    });

    test('retorna não encontrado para orçamento inexistente', () async {
      final container = await createContainer();
      addTearDown(container.dispose);

      final state = await waitForTerminalState(container, 'missing-quote');

      expect(state, isA<QuotePdfPreviewNotFound>());
      expect(fakeGenerator.generateCallCount, 0);
    });

    test('bloqueia quando companySnapshot é nulo', () async {
      final quote = buildRichQuoteAddDraft(id: 'quote-blocked');
      final container = await createContainer(seededQuote: quote);
      addTearDown(container.dispose);

      final state = await waitForTerminalState(container, 'quote-blocked');

      expect(state, isA<QuotePdfPreviewBlocked>());
      expect(
        (state as QuotePdfPreviewBlocked).message,
        contains('dados congelados'),
      );
      expect(fakeGenerator.generateCallCount, 0);
    });

    test('entra em erro quando geração falha', () async {
      fakeGenerator.error = StateError('generation failed');
      final container = await createContainer(seededQuote: eligibleQuote());
      addTearDown(container.dispose);

      final state = await waitForTerminalState(container, 'quote-pdf-1');

      expect(state, isA<QuotePdfPreviewError>());
    });

    test('exporta com sucesso reutilizando os mesmos bytes', () async {
      final container = await createContainer(seededQuote: eligibleQuote());
      addTearDown(container.dispose);

      final ready = await waitForTerminalState(container, 'quote-pdf-1')
          as QuotePdfPreviewReady;
      final notifier = container.read(
        quotePdfPreviewControllerProvider('quote-pdf-1').notifier,
      );

      final result = await notifier.exportPdf();

      expect(result, isA<QuotePdfExportSuccess>());
      expect(fakeExport.exportCallCount, 1);
      expect(fakeExport.lastBytes, same(ready.bytes));
      expect(fakeExport.lastFilename, ready.filename);
      expect(fakeGenerator.generateCallCount, 1);
    });

    test('cancelamento de exportação é silencioso', () async {
      fakeExport.nextResult = const QuotePdfExportCancelled();
      final container = await createContainer(seededQuote: eligibleQuote());
      addTearDown(container.dispose);

      await waitForTerminalState(container, 'quote-pdf-1');
      final result = await container
          .read(quotePdfPreviewControllerProvider('quote-pdf-1').notifier)
          .exportPdf();

      expect(result, isA<QuotePdfExportCancelled>());
    });

    test('falha de exportação retorna resultado de erro', () async {
      fakeExport.nextResult = const QuotePdfExportFailed();
      final container = await createContainer(seededQuote: eligibleQuote());
      addTearDown(container.dispose);

      await waitForTerminalState(container, 'quote-pdf-1');
      final result = await container
          .read(quotePdfPreviewControllerProvider('quote-pdf-1').notifier)
          .exportPdf();

      expect(result, isA<QuotePdfExportFailed>());
    });
  });
}
