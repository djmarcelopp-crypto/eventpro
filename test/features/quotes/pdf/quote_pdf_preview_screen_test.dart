import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/features/quotes/pdf/models/quote_pdf_export_result.dart';
import 'package:eventpro/features/quotes/pdf/providers/quote_pdf_providers.dart';
import 'package:eventpro/features/quotes/pdf/theme/quote_pdf_fonts.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';
import 'package:eventpro/main.dart';

import '../quote_e2e_helpers.dart';
import '../quotes_test_helpers.dart';
import 'fakes/fake_quote_pdf_export_service.dart';
import 'fakes/fake_quote_pdf_generator.dart';
import 'fakes/fake_quote_pdf_logo_loader_service.dart';
import 'quote_pdf_test_helpers.dart';

void main() {
  group('QuotePdfPreviewScreen', () {
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

    tearDown(() {
      AppRouter.router.go(AppRoutes.dashboard);
    });

    void useWideViewport(WidgetTester tester) {
      tester.view.physicalSize = const Size(1600, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    List<Override> pdfOverrides() {
      return [
        quotePdfFontsProvider.overrideWith((ref) async => fonts),
        quotePdfGeneratorProvider.overrideWithValue(fakeGenerator),
        quotePdfLogoLoaderProvider.overrideWithValue(fakeLogoLoader),
        quotePdfExportServiceProvider.overrideWithValue(fakeExport),
      ];
    }

    Future<void> pumpPdfRoute(
      WidgetTester tester, {
      required String quoteId,
      bool seedQuote = true,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [...quoteE2eOverrides(extra: pdfOverrides())],
          child: const EventProApp(),
        ),
      );
      await tester.pumpAndSettle();

      if (seedQuote) {
        final container = quoteTestContainer(tester);
        await seedQuoteDependencies(container);
        await container
            .read(quotesProvider.notifier)
            .addQuote(
              buildRichQuoteAddDraft(id: quoteId).copyWith(
                companySnapshot: sampleCompanySnapshot(),
                subtotalCents: 300_000,
                totalCents: 295_000,
              ),
            );
      }

      AppRouter.router.go(AppRoutes.quotesPdf(quoteId));
      await tester.pump();
    }

    Future<void> waitForPdfReady(WidgetTester tester) async {
      for (var attempt = 0; attempt < 100; attempt++) {
        await tester.pump(const Duration(milliseconds: 20));
        if (find.byKey(const Key('quote_pdf_preview')).evaluate().isNotEmpty) {
          return;
        }
        if (find
            .byKey(const Key('quote_pdf_preview_blocked'))
            .evaluate()
            .isNotEmpty) {
          return;
        }
        if (find
            .byKey(const Key('quote_pdf_preview_not_found'))
            .evaluate()
            .isNotEmpty) {
          return;
        }
        if (find
            .byKey(const Key('quote_pdf_preview_error'))
            .evaluate()
            .isNotEmpty) {
          return;
        }
      }
    }

    testWidgets('monta a rota de preview do PDF', (tester) async {
      useWideViewport(tester);

      await pumpPdfRoute(tester, quoteId: 'quote-pdf-route');
      await waitForPdfReady(tester);

      expect(find.byKey(const Key('quote_pdf_preview_screen')), findsOneWidget);
    });

    testWidgets('exibe estado amigável quando orçamento não existe', (
      tester,
    ) async {
      useWideViewport(tester);
      await pumpPdfRoute(tester, quoteId: 'missing-quote', seedQuote: false);
      await waitForPdfReady(tester);

      expect(
        find.byKey(const Key('quote_pdf_preview_not_found')),
        findsOneWidget,
      );
      expect(find.text('Orçamento não encontrado'), findsOneWidget);
    });

    testWidgets('bloqueia PDF sem companySnapshot', (tester) async {
      useWideViewport(tester);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [...quoteE2eOverrides(extra: pdfOverrides())],
          child: const EventProApp(),
        ),
      );
      await tester.pumpAndSettle();

      final container = quoteTestContainer(tester);
      await seedQuoteDependencies(container);
      await container
          .read(quotesProvider.notifier)
          .addQuote(buildRichQuoteAddDraft(id: 'quote-pdf-blocked'));

      AppRouter.router.go(AppRoutes.quotesPdf('quote-pdf-blocked'));
      await waitForPdfReady(tester);

      expect(
        find.byKey(const Key('quote_pdf_preview_blocked')),
        findsOneWidget,
      );
      expect(find.textContaining('dados congelados'), findsOneWidget);
    });

    testWidgets('exibe preview e botão de exportação após sucesso', (
      tester,
    ) async {
      useWideViewport(tester);
      await pumpPdfRoute(tester, quoteId: 'quote-pdf-ready');
      await waitForPdfReady(tester);

      expect(find.byKey(const Key('quote_pdf_preview')), findsOneWidget);
      expect(find.byKey(const Key('quote_pdf_export_button')), findsOneWidget);
      expect(find.byKey(const Key('quote_pdf_export_bar')), findsOneWidget);
      expect(fakeGenerator.generateCallCount, 1);
    });

    testWidgets('exibe erro genérico quando exportação falha', (tester) async {
      useWideViewport(tester);
      fakeExport.nextResult = const QuotePdfExportFailed();

      await pumpPdfRoute(tester, quoteId: 'quote-pdf-export-error');
      await waitForPdfReady(tester);

      await tester.tap(find.byKey(const Key('quote_pdf_export_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Não foi possível exportar o PDF. Tente novamente.'),
        findsOneWidget,
      );
    });

    testWidgets('cancelamento de exportação não exibe snackbar', (
      tester,
    ) async {
      useWideViewport(tester);
      fakeExport.nextResult = const QuotePdfExportCancelled();

      await pumpPdfRoute(tester, quoteId: 'quote-pdf-export-cancel');
      await waitForPdfReady(tester);

      await tester.ensureVisible(
        find.byKey(const Key('quote_pdf_export_button')),
      );
      await tester.tap(find.byKey(const Key('quote_pdf_export_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.byKey(const Key('quote_pdf_export_error_snackbar')),
        findsNothing,
      );
    });
  });
}
