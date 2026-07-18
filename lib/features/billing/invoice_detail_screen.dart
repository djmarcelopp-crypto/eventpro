import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import '../quotes/utils/quote_date_formatter.dart';
import '../quotes/utils/quote_money_display.dart';
import 'billing_feedback.dart';
import 'models/invoice_item.dart';
import 'models/invoice_status.dart';
import 'models/invoice_type.dart';
import 'providers/invoice_provider.dart';
import 'providers/invoice_workflow_provider.dart';

class InvoiceDetailScreen extends ConsumerStatefulWidget {
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  final String invoiceId;

  @override
  ConsumerState<InvoiceDetailScreen> createState() =>
      _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends ConsumerState<InvoiceDetailScreen> {
  late Future<List<InvoiceItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture =
        ref.read(invoiceProvider.notifier).loadItems(widget.invoiceId);
  }

  String _formatDate(DateTime? value) {
    if (value == null) return 'Não informado';
    return QuoteDateFormatter.format(value);
  }

  Future<void> _reloadItems() async {
    setState(() {
      _itemsFuture =
          ref.read(invoiceProvider.notifier).loadItems(widget.invoiceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoice = ref.watch(invoiceProvider).value
        ?.where((item) => item.id == widget.invoiceId)
        .firstOrNull;

    if (invoice == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Faturamento')),
        body: const Center(child: Text('Faturamento não encontrado')),
      );
    }

    final workflow =
        ref.watch(invoiceWorkflowSummaryProvider(widget.invoiceId)).value;
    final canIssue = workflow?.canIssue ?? false;
    final canMarkPaid = workflow?.canMarkPaid ?? false;
    final canCancel = workflow?.canCancel ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(invoice.invoiceNumber),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          AppCard(
            key: const Key('invoice_detail_card'),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.invoiceNumber,
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text('Status: ${invoice.status.label}'),
                Text('Tipo: ${invoice.type.label}'),
                Text('Orçamento: ${invoice.quoteId}'),
                Text('Emitida em: ${_formatDate(invoice.issueDate)}'),
                Text('Vencimento: ${_formatDate(invoice.dueDate)}'),
                Text('Paga em: ${_formatDate(invoice.paidAt)}'),
                const SizedBox(height: 8),
                Text(
                  'Subtotal: ${QuoteMoneyDisplay.format(invoice.subtotalCents)}',
                ),
                Text(
                  'Impostos: ${QuoteMoneyDisplay.format(invoice.taxCents)}',
                ),
                Text(
                  'Desconto: ${QuoteMoneyDisplay.format(invoice.discountCents)}',
                ),
                Text(
                  'Total: ${QuoteMoneyDisplay.format(invoice.totalCents)}',
                  style: AppTextStyles.titleMedium,
                ),
                if (invoice.notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(invoice.notes),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Itens', style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          FutureBuilder<List<InvoiceItem>>(
            future: _itemsFuture,
            builder: (context, snapshot) {
              final items = snapshot.data ?? const <InvoiceItem>[];
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (items.isEmpty) {
                return const Text('Nenhum item');
              }
              return Column(
                key: const Key('invoice_detail_items'),
                children: [
                  for (final item in items) ...[
                    AppCard(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.description,
                              style: AppTextStyles.titleMedium),
                          Text(
                            '${item.quantity} × '
                            '${QuoteMoneyDisplay.format(item.unitPriceCents)} = '
                            '${QuoteMoneyDisplay.format(item.totalPriceCents)}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              );
            },
          ),
          if (canIssue) ...[
            const SizedBox(height: 16),
            PrimaryButton(
              key: const Key('invoice_detail_issue'),
              label: 'Emitir',
              onPressed: () async {
                final result = await ref
                    .read(invoiceProvider.notifier)
                    .issueInvoice(invoice.id);
                if (result.isSuccess) {
                  BillingFeedbackPresenter.showSnackBar(
                    BillingFeedback.invoiceIssued,
                  );
                  await _reloadItems();
                } else {
                  BillingFeedbackPresenter.showError(
                    BillingFeedbackPresenter.invoiceWriteError(result),
                  );
                }
              },
            ),
          ],
          if (canMarkPaid) ...[
            const SizedBox(height: 16),
            PrimaryButton(
              key: const Key('invoice_detail_mark_paid'),
              label: 'Registrar pagamento',
              onPressed: () async {
                final result =
                    await ref.read(invoiceProvider.notifier).markPaid(invoice.id);
                if (result.isSuccess) {
                  BillingFeedbackPresenter.showSnackBar(
                    BillingFeedback.invoicePaid,
                  );
                } else {
                  BillingFeedbackPresenter.showError(
                    BillingFeedbackPresenter.invoiceWriteError(result),
                  );
                }
              },
            ),
          ],
          if (canCancel) ...[
            const SizedBox(height: 16),
            PrimaryButton(
              key: const Key('invoice_detail_cancel'),
              label: 'Cancelar faturamento',
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Cancelar faturamento'),
                      content: Text('Cancelar "${invoice.invoiceNumber}"?'),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          child: const Text('Voltar'),
                        ),
                        TextButton(
                          key: const Key('invoice_cancel_confirm'),
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ],
                    );
                  },
                );
                if (confirmed != true) return;
                final result = await ref
                    .read(invoiceProvider.notifier)
                    .cancelInvoice(invoice.id);
                if (result.isSuccess) {
                  BillingFeedbackPresenter.showSnackBar(
                    BillingFeedback.invoiceCancelled,
                  );
                  if (context.mounted) context.pop();
                } else {
                  BillingFeedbackPresenter.showError(
                    BillingFeedbackPresenter.invoiceWriteError(result),
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
