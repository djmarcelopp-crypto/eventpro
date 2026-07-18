import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_pix_key_type.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';
import 'package:eventpro/features/settings/providers/company_profile_provider.dart';
import 'package:eventpro/main.dart';

import 'quote_e2e_helpers.dart';
import 'quotes_test_helpers.dart';

void main() {
  group('TASK-019 Checkpoint D — detalhes da empresa emissora', () {
    tearDown(() {
      AppRouter.router.go(AppRoutes.dashboard);
    });

    Future<void> openDetail(WidgetTester tester, String quoteId) async {
      AppRouter.router.go(AppRoutes.quotesDetail(quoteId));
      await tester.pumpAndSettle();
    }

    testWidgets('exibe seção completa com snapshot configurado', (
      tester,
    ) async {
      await pumpQuoteAppSeeded(
        tester,
        sampleQuoteDraft(
          id: 'quote-company-full',
          status: QuoteStatus.draft,
          companySnapshot: sampleCompanySnapshot(
            captureStatus: QuoteCompanyCaptureStatus.configured,
          ),
        ),
      );

      await openDetail(tester, 'quote-company-full');

      expect(
        find.byKey(const Key('quote_company_issuer_section')),
        findsOneWidget,
      );
      expect(find.text('Empresa emissora'), findsOneWidget);
      expect(find.text('DJ Marcelo PP'), findsWidgets);
      expect(find.text('Marcelo PP Festas LTDA'), findsOneWidget);
      expect(find.text('11.222.333/0001-81'), findsOneWidget);
      expect(
        find.text('Dados completos no momento da criação'),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('quote_company_snapshot_missing_notice')),
        findsNothing,
      );
    });

    testWidgets('snapshot incompleto exibe status e oculta campos vazios', (
      tester,
    ) async {
      final snapshot = QuoteCompanySnapshot(
        identification: const QuoteCompanyIdentification(
          tradeName: 'DJ Marcelo PP',
        ),
        contact: const QuoteCompanyContact(phoneDigits: '67999990000'),
        address: const QuoteCompanyAddress(),
        captureStatus: QuoteCompanyCaptureStatus.incomplete,
        capturedAt: DateTime(2026, 7, 13),
      );

      await pumpQuoteAppSeeded(
        tester,
        sampleQuoteDraft(
          id: 'quote-company-partial',
          status: QuoteStatus.sent,
          companySnapshot: snapshot,
        ),
      );

      await openDetail(tester, 'quote-company-partial');

      expect(find.text('Empresa emissora'), findsOneWidget);
      expect(find.text('DJ Marcelo PP'), findsWidgets);
      expect(find.text('Razão social'), findsNothing);
      expect(find.text('CNPJ'), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(const Key('quote_company_issuer_section')),
          matching: find.text('Endereço'),
        ),
        findsNothing,
      );
      expect(
        find.text('Dados incompletos no momento da criação'),
        findsOneWidget,
      );
    });

    testWidgets('formata contato com prioridade WhatsApp e endereço resumido', (
      tester,
    ) async {
      await pumpQuoteAppSeeded(
        tester,
        sampleQuoteDraft(
          id: 'quote-company-format',
          companySnapshot: sampleCompanySnapshot(),
        ),
      );

      await openDetail(tester, 'quote-company-format');

      expect(find.textContaining('+55 (67) 98888-7777'), findsOneWidget);
      expect(find.text('Rua Example, 100 • Campo Grande - MS'), findsOneWidget);
    });

    testWidgets('não exibe PIX nem dados internos da empresa', (tester) async {
      final snapshot = QuoteCompanySnapshot(
        identification: const QuoteCompanyIdentification(
          tradeName: 'DJ Marcelo PP',
        ),
        contact: const QuoteCompanyContact(email: 'contato@djmarcelo.com'),
        address: const QuoteCompanyAddress(),
        legalRepresentative: const QuoteCompanyLegalRepresentative(
          fullName: 'Marcelo PP',
          cpfDigits: '52998224725',
        ),
        payment: const QuoteCompanyPayment(
          pixKeyType: QuotePixKeyType.email,
          pixKey: 'pix@empresa.com',
          beneficiaryName: 'Empresa LTDA',
        ),
        captureStatus: QuoteCompanyCaptureStatus.incomplete,
        capturedAt: DateTime(2026, 7, 13),
      );

      await pumpQuoteAppSeeded(
        tester,
        sampleQuoteDraft(
          id: 'quote-company-private',
          companySnapshot: snapshot,
        ),
      );

      await openDetail(tester, 'quote-company-private');

      expect(find.text('PIX'), findsNothing);
      expect(find.text('pix@empresa.com'), findsNothing);
      expect(find.text('52998224725'), findsNothing);
      expect(find.text('Representante legal'), findsNothing);
    });

    testWidgets('orçamento antigo sem snapshot mostra aviso discreto', (
      tester,
    ) async {
      await pumpQuoteAppSeeded(
        tester,
        sampleQuoteDraft(id: 'quote-legacy', companySnapshot: null),
      );

      await openDetail(tester, 'quote-legacy');

      expect(
        find.byKey(const Key('quote_company_snapshot_missing_notice')),
        findsOneWidget,
      );
      expect(
        find.text(
          'Os dados da empresa emissora não foram capturados neste orçamento.',
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('quote_company_issuer_section')),
        findsNothing,
      );
      expect(find.text('Empresa emissora'), findsNothing);
    });

    testWidgets('alteração em Settings não altera detalhes do orçamento', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: quoteE2eOverrides(),
          child: const EventProApp(),
        ),
      );

      final container = quoteTestContainer(tester);
      await container
          .read(companyProfileProvider.notifier)
          .save(
            sampleConfiguredCompanyProfile().copyWith(
              tradeName: 'Perfil Atual',
            ),
          );

      await seedQuote(
        container,
        sampleQuoteDraft(
          id: 'quote-frozen-company',
          companySnapshot: sampleCompanySnapshot(tradeName: 'Snapshot Antigo'),
        ),
      );

      await openDetail(tester, 'quote-frozen-company');
      expect(find.text('Snapshot Antigo'), findsWidgets);
      expect(find.text('Perfil Atual'), findsNothing);

      await container
          .read(companyProfileProvider.notifier)
          .save(
            sampleConfiguredCompanyProfile().copyWith(tradeName: 'Perfil Novo'),
          );

      AppRouter.router.go(AppRoutes.quotes);
      await tester.pumpAndSettle();
      await openDetail(tester, 'quote-frozen-company');

      expect(find.text('Snapshot Antigo'), findsWidgets);
      expect(find.text('Perfil Novo'), findsNothing);
    });

    testWidgets('edição preserva seção da empresa emissora', (tester) async {
      await pumpQuoteAppSeeded(
        tester,
        sampleQuoteDraft(
          id: 'quote-edit-company',
          status: QuoteStatus.draft,
          companySnapshot: sampleCompanySnapshot(
            tradeName: 'Empresa Congelada',
          ),
        ),
        location: AppRoutes.quotesDetail('quote-edit-company'),
      );

      expect(find.text('Empresa Congelada'), findsWidgets);

      await openQuoteEditFromDetail(tester);
      await tester.enterText(
        find.byKey(const Key('quote_notes_field')),
        'Nota após edição',
      );
      await tester.pumpAndSettle();
      await tapQuoteSave(tester);

      expect(find.text('Empresa Congelada'), findsWidgets);
      expect(find.text('Nota após edição'), findsOneWidget);
    });

    testWidgets('transições e reabertura preservam detalhes da empresa', (
      tester,
    ) async {
      final container = await pumpQuoteAppSeeded(
        tester,
        sampleQuoteDraft(
          id: 'quote-transition-company',
          status: QuoteStatus.draft,
          companySnapshot: sampleCompanySnapshot(tradeName: 'Empresa Estável'),
        ).copyWith(approvedAt: null),
        location: AppRoutes.quotesDetail('quote-transition-company'),
      );

      Future<void> expectCompanySection() async {
        await scrollQuoteDetailUntilVisible(
          tester,
          find.byKey(const Key('quote_company_issuer_section')),
        );
        expect(find.text('Empresa Estável'), findsWidgets);
      }

      await expectCompanySection();

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_mark_sent_button')),
      );
      await tester.tap(find.byKey(const Key('quote_detail_mark_sent_button')));
      await tester.pumpAndSettle();
      await confirmQuoteStatusDialog(tester);
      await expectCompanySection();

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_approve_button')),
      );
      await tester.tap(find.byKey(const Key('quote_detail_approve_button')));
      await tester.pumpAndSettle();
      await confirmQuoteStatusDialog(tester);
      await expectCompanySection();

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_reopen_button')),
      );
      await tester.tap(find.byKey(const Key('quote_detail_reopen_button')));
      await tester.pumpAndSettle();
      await confirmQuoteStatusDialog(tester);
      await expectCompanySection();

      final quote = container
          .read(quotesProvider.notifier)
          .findById('quote-transition-company')!;
      expect(
        quote.companySnapshot!.identification.tradeName,
        'Empresa Estável',
      );
    });

    testWidgets('listagem e edição de orçamento legado não causam erro', (
      tester,
    ) async {
      final container = await pumpQuoteAppSeeded(
        tester,
        sampleQuoteDraft(
          id: 'quote-legacy-flow',
          status: QuoteStatus.draft,
          companySnapshot: null,
        ),
        location: AppRoutes.quotes,
      );

      await openQuoteDetailFromList(tester, 'quote-legacy-flow');
      expect(
        find.byKey(const Key('quote_company_snapshot_missing_notice')),
        findsOneWidget,
      );

      await openQuoteEditFromDetail(tester);
      await tapQuoteSave(tester);

      final quote = container
          .read(quotesProvider.notifier)
          .findById('quote-legacy-flow')!;
      expect(quote.companySnapshot, isNull);
      expect(
        find.byKey(const Key('quote_company_snapshot_missing_notice')),
        findsOneWidget,
      );
    });
  });
}
