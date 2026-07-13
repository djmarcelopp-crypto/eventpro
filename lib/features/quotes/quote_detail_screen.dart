import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import 'models/quote.dart';
import 'models/quote_line_item.dart';
import 'models/quote_status.dart';
import 'providers/quotes_provider.dart';
import 'quote_list_feedback.dart';
import 'utils/quote_detail_presenter.dart';
import 'utils/quotes_navigation.dart';
import 'widgets/quote_detail_row.dart';
import 'widgets/quote_detail_section.dart';
import 'widgets/quote_not_found_state.dart';
import 'widgets/quote_status_actions.dart';
import 'widgets/quote_status_badge.dart';
import 'widgets/quote_status_history_list.dart';

class QuoteDetailScreen extends ConsumerStatefulWidget {
  const QuoteDetailScreen({
    super.key,
    required this.quoteId,
  });

  final String quoteId;

  @override
  ConsumerState<QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends ConsumerState<QuoteDetailScreen> {
  static const _maxContentWidth = 720.0;

  bool _transitioning = false;

  Future<bool?> _confirmTransition({
    required String title,
    required String content,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              key: const Key('quote_status_dialog_cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: const Key('quote_status_dialog_confirm'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _transitionStatus({
    required QuoteStatus target,
    required String dialogTitle,
    required String dialogContent,
    required QuoteListFeedback successFeedback,
  }) async {
    if (_transitioning) {
      return;
    }

    final confirmed = await _confirmTransition(
      title: dialogTitle,
      content: dialogContent,
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _transitioning = true;
    });

    try {
      final success = ref
          .read(quotesProvider.notifier)
          .transitionStatus(widget.quoteId, target);

      if (!mounted) {
        return;
      }

      if (!success) {
        QuoteListFeedbackPresenter.showSnackBar(
          QuoteListFeedback.statusChangeFailed,
        );
        return;
      }

      QuoteListFeedbackPresenter.showSnackBar(successFeedback);
    } finally {
      if (mounted) {
        setState(() {
          _transitioning = false;
        });
      }
    }
  }

  Future<void> _openEdit() async {
    if (_transitioning) {
      return;
    }

    final updated = await context.push<bool>(
      AppRoutes.quotesEdit(widget.quoteId),
    );

    if (updated == true && mounted) {
      QuoteListFeedbackPresenter.showSnackBar(QuoteListFeedback.updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quotes = ref.watch(quotesProvider);
    Quote? quote;
    for (final item in quotes) {
      if (item.id == widget.quoteId) {
        quote = item;
        break;
      }
    }

    if (quote == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Voltar',
            onPressed: () => QuotesNavigation.leaveQuoteDetail(context),
          ),
          title: Text(
            'Orçamento',
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
          ),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
        body: QuoteNotFoundState(
          onBack: () => QuotesNavigation.leaveQuoteDetail(context),
        ),
      );
    }

    final resolvedQuote = quote;
    final headerItems = QuoteDetailPresenter.headerItems(resolvedQuote);
    final clientItems =
        QuoteDetailPresenter.clientItems(resolvedQuote.clientSnapshot);
    final eventItems =
        QuoteDetailPresenter.eventItems(resolvedQuote.eventSnapshot);
    final financialItems = QuoteDetailPresenter.financialItems(resolvedQuote);
    final notes = resolvedQuote.notes?.trim();
    final internalNotes = resolvedQuote.internalNotes?.trim();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => QuotesNavigation.leaveQuoteDetail(context),
        ),
        title: Text(
          resolvedQuote.number,
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            key: const Key('quote_detail_scroll'),
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              resolvedQuote.number,
                              style: AppTextStyles.titleMedium,
                            ),
                          ),
                          QuoteStatusBadge(status: resolvedQuote.status),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    QuoteDetailSection(
                      title: 'Informações gerais',
                      items: headerItems,
                    ),
                    const SizedBox(height: 16),
                    QuoteDetailSection(
                      title: 'Cliente',
                      items: clientItems,
                    ),
                    if (eventItems.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      QuoteDetailSection(
                        title: 'Evento',
                        items: eventItems,
                      ),
                    ],
                    const SizedBox(height: 16),
                    _ItemsSection(items: resolvedQuote.items),
                    const SizedBox(height: 16),
                    QuoteDetailSection(
                      title: 'Financeiro',
                      items: financialItems,
                    ),
                    if (notes != null && notes.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      QuoteDetailSection(
                        title: 'Observações para o cliente',
                        items: [
                          QuoteDetailItem(label: 'Texto', value: notes),
                        ],
                      ),
                    ],
                    if (internalNotes != null && internalNotes.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      QuoteDetailSection(
                        title: 'Observações internas',
                        items: [
                          QuoteDetailItem(
                            label: 'Uso interno',
                            value: internalNotes,
                          ),
                        ],
                        footer: Row(
                          children: [
                            const Icon(
                              Icons.lock_outline,
                              size: 16,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Não aparece em PDF, contrato ou materiais '
                                'compartilhados com o cliente.',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.warning,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    QuoteStatusHistoryList(
                      entries: resolvedQuote.statusHistory,
                    ),
                    const SizedBox(height: 24),
                    QuoteStatusActions(
                      quote: resolvedQuote,
                      transitioning: _transitioning,
                      onEdit: resolvedQuote.status == QuoteStatus.draft
                          ? _openEdit
                          : null,
                      onMarkAsSent: resolvedQuote.status == QuoteStatus.draft
                          ? () => _transitionStatus(
                                target: QuoteStatus.sent,
                                dialogTitle: 'Marcar orçamento como enviado?',
                                dialogContent:
                                    'O orçamento será registrado como enviado. '
                                    'Esta ação não envia e-mail nem WhatsApp.',
                                successFeedback: QuoteListFeedback.markedAsSent,
                              )
                          : null,
                      onApprove: resolvedQuote.status == QuoteStatus.sent
                          ? () => _transitionStatus(
                                target: QuoteStatus.approved,
                                dialogTitle: 'Aprovar orçamento?',
                                dialogContent:
                                    'O orçamento será marcado como aprovado. '
                                    'Nenhum contrato será gerado automaticamente.',
                                successFeedback: QuoteListFeedback.approved,
                              )
                          : null,
                      onReject: resolvedQuote.status == QuoteStatus.sent
                          ? () => _transitionStatus(
                                target: QuoteStatus.rejected,
                                dialogTitle: 'Recusar orçamento?',
                                dialogContent:
                                    'O orçamento será marcado como recusado.',
                                successFeedback: QuoteListFeedback.rejected,
                              )
                          : null,
                      onReopenForEditing:
                          resolvedQuote.status == QuoteStatus.approved
                              ? () => _transitionStatus(
                                    target: QuoteStatus.draft,
                                    dialogTitle: 'Reabrir orçamento para edição?',
                                    dialogContent:
                                        'Ao reabrir, este orçamento voltará para '
                                        'Rascunho e deverá ser enviado e aprovado '
                                        'novamente.',
                                    successFeedback:
                                        QuoteListFeedback.reopenedForEditing,
                                  )
                              : null,
                      onCancel: resolvedQuote.status == QuoteStatus.draft ||
                              resolvedQuote.status == QuoteStatus.sent ||
                              resolvedQuote.status == QuoteStatus.approved
                          ? () => _transitionStatus(
                                target: QuoteStatus.cancelled,
                                dialogTitle: 'Cancelar orçamento?',
                                dialogContent:
                                    'O orçamento será marcado como cancelado.',
                                successFeedback: QuoteListFeedback.cancelled,
                              )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ItemsSection extends StatelessWidget {
  const _ItemsSection({required this.items});

  final List<QuoteLineItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Itens', style: AppTextStyles.titleSmall),
          const SizedBox(height: 12),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: 24),
            _ItemCard(item: items[i]),
          ],
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item});

  final QuoteLineItem item;

  @override
  Widget build(BuildContext context) {
    final lineItems = QuoteLinePresenter.lineItems(item);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          QuoteLinePresenter.lineTitle(item),
          style: AppTextStyles.titleSmall,
        ),
        const SizedBox(height: 8),
        for (final lineItem in lineItems)
          QuoteDetailRow(
            label: lineItem.label,
            value: lineItem.value,
          ),
      ],
    );
  }
}
