import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/core/widgets/primary_button.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/pdf/models/quote_pdf_export_result.dart';
import 'package:eventpro/features/quotes/pdf/providers/quote_pdf_providers.dart';
import 'package:eventpro/features/quotes/pdf/services/quote_pdf_export_service.dart';
import 'package:eventpro/features/quotes/pdf/theme/quote_pdf_fonts.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_eligibility.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_status_policy.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';
import 'package:eventpro/main.dart';

import 'quote_e2e_helpers.dart';
import 'quotes_test_helpers.dart';
import 'pdf/fakes/fake_quote_pdf_export_service.dart';
import 'pdf/fakes/fake_quote_pdf_generator.dart';
import 'pdf/fakes/fake_quote_pdf_logo_loader_service.dart';
import 'pdf/quote_pdf_test_helpers.dart';

void main() {
  group('TASK-020 Checkpoint D — PDF nos detalhes', () {
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

    List<Override> pdfOverrides() {
      return [
        quotePdfFontsProvider.overrideWith((ref) async => fonts),
        quotePdfGeneratorProvider.overrideWithValue(fakeGenerator),
        quotePdfLogoLoaderProvider.overrideWithValue(fakeLogoLoader),
        quotePdfExportServiceProvider.overrideWithValue(fakeExport),
      ];
    }

    Future<ProviderContainer> pumpAppWithQuote(
      WidgetTester tester,
      Quote draft, {
      String? location,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [...quoteE2eOverrides(extra: pdfOverrides())],
          child: const EventProApp(),
        ),
      );
      await tester.pumpAndSettle();

      final container = quoteTestContainer(tester);
      await seedQuote(container, draft);

      if (location != null) {
        AppRouter.router.go(location);
        await tester.pumpAndSettle();
      }

      return container;
    }

    Quote eligibleQuote({
      required String id,
      QuoteStatus status = QuoteStatus.sent,
    }) {
      return buildRichQuoteAddDraft(id: id).copyWith(
        companySnapshot: sampleCompanySnapshot(),
        status: status,
        subtotalCents: 300_000,
        totalCents: 295_000,
      );
    }

    Future<void> scrollToPdfSection(WidgetTester tester) async {
      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_pdf_section')),
      );
    }

    testWidgets('exibe seção PDF nos cinco status', (tester) async {
      useTallViewport(tester);

      for (final status in QuoteStatus.values) {
        final quote = eligibleQuote(id: 'quote-pdf-$status', status: status);
        await pumpAppWithQuote(
          tester,
          quote,
          location: AppRoutes.quotesDetail(quote.id),
        );

        await scrollToPdfSection(tester);

        expect(find.text('Documento PDF'), findsOneWidget);
        expect(
          find.byKey(const Key('quote_detail_pdf_view_button')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('quote_detail_pdf_export_button')),
          findsOneWidget,
        );
      }
    });

    testWidgets('orçamento legado exibe aviso e desabilita botões', (
      tester,
    ) async {
      useTallViewport(tester);

      await pumpAppWithQuote(
        tester,
        buildRichQuoteAddDraft(id: 'quote-legacy'),
        location: AppRoutes.quotesDetail('quote-legacy'),
      );
      await scrollToPdfSection(tester);

      final viewButton = tester.widget<PrimaryButton>(
        find.byKey(const Key('quote_detail_pdf_view_button')),
      );
      final exportButton = tester.widget<OutlinedButton>(
        find.byKey(const Key('quote_detail_pdf_export_button')),
      );

      expect(viewButton.onPressed, isNull);
      expect(exportButton.onPressed, isNull);
      expect(
        find.byKey(const Key('quote_detail_pdf_blocked_notice')),
        findsOneWidget,
      );
      expect(
        find.text(QuotePdfEligibility.missingCompanySnapshotMessage),
        findsOneWidget,
      );
    });

    testWidgets('visualizar abre preview e volta preservando a pilha', (
      tester,
    ) async {
      useTallViewport(tester);

      await pumpAppWithQuote(
        tester,
        eligibleQuote(id: 'quote-view-pdf', status: QuoteStatus.draft),
        location: AppRoutes.quotesDetail('quote-view-pdf'),
      );

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_pdf_view_button')),
      );

      await tester.tap(find.byKey(const Key('quote_detail_pdf_view_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byKey(const Key('quote_pdf_preview_screen')), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byKey(const Key('quote_pdf_preview_screen')),
          matching: find.byTooltip('Voltar'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('quote_detail_scroll')), findsOneWidget);
      expect(find.byKey(const Key('quote_pdf_preview_screen')), findsNothing);
    });

    Future<void> waitForPreview(WidgetTester tester) async {
      for (var attempt = 0; attempt < 100; attempt++) {
        await tester.pump(const Duration(milliseconds: 20));
        if (find.byKey(const Key('quote_pdf_preview')).evaluate().isNotEmpty) {
          return;
        }
      }
    }

    testWidgets('rascunho abre preview com política de marca d’água', (
      tester,
    ) async {
      useTallViewport(tester);

      await pumpAppWithQuote(
        tester,
        eligibleQuote(id: 'quote-draft-pdf', status: QuoteStatus.draft),
        location: AppRoutes.quotesDetail('quote-draft-pdf'),
      );

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_pdf_view_button')),
      );

      await tester.tap(find.byKey(const Key('quote_detail_pdf_view_button')));
      await waitForPreview(tester);

      expect(find.byKey(const Key('quote_pdf_preview')), findsOneWidget);
      expect(
        QuotePdfStatusPolicy.overlayFor(QuoteStatus.draft).watermarkText,
        QuotePdfStatusPolicy.draftWatermark,
      );
      expect(fakeGenerator.generateCallCount, 1);
    });

    testWidgets('exportação direta reutiliza bytes e exibe sucesso', (
      tester,
    ) async {
      useTallViewport(tester);

      final container = await pumpAppWithQuote(
        tester,
        eligibleQuote(id: 'quote-export-success'),
        location: AppRoutes.quotesDetail('quote-export-success'),
      );
      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_pdf_export_button')),
      );

      final quoteBefore = container
          .read(quotesProvider.notifier)
          .findById('quote-export-success')!;
      final historyLength = quoteBefore.statusHistory.length;
      final statusBefore = quoteBefore.status;

      await tester.tap(find.byKey(const Key('quote_detail_pdf_export_button')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(fakeGenerator.generateCallCount, 1);
      expect(fakeExport.exportCallCount, 1);

      await tester.tap(find.byKey(const Key('quote_detail_pdf_export_button')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(fakeGenerator.generateCallCount, 1);
      expect(fakeExport.exportCallCount, 2);
      expect(find.text('PDF salvo com sucesso'), findsOneWidget);

      final quoteAfter = container
          .read(quotesProvider.notifier)
          .findById('quote-export-success')!;
      expect(quoteAfter.status, statusBefore);
      expect(quoteAfter.statusHistory.length, historyLength);
    });

    testWidgets('cancelamento de exportação é silencioso', (tester) async {
      useTallViewport(tester);
      fakeExport.nextResult = const QuotePdfExportCancelled();

      await pumpAppWithQuote(
        tester,
        eligibleQuote(id: 'quote-export-cancel'),
        location: AppRoutes.quotesDetail('quote-export-cancel'),
      );
      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_pdf_export_button')),
      );

      await tester.tap(find.byKey(const Key('quote_detail_pdf_export_button')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.byKey(const Key('quote_detail_pdf_export_error_snackbar')),
        findsNothing,
      );
      expect(
        find.byKey(const Key('quote_detail_pdf_export_success_snackbar')),
        findsNothing,
      );
    });

    testWidgets('erro de exportação exibe feedback genérico', (tester) async {
      useTallViewport(tester);
      fakeExport.nextResult = const QuotePdfExportFailed();

      final container = await pumpAppWithQuote(
        tester,
        eligibleQuote(id: 'quote-export-error'),
        location: AppRoutes.quotesDetail('quote-export-error'),
      );
      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_pdf_export_button')),
      );

      final historyLength = container
          .read(quotesProvider.notifier)
          .findById('quote-export-error')!
          .statusHistory
          .length;

      await tester.tap(find.byKey(const Key('quote_detail_pdf_export_button')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.text(PlatformQuotePdfExportService.genericErrorMessage),
        findsOneWidget,
      );

      final quoteAfter = container
          .read(quotesProvider.notifier)
          .findById('quote-export-error')!;
      expect(quoteAfter.statusHistory.length, historyLength);
    });

    testWidgets('clique duplo dispara somente uma geração', (tester) async {
      useTallViewport(tester);
      fakeGenerator.delay = const Duration(milliseconds: 200);

      await pumpAppWithQuote(
        tester,
        eligibleQuote(id: 'quote-export-double'),
        location: AppRoutes.quotesDetail('quote-export-double'),
      );
      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_pdf_export_button')),
      );

      await tester.tap(find.byKey(const Key('quote_detail_pdf_export_button')));
      await tester.tap(find.byKey(const Key('quote_detail_pdf_export_button')));
      await tester.pump();

      expect(fakeGenerator.generateCallCount, lessThanOrEqualTo(1));
      expect(fakeExport.exportCallCount, lessThanOrEqualTo(1));

      await tester.pump(const Duration(milliseconds: 300));

      expect(fakeGenerator.generateCallCount, 1);
      expect(fakeExport.exportCallCount, 1);
    });
  });
}
