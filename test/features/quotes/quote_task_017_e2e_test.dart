import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/main.dart';
import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/core/widgets/primary_button.dart';
import 'package:eventpro/features/catalog/providers/catalog_provider.dart';
import 'package:eventpro/features/clients/providers/clients_provider.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';

import 'quote_e2e_helpers.dart';
import 'quotes_test_helpers.dart';

void main() {
  group('TASK-017 E2E — navegação e rotas', () {
    testWidgets('card da lista abre /quotes/:id', (tester) async {
      final container = await pumpQuoteAppSeeded(
        tester,
        buildRichQuoteAddDraft(),
        location: AppRoutes.quotes,
      );
      final quote = container.read(quotesProvider).single;

      await openQuoteDetailFromList(tester, quote.id);

      expect(find.text(quote.number), findsWidgets);
      expect(find.text('Maria Silva'), findsWidgets);
    });

    testWidgets('/quotes/new não colide com /quotes/:id', (tester) async {
      final container = await pumpQuoteAppSeeded(
        tester,
        buildRichQuoteAddDraft(id: 'quote-route'),
      );
      final quote = container.read(quotesProvider).single;

      AppRouter.router.go(AppRoutes.quotesNew);
      await tester.pumpAndSettle();
      expect(find.text('Novo orçamento'), findsOneWidget);

      AppRouter.router.go(AppRoutes.quotesDetail(quote.id));
      await tester.pumpAndSettle();
      expect(find.text('Novo orçamento'), findsNothing);
      expect(find.byKey(const Key('quote_detail_scroll')), findsOneWidget);
    });

    testWidgets('ID inexistente mostra estado amigável e permite voltar', (
      tester,
    ) async {
      await pumpQuoteAppWithContainer(tester);
      AppRouter.router.go(AppRoutes.quotesDetail('missing-id'));
      await tester.pumpAndSettle();

      expect(find.text('Orçamento não encontrado'), findsOneWidget);
      await tester.tap(find.byKey(const Key('quote_not_found_back_button')));
      await tester.pumpAndSettle();

      expect(find.text('Orçamentos'), findsOneWidget);
    });
  });

  group('TASK-017 E2E — detalhes', () {
    testWidgets('exibe seções completas do orçamento rico', (tester) async {
      await pumpQuoteAppSeeded(
        tester,
        buildRichQuoteAddDraft(),
        location: AppRoutes.quotesDetail('quote-rich'),
      );

      expect(find.text('Cliente'), findsOneWidget);
      expect(find.text('Maria Silva'), findsWidgets);
      expect(find.text('Evento'), findsOneWidget);
      expect(find.text('Casamento Ana'), findsOneWidget);
      expect(find.text('Itens do orçamento (1)'), findsOneWidget);
      expect(find.text('Caixa de som'), findsOneWidget);
      expect(find.text('Financeiro'), findsOneWidget);
      expect(find.text('Observações para o cliente'), findsOneWidget);
      expect(find.text('Observação pública do orçamento'), findsOneWidget);
      expect(find.text('Observações internas'), findsOneWidget);
      expect(find.text('Nota interna da equipe'), findsOneWidget);
      expect(find.text('Histórico de status (1)'), findsOneWidget);

      await expandQuoteStatusHistory(tester);

      expect(find.text('Orçamento criado como Rascunho'), findsOneWidget);
    });

    testWidgets('campos opcionais vazios não aparecem', (tester) async {
      await pumpQuoteAppSeeded(
        tester,
        buildMinimalQuoteAddDraft(),
        location: AppRoutes.quotesDetail('quote-minimal'),
      );

      expect(find.text('Evento'), findsNothing);
      expect(find.text('Observações para o cliente'), findsNothing);
      expect(find.text('Observações internas'), findsNothing);
      expect(find.text('Cliente'), findsOneWidget);
      expect(find.text('Itens do orçamento (1)'), findsOneWidget);
      expect(find.text('Financeiro'), findsOneWidget);
    });

    testWidgets('rascunho mostra botão Editar', (tester) async {
      await pumpQuoteAppSeeded(
        tester,
        buildRichQuoteAddDraft(),
        location: AppRoutes.quotesDetail('quote-rich'),
      );

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_edit_button')),
      );
      expect(find.byKey(const Key('quote_detail_edit_button')), findsOneWidget);
    });

    testWidgets('WhatsApp formatado aparece nos detalhes', (tester) async {
      await pumpQuoteAppSeeded(
        tester,
        buildRichQuoteAddDraft(id: 'quote-contact').copyWith(
          clientSnapshot: const QuoteClientSnapshot(
            type: QuoteClientType.individual,
            displayName: 'Maria Silva',
            whatsApp: '5567981495959',
          ),
        ),
        location: AppRoutes.quotesDetail('quote-contact'),
      );

      expect(find.text('+55 (67) 98149-5959'), findsOneWidget);
      expect(find.text('5567981495959'), findsNothing);
    });
  });

  group('TASK-017 E2E — edição', () {
    testWidgets('edição abre pré-preenchida e salva preservando metadados', (
      tester,
    ) async {
      useTallViewport(tester);

      final container = await pumpQuoteAppSeeded(
        tester,
        buildRichQuoteAddDraft(),
        location: AppRoutes.quotesDetail('quote-rich'),
      );
      final quote = container.read(quotesProvider).single;
      final historyBefore = List.of(quote.statusHistory);

      await openQuoteEditFromDetail(tester);

      expect(find.text('Editar orçamento'), findsOneWidget);
      expect(find.text('Maria Silva'), findsWidgets);
      expect(find.text('Observação pública do orçamento'), findsOneWidget);
      expect(find.text('Casamento Ana'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('quote_notes_field')),
        'Observação pública atualizada',
      );
      await tester.pumpAndSettle();
      await tapQuoteSave(tester);

      expect(find.byKey(const Key('quote_detail_scroll')), findsOneWidget);
      expect(find.text('Orçamento atualizado com sucesso'), findsOneWidget);
      expect(find.text('Observação pública atualizada'), findsOneWidget);

      final updated = container
          .read(quotesProvider.notifier)
          .findById(quote.id)!;
      expect(updated.id, quote.id);
      expect(updated.number, quote.number);
      expect(updated.createdAt, quote.createdAt);
      expect(updated.statusHistory, historyBefore);
    });

    testWidgets('edição bloqueada fora de rascunho', (tester) async {
      Future<void> expectBlocked(QuoteStatus targetStatus) async {
        final quoteId = 'quote-block-${targetStatus.name}';
        await pumpQuoteAppWithContainer(tester);
        final container = quoteTestContainer(tester);
        await seedQuote(container, buildRichQuoteAddDraft(id: quoteId));

        if (targetStatus == QuoteStatus.sent) {
          await transitionQuoteTo(container, quoteId, QuoteStatus.sent);
        } else if (targetStatus == QuoteStatus.approved) {
          await transitionQuoteTo(container, quoteId, QuoteStatus.sent);
          await transitionQuoteTo(container, quoteId, QuoteStatus.approved);
        } else if (targetStatus == QuoteStatus.rejected) {
          await transitionQuoteTo(container, quoteId, QuoteStatus.sent);
          await transitionQuoteTo(container, quoteId, QuoteStatus.rejected);
        } else if (targetStatus == QuoteStatus.cancelled) {
          await transitionQuoteTo(container, quoteId, QuoteStatus.cancelled);
        }

        AppRouter.router.go(AppRoutes.quotesEdit(quoteId));
        await tester.pumpAndSettle();

        expect(
          find.text('Somente orçamentos em rascunho podem ser editados.'),
          findsOneWidget,
        );
      }

      await expectBlocked(QuoteStatus.sent);
      await expectBlocked(QuoteStatus.approved);
      await expectBlocked(QuoteStatus.rejected);
      await expectBlocked(QuoteStatus.cancelled);
    });

    testWidgets('item existente inativo mostra aviso e salva snapshot', (
      tester,
    ) async {
      useTallViewport(tester);

      final container = await pumpQuoteAppSeeded(
        tester,
        buildRichQuoteAddDraft(id: 'quote-inactive').copyWith(
          items: [
            sampleLineItem(
              catalogItemId: 'item-1',
              name: 'Nome congelado no orçamento',
              unit: 'Pacote',
            ),
          ],
        ),
        location: AppRoutes.quotes,
      );

      expect(
        container.read(quotesProvider).single.items.single.name,
        'Nome congelado no orçamento',
      );

      await openQuoteDetailFromList(tester, 'quote-inactive');
      container
          .read(catalogProvider.notifier)
          .updateItem(sampleCatalogItem(active: false));
      await tester.pumpAndSettle();
      await openQuoteEditFromDetail(tester);

      expect(find.text('Nome congelado no orçamento'), findsOneWidget);
      expect(find.textContaining('Item inativo no catálogo'), findsOneWidget);

      await tapQuoteSave(tester);

      final updated = container
          .read(quotesProvider.notifier)
          .findById('quote-inactive')!;
      expect(updated.items.single.name, 'Nome congelado no orçamento');
      expect(updated.items.single.unit, 'Pacote');
    });

    testWidgets('item existente ausente mostra aviso e salva snapshot', (
      tester,
    ) async {
      useTallViewport(tester);

      await pumpQuoteAppWithContainer(tester);
      final container = quoteTestContainer(tester);
      await seedQuoteDependencies(container);
      await container
          .read(quotesProvider.notifier)
          .addQuote(
            buildRichQuoteAddDraft(id: 'quote-missing').copyWith(
              items: [
                sampleLineItem(
                  catalogItemId: 'missing-item',
                  name: 'Item ausente congelado',
                ),
              ],
            ),
          );

      AppRouter.router.go(AppRoutes.quotes);
      await tester.pumpAndSettle();
      await openQuoteDetailFromList(tester, 'quote-missing');
      await openQuoteEditFromDetail(tester);

      expect(
        find.textContaining('Item não encontrado no catálogo'),
        findsOneWidget,
      );

      await tapQuoteSave(tester);

      final updated = container
          .read(quotesProvider.notifier)
          .findById('quote-missing')!;
      expect(updated.items.single.name, 'Item ausente congelado');
      expect(updated.items.single.catalogItemId, 'missing-item');
    });

    testWidgets(
      'alterar orçamento não modifica clientsProvider nem catalogProvider',
      (tester) async {
        useTallViewport(tester);

        final container = await pumpQuoteAppSeeded(
          tester,
          buildRichQuoteAddDraft(id: 'quote-isolation'),
          location: AppRoutes.quotesEdit('quote-isolation'),
        );
        final clientsBefore = List.of(container.read(clientsProvider));
        final catalogBefore = List.of(container.read(catalogProvider));

        await tester.enterText(
          find.byKey(const Key('quote_notes_field')),
          'Alteração isolada',
        );
        await tester.pumpAndSettle();
        await tapQuoteSave(tester);

        expect(container.read(clientsProvider), clientsBefore);
        expect(container.read(catalogProvider), catalogBefore);
      },
    );
  });

  group('TASK-017 E2E — transições de status', () {
    Future<ProviderContainer> openDetail(
      WidgetTester tester,
      String quoteId,
    ) async {
      await pumpQuoteAppWithContainer(tester);
      final container = quoteTestContainer(tester);
      await seedQuote(container, buildRichQuoteAddDraft(id: quoteId));
      AppRouter.router.go(AppRoutes.quotesDetail(quoteId));
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('diálogo draft → sent cancelar não altera status', (
      tester,
    ) async {
      final container = await openDetail(tester, 'quote-sent-cancel');

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_mark_sent_button')),
      );
      await tester.tap(find.byKey(const Key('quote_detail_mark_sent_button')));
      await tester.pumpAndSettle();
      await cancelQuoteStatusDialog(tester);

      final quote = container
          .read(quotesProvider.notifier)
          .findById('quote-sent-cancel')!;
      expect(quote.status, QuoteStatus.draft);
      expect(quote.statusHistory, hasLength(1));
    });

    testWidgets('diálogo draft → sent confirmar altera uma vez', (
      tester,
    ) async {
      final container = await openDetail(tester, 'quote-sent-confirm');

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_mark_sent_button')),
      );
      await tester.tap(find.byKey(const Key('quote_detail_mark_sent_button')));
      await tester.pumpAndSettle();
      await confirmQuoteStatusDialog(tester);

      expect(find.text('Orçamento marcado como enviado'), findsOneWidget);

      final quote = container
          .read(quotesProvider.notifier)
          .findById('quote-sent-confirm')!;
      expect(quote.status, QuoteStatus.sent);
      expect(quote.statusHistory, hasLength(2));
      expect(quote.statusHistory.last.newStatus, QuoteStatus.sent);
    });

    testWidgets(
      'sent → approved atualiza status, approvedAt, contrato e histórico',
      (tester) async {
        final container = await openDetail(tester, 'quote-approve');
        await transitionQuoteTo(container, 'quote-approve', QuoteStatus.sent);
        await tester.pumpAndSettle();

        await scrollQuoteDetailUntilVisible(
          tester,
          find.byKey(const Key('quote_detail_approve_button')),
        );
        await tester.tap(find.byKey(const Key('quote_detail_approve_button')));
        await tester.pumpAndSettle();
        await confirmQuoteStatusDialog(tester);

        final quote = container
            .read(quotesProvider.notifier)
            .findById('quote-approve')!;
        expect(quote.status, QuoteStatus.approved);
        expect(quote.approvedAt, quoteE2eFixedNow);
        expect(quote.isApprovedForContract, isTrue);
        expect(find.text('Aprovado'), findsWidgets);
        expect(find.text('Aprovado em'), findsOneWidget);
        expect(find.text('13/julho/2026 às 10:30'), findsWidgets);
        await expandQuoteStatusHistory(tester);
        expect(find.text('Rascunho → Enviado'), findsOneWidget);
        expect(find.text('Enviado → Aprovado'), findsOneWidget);
      },
    );

    testWidgets('sent → rejected', (tester) async {
      final container = await openDetail(tester, 'quote-reject');
      await transitionQuoteTo(container, 'quote-reject', QuoteStatus.sent);
      await tester.pumpAndSettle();

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_reject_button')),
      );
      await tester.tap(find.byKey(const Key('quote_detail_reject_button')));
      await tester.pumpAndSettle();
      await confirmQuoteStatusDialog(tester);

      final quote = container
          .read(quotesProvider.notifier)
          .findById('quote-reject')!;
      expect(quote.status, QuoteStatus.rejected);
      expect(find.text('Recusado'), findsWidgets);
      await expandQuoteStatusHistory(tester);
      expect(find.text('Enviado → Recusado'), findsOneWidget);
    });

    testWidgets('rascunho pode ser cancelado', (tester) async {
      useTallViewport(tester);
      final container = await openDetail(tester, 'quote-cancel-draft');

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_cancel_button')),
      );
      await tester.tap(find.byKey(const Key('quote_detail_cancel_button')));
      await tester.pumpAndSettle();
      await confirmQuoteStatusDialog(tester);

      final quote = container
          .read(quotesProvider.notifier)
          .findById('quote-cancel-draft')!;
      expect(quote.status, QuoteStatus.cancelled);
    });

    testWidgets('enviado pode ser cancelado', (tester) async {
      useTallViewport(tester);
      final container = await openDetail(tester, 'quote-cancel-sent');
      await transitionQuoteTo(container, 'quote-cancel-sent', QuoteStatus.sent);
      await tester.pumpAndSettle();

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_cancel_button')),
      );
      await tester.tap(find.byKey(const Key('quote_detail_cancel_button')));
      await tester.pumpAndSettle();
      await confirmQuoteStatusDialog(tester);

      final quote = container
          .read(quotesProvider.notifier)
          .findById('quote-cancel-sent')!;
      expect(quote.status, QuoteStatus.cancelled);
    });

    testWidgets('aprovado pode ser cancelado', (tester) async {
      useTallViewport(tester);
      final container = await openDetail(tester, 'quote-cancel-approved');
      await transitionQuoteTo(
        container,
        'quote-cancel-approved',
        QuoteStatus.sent,
      );
      await transitionQuoteTo(
        container,
        'quote-cancel-approved',
        QuoteStatus.approved,
      );
      await tester.pumpAndSettle();

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_cancel_button')),
      );
      await tester.tap(find.byKey(const Key('quote_detail_cancel_button')));
      await tester.pumpAndSettle();
      await confirmQuoteStatusDialog(tester);

      final quote = container
          .read(quotesProvider.notifier)
          .findById('quote-cancel-approved')!;
      expect(quote.status, QuoteStatus.cancelled);
    });

    testWidgets(
      'duplo clique em transição válida gera uma entrada no histórico',
      (tester) async {
        useTallViewport(tester);
        final container = await openDetail(tester, 'quote-double');

        final markSent = find.byKey(const Key('quote_detail_mark_sent_button'));
        await scrollQuoteDetailUntilVisible(tester, markSent);
        await tester.tap(markSent);
        await tester.pumpAndSettle();

        final confirm = find.byKey(const Key('quote_status_dialog_confirm'));
        expect(confirm, findsOneWidget);
        await tester.tap(confirm);
        await tester.tap(confirm);
        await tester.pump();
        await tester.pumpAndSettle();

        final quote = container
            .read(quotesProvider.notifier)
            .findById('quote-double')!;
        expect(quote.status, QuoteStatus.sent);
        expect(quote.statusHistory, hasLength(2));
      },
    );

    testWidgets('transição inválida mostra feedback e não altera histórico', (
      tester,
    ) async {
      final container = await openDetail(tester, 'quote-invalid');

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_mark_sent_button')),
      );
      await tester.tap(find.byKey(const Key('quote_detail_mark_sent_button')));
      await tester.pumpAndSettle();

      await transitionQuoteTo(container, 'quote-invalid', QuoteStatus.sent);
      await tester.pumpAndSettle();

      await confirmQuoteStatusDialog(tester);

      expect(
        find.text('Esta alteração de status não é permitida'),
        findsOneWidget,
      );

      final quote = container
          .read(quotesProvider.notifier)
          .findById('quote-invalid')!;
      expect(quote.status, QuoteStatus.sent);
      expect(quote.statusHistory, hasLength(2));
    });
  });

  group('TASK-017 E2E — listagem e contrato', () {
    testWidgets('badge da lista atualiza após voltar dos detalhes', (
      tester,
    ) async {
      final container = await pumpQuoteAppSeeded(
        tester,
        buildRichQuoteAddDraft(id: 'quote-badge'),
        location: AppRoutes.quotes,
      );

      expect(find.text('Rascunho'), findsOneWidget);

      await openQuoteDetailFromList(tester, 'quote-badge');
      await transitionQuoteTo(container, 'quote-badge', QuoteStatus.sent);
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Voltar'));
      await tester.pumpAndSettle();

      expect(find.text('Rascunho'), findsNothing);
      expect(find.text('Enviado'), findsOneWidget);
    });

    testWidgets(
      'botão Gerar contrato aparece somente em approved e está desabilitado',
      (tester) async {
        final container = await pumpQuoteAppSeeded(
          tester,
          buildRichQuoteAddDraft(id: 'quote-contract-draft'),
          location: AppRoutes.quotesDetail('quote-contract-draft'),
        );

        expect(
          find.byKey(const Key('quote_detail_generate_contract_button')),
          findsNothing,
        );

        await transitionQuoteTo(
          container,
          'quote-contract-draft',
          QuoteStatus.sent,
        );
        await transitionQuoteTo(
          container,
          'quote-contract-draft',
          QuoteStatus.approved,
        );
        await tester.pumpAndSettle();

        final contractButton = find.byKey(
          const Key('quote_detail_generate_contract_button'),
        );
        await scrollQuoteDetailUntilVisible(tester, contractButton);
        expect(contractButton, findsOneWidget);
        expect(find.text('Gerar contrato (Em breve)'), findsOneWidget);

        final button = tester.widget<PrimaryButton>(contractButton);
        expect(button.onPressed, isNull);
      },
    );
  });

  group('TASK-017 E2E — pilha de navegação', () {
    testWidgets(
      'Detalhes → Editar → Salvar → Voltar até Dashboard preserva pilha',
      (tester) async {
        useTallViewport(tester);

        await pumpQuoteAppWithContainer(tester);
        final container = quoteTestContainer(tester);
        await seedQuote(container, buildRichQuoteAddDraft(id: 'quote-stack'));

        AppRouter.router.go(AppRoutes.dashboard);
        await tester.pumpAndSettle();
        AppRouter.router.push(AppRoutes.quotes);
        await tester.pumpAndSettle();

        await openQuoteDetailFromList(tester, 'quote-stack');
        await openQuoteEditFromDetail(tester);

        await tester.enterText(
          find.byKey(const Key('quote_notes_field')),
          'Notas após navegação',
        );
        await tester.pumpAndSettle();
        await tapQuoteSave(tester);

        expect(find.text('Orçamento atualizado com sucesso'), findsOneWidget);

        await tester.tap(find.byTooltip('Voltar'));
        await tester.pumpAndSettle();
        expect(find.text('Orçamentos'), findsOneWidget);

        await tester.tap(find.byTooltip('Voltar'));
        await tester.pumpAndSettle();
        expect(find.text('Bem-vindo ao EventPro'), findsOneWidget);
      },
    );
  });

  group('TASK-017 E2E — reabrir para edição', () {
    Future<ProviderContainer> openApprovedDetail(
      WidgetTester tester,
      String quoteId,
    ) async {
      await pumpQuoteAppWithContainer(tester);
      final container = quoteTestContainer(tester);
      await seedQuote(container, buildRichQuoteAddDraft(id: quoteId));
      await transitionQuoteTo(container, quoteId, QuoteStatus.sent);
      await transitionQuoteTo(container, quoteId, QuoteStatus.approved);
      AppRouter.router.go(AppRoutes.quotesDetail(quoteId));
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('aprovado exibe Reabrir para edição', (tester) async {
      useTallViewport(tester);
      await openApprovedDetail(tester, 'quote-reopen-visible');

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_reopen_button')),
      );
      expect(find.text('Reabrir para edição'), findsOneWidget);
    });

    testWidgets('enviado não exibe Reabrir para edição', (tester) async {
      useTallViewport(tester);
      await pumpQuoteAppWithContainer(tester);
      final container = quoteTestContainer(tester);
      await seedQuote(
        container,
        buildRichQuoteAddDraft(id: 'quote-reopen-sent'),
      );
      await transitionQuoteTo(container, 'quote-reopen-sent', QuoteStatus.sent);
      AppRouter.router.go(AppRoutes.quotesDetail('quote-reopen-sent'));
      await tester.pumpAndSettle();

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_cancel_button')),
      );
      expect(find.byKey(const Key('quote_detail_reopen_button')), findsNothing);
    });

    testWidgets('rejeitado e cancelado não exibem Reabrir para edição', (
      tester,
    ) async {
      useTallViewport(tester);

      Future<void> expectNoReopen(String quoteId, QuoteStatus status) async {
        await pumpQuoteAppWithContainer(tester);
        final container = quoteTestContainer(tester);
        await seedQuote(container, buildRichQuoteAddDraft(id: quoteId));
        if (status == QuoteStatus.rejected) {
          await transitionQuoteTo(container, quoteId, QuoteStatus.sent);
          await transitionQuoteTo(container, quoteId, QuoteStatus.rejected);
        } else {
          await transitionQuoteTo(container, quoteId, QuoteStatus.cancelled);
        }
        AppRouter.router.go(AppRoutes.quotesDetail(quoteId));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('quote_detail_reopen_button')),
          findsNothing,
        );
      }

      await expectNoReopen('quote-reopen-rejected', QuoteStatus.rejected);
      await expectNoReopen('quote-reopen-cancelled', QuoteStatus.cancelled);
    });

    testWidgets('cancelar diálogo de reabertura não altera status', (
      tester,
    ) async {
      useTallViewport(tester);
      final container = await openApprovedDetail(tester, 'quote-reopen-cancel');

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_reopen_button')),
      );
      await tester.tap(find.byKey(const Key('quote_detail_reopen_button')));
      await tester.pumpAndSettle();
      await cancelQuoteStatusDialog(tester);

      final quote = container
          .read(quotesProvider.notifier)
          .findById('quote-reopen-cancel')!;
      expect(quote.status, QuoteStatus.approved);
      expect(quote.approvedAt, quoteE2eFixedNow);
      expect(quote.statusHistory, hasLength(3));
    });

    testWidgets('confirmar reabertura volta para rascunho e libera Editar', (
      tester,
    ) async {
      useTallViewport(tester);
      final container = await openApprovedDetail(
        tester,
        'quote-reopen-confirm',
      );
      final before = container
          .read(quotesProvider.notifier)
          .findById('quote-reopen-confirm')!;

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_reopen_button')),
      );
      await tester.tap(find.byKey(const Key('quote_detail_reopen_button')));
      await tester.pumpAndSettle();
      await confirmQuoteStatusDialog(tester);

      expect(find.text('Orçamento reaberto para edição'), findsOneWidget);

      final quote = container
          .read(quotesProvider.notifier)
          .findById('quote-reopen-confirm')!;
      expect(quote.status, QuoteStatus.draft);
      expect(quote.approvedAt, isNull);
      expect(quote.number, before.number);
      expect(quote.createdAt, before.createdAt);
      expect(quote.items, before.items);
      expect(quote.totalCents, before.totalCents);
      expect(quote.statusHistory, hasLength(4));
      expect(quote.statusHistory.last.previousStatus, QuoteStatus.approved);
      expect(quote.statusHistory.last.newStatus, QuoteStatus.draft);
      await expandQuoteStatusHistory(tester);
      expect(find.text('Aprovado → Rascunho'), findsOneWidget);

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_edit_button')),
      );
      expect(find.byKey(const Key('quote_detail_edit_button')), findsOneWidget);
    });

    testWidgets('duplo clique em reabertura gera uma entrada no histórico', (
      tester,
    ) async {
      useTallViewport(tester);
      final container = await openApprovedDetail(tester, 'quote-reopen-double');

      await scrollQuoteDetailUntilVisible(
        tester,
        find.byKey(const Key('quote_detail_reopen_button')),
      );
      await tester.tap(find.byKey(const Key('quote_detail_reopen_button')));
      await tester.pumpAndSettle();

      final confirm = find.byKey(const Key('quote_status_dialog_confirm'));
      expect(confirm, findsOneWidget);
      await tester.tap(confirm);
      await tester.tap(confirm);
      await tester.pump();
      await tester.pumpAndSettle();

      final quote = container
          .read(quotesProvider.notifier)
          .findById('quote-reopen-double')!;
      expect(quote.status, QuoteStatus.draft);
      expect(quote.statusHistory, hasLength(4));
    });

    testWidgets(
      'ciclo draft → sent → approved → draft → sent → approved preserva dados e histórico',
      (tester) async {
        useTallViewport(tester);

        final clock = QuoteE2eMutableClock(DateTime(2026, 7, 13, 10, 0));
        await tester.pumpWidget(
          ProviderScope(
            overrides: quoteE2eOverrides(mutableClock: clock),
            child: const EventProApp(),
          ),
        );
        await tester.pumpAndSettle();

        final container = quoteTestContainer(tester);
        final seeded = await seedQuote(
          container,
          buildRichQuoteAddDraft(id: 'quote-reopen-cycle'),
        );
        final number = seeded.number;
        final createdAt = seeded.createdAt;
        final items = seeded.items;

        AppRouter.router.go(AppRoutes.quotesDetail('quote-reopen-cycle'));
        await tester.pumpAndSettle();

        clock.now = DateTime(2026, 7, 13, 11, 0);
        await scrollQuoteDetailUntilVisible(
          tester,
          find.byKey(const Key('quote_detail_mark_sent_button')),
        );
        await tester.tap(
          find.byKey(const Key('quote_detail_mark_sent_button')),
        );
        await tester.pumpAndSettle();
        await confirmQuoteStatusDialog(tester);

        clock.now = DateTime(2026, 7, 13, 12, 0);
        await scrollQuoteDetailUntilVisible(
          tester,
          find.byKey(const Key('quote_detail_approve_button')),
        );
        await tester.tap(find.byKey(const Key('quote_detail_approve_button')));
        await tester.pumpAndSettle();
        await confirmQuoteStatusDialog(tester);

        expect(
          container
              .read(quotesProvider.notifier)
              .findById('quote-reopen-cycle')!
              .approvedAt,
          DateTime(2026, 7, 13, 12, 0),
        );

        clock.now = DateTime(2026, 7, 13, 13, 0);
        await scrollQuoteDetailUntilVisible(
          tester,
          find.byKey(const Key('quote_detail_reopen_button')),
        );
        await tester.tap(find.byKey(const Key('quote_detail_reopen_button')));
        await tester.pumpAndSettle();
        await confirmQuoteStatusDialog(tester);

        final reopened = container
            .read(quotesProvider.notifier)
            .findById('quote-reopen-cycle')!;
        expect(reopened.status, QuoteStatus.draft);
        expect(reopened.approvedAt, isNull);
        expect(reopened.number, number);
        expect(reopened.createdAt, createdAt);
        expect(reopened.items, items);

        clock.now = DateTime(2026, 7, 13, 14, 0);
        await scrollQuoteDetailUntilVisible(
          tester,
          find.byKey(const Key('quote_detail_mark_sent_button')),
        );
        await tester.tap(
          find.byKey(const Key('quote_detail_mark_sent_button')),
        );
        await tester.pumpAndSettle();
        await confirmQuoteStatusDialog(tester);

        clock.now = DateTime(2026, 7, 13, 15, 0);
        await scrollQuoteDetailUntilVisible(
          tester,
          find.byKey(const Key('quote_detail_approve_button')),
        );
        await tester.tap(find.byKey(const Key('quote_detail_approve_button')));
        await tester.pumpAndSettle();
        await confirmQuoteStatusDialog(tester);

        final finalQuote = container
            .read(quotesProvider.notifier)
            .findById('quote-reopen-cycle')!;
        expect(finalQuote.approvedAt, DateTime(2026, 7, 13, 15, 0));
        expect(finalQuote.statusHistory, hasLength(6));
        expect(finalQuote.statusHistory[2].newStatus, QuoteStatus.approved);
        expect(finalQuote.statusHistory[3].newStatus, QuoteStatus.draft);
        expect(finalQuote.statusHistory.last.newStatus, QuoteStatus.approved);
        await expandQuoteStatusHistory(tester);
        expect(find.text('Enviado → Aprovado'), findsNWidgets(2));
        expect(find.text('Aprovado → Rascunho'), findsOneWidget);
      },
    );
  });
}
