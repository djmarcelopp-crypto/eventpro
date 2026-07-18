import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/pdf/models/quote_pdf_export_result.dart';
import 'package:eventpro/features/quotes/pdf/providers/quote_pdf_detail_actions_controller.dart';
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
  group('QuotePdfDetailActionsController', () {
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

    Future<ProviderContainer> createContainer({required Quote quote}) async {
      final container = ProviderContainer(
        overrides: [
          quoteClockProvider.overrideWithValue(() => DateTime(2026, 7, 13)),
          quotePdfFontsProvider.overrideWith((ref) async => fonts),
          quotePdfGeneratorProvider.overrideWithValue(fakeGenerator),
          quotePdfLogoLoaderProvider.overrideWithValue(fakeLogoLoader),
          quotePdfExportServiceProvider.overrideWithValue(fakeExport),
          ...quoteRepositoryOverrides(),
        ],
      );
      await container.read(quotesProvider.notifier).addQuote(quote);
      return container;
    }

    Quote eligibleQuote({String id = 'quote-detail-pdf'}) {
      return buildRichQuoteAddDraft(id: id).copyWith(
        companySnapshot: sampleCompanySnapshot(),
        number: 'ORC-2026-0099',
        subtotalCents: 300_000,
        totalCents: 295_000,
      );
    }

    test('exporta gerando bytes uma única vez', () async {
      final container = await createContainer(quote: eligibleQuote());
      addTearDown(container.dispose);

      final subscription = container.listen(
        quotePdfDetailActionsControllerProvider('quote-detail-pdf'),
        (_, _) {},
      );
      addTearDown(subscription.close);

      final notifier = container.read(
        quotePdfDetailActionsControllerProvider('quote-detail-pdf').notifier,
      );

      final result = await notifier.exportDirect();

      expect(result, isA<QuotePdfExportSuccess>());
      expect(fakeGenerator.generateCallCount, 1);
      expect(fakeExport.exportCallCount, 1);
      expect(notifier.generationCount, 1);
    });

    test('reutiliza bytes na segunda exportação', () async {
      final container = await createContainer(quote: eligibleQuote());
      addTearDown(container.dispose);

      final subscription = container.listen(
        quotePdfDetailActionsControllerProvider('quote-detail-pdf'),
        (_, _) {},
      );
      addTearDown(subscription.close);

      final notifier = container.read(
        quotePdfDetailActionsControllerProvider('quote-detail-pdf').notifier,
      );

      await notifier.exportDirect();
      await notifier.exportDirect();

      expect(fakeGenerator.generateCallCount, 1);
      expect(fakeExport.exportCallCount, 2);
      expect(
        fakeExport.lastBytes,
        same(notifier.cachedReady?.bytes),
      );
    });

    test('clique duplo concorrente executa somente uma operação', () async {
      fakeGenerator.delay = const Duration(milliseconds: 100);
      final container = await createContainer(quote: eligibleQuote());
      addTearDown(container.dispose);

      final subscription = container.listen(
        quotePdfDetailActionsControllerProvider('quote-detail-pdf'),
        (_, _) {},
      );
      addTearDown(subscription.close);

      final notifier = container.read(
        quotePdfDetailActionsControllerProvider('quote-detail-pdf').notifier,
      );

      final first = notifier.exportDirect();
      final second = notifier.exportDirect();
      final results = await Future.wait([first, second]);

      expect(
        results.whereType<QuotePdfExportCancelled>().length,
        greaterThanOrEqualTo(1),
      );
      expect(fakeGenerator.generateCallCount, 1);
      expect(fakeExport.exportCallCount, lessThanOrEqualTo(1));
    });

    test('cancelamento permanece silencioso', () async {
      fakeExport.nextResult = const QuotePdfExportCancelled();
      final container = await createContainer(quote: eligibleQuote());
      addTearDown(container.dispose);

      final subscription = container.listen(
        quotePdfDetailActionsControllerProvider('quote-detail-pdf'),
        (_, _) {},
      );
      addTearDown(subscription.close);

      final result = await container
          .read(quotePdfDetailActionsControllerProvider('quote-detail-pdf')
              .notifier)
          .exportDirect();

      expect(result, isA<QuotePdfExportCancelled>());
    });

    test('falha de exportação retorna erro', () async {
      fakeExport.nextResult = const QuotePdfExportFailed();
      final container = await createContainer(quote: eligibleQuote());
      addTearDown(container.dispose);

      final subscription = container.listen(
        quotePdfDetailActionsControllerProvider('quote-detail-pdf'),
        (_, _) {},
      );
      addTearDown(subscription.close);

      final result = await container
          .read(quotePdfDetailActionsControllerProvider('quote-detail-pdf')
              .notifier)
          .exportDirect();

      expect(result, isA<QuotePdfExportFailed>());
    });
  });
}
