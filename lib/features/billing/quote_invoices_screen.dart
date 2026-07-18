import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../quotes/utils/quote_money_display.dart';
import 'billing_feedback.dart';
import 'models/invoice_item_input.dart';
import 'models/invoice_status.dart';
import 'models/invoice_type.dart';
import 'providers/invoice_financial_summary_provider.dart';
import 'providers/invoice_workflow_provider.dart';
import 'providers/quote_invoice_provider.dart';

class QuoteInvoicesScreen extends ConsumerWidget {
  const QuoteInvoicesScreen({super.key, required this.quoteId});

  final String quoteId;

  Future<void> _generate(BuildContext context, WidgetRef ref) async {
    final values = await showDialog<_QuoteInvoiceGenerateValues>(
      context: context,
      builder: (context) => const _QuoteInvoiceGenerateDialog(),
    );
    if (values == null || !context.mounted) return;

    final quantity = double.tryParse(values.quantityText.replaceAll(',', '.'));
    final unitPrice =
        QuoteMoneyDisplay.parseNonNegativeCents(values.priceText);
    if (quantity == null || unitPrice == null) {
      BillingFeedbackPresenter.showError('Verifique quantidade e preço');
      return;
    }

    final result = await ref.read(quoteInvoiceProvider(quoteId).notifier).generate(
          type: InvoiceType.service,
          items: [
            InvoiceItemInput(
              description: values.description,
              quantity: quantity,
              unitPriceCents: unitPrice,
            ),
          ],
        );
    if (!context.mounted) return;
    if (result.isSuccess) {
      BillingFeedbackPresenter.showSnackBar(BillingFeedback.invoiceIssued);
    } else {
      BillingFeedbackPresenter.showError(
        BillingFeedbackPresenter.invoiceWriteError(result),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(quoteInvoiceProvider(quoteId));
    final summaryAsync = ref.watch(quoteInvoiceSummaryProvider(quoteId));
    final financialAsync = ref.watch(invoiceFinancialSummaryProvider(quoteId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faturamentos do orçamento'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            key: const Key('quote_invoice_generate'),
            icon: const Icon(Icons.add),
            onPressed: () => _generate(context, ref),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          final summary = summaryAsync.value;
          final financial = financialAsync.value;
          return ListView(
            key: const Key('quote_invoice_list'),
            padding: const EdgeInsets.all(24),
            children: [
              AppCard(
                key: const Key('quote_invoice_summary_status'),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status atual: ${summary?.latestStatus?.label ?? 'Nenhum'}',
                      style: AppTextStyles.titleMedium,
                    ),
                    if (financial != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Faturado: ${QuoteMoneyDisplay.format(financial.totalBilledCents)} · '
                        'Pago: ${QuoteMoneyDisplay.format(financial.totalPaidCents)} · '
                        'Pendente: ${QuoteMoneyDisplay.format(financial.totalPendingCents)}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (items.isEmpty)
                const Text('Nenhum faturamento associado a este orçamento.')
              else
                for (final item in items) ...[
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          key: Key('quote_invoice_open_${item.id}'),
                          onTap: () => context.push(
                            AppRoutes.invoiceDetail(item.id),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.invoiceNumber,
                                style: AppTextStyles.titleMedium,
                              ),
                              Text('Status: ${item.status.label}'),
                              Text(
                                'Subtotal ${QuoteMoneyDisplay.format(item.subtotalCents)} · '
                                'Impostos ${QuoteMoneyDisplay.format(item.taxCents)} · '
                                'Desconto ${QuoteMoneyDisplay.format(item.discountCents)} · '
                                'Total ${QuoteMoneyDisplay.format(item.totalCents)}',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Builder(
                          builder: (context) {
                            final workflow = ref
                                .watch(invoiceWorkflowSummaryProvider(item.id))
                                .value;
                            return Wrap(
                              spacing: 8,
                              children: [
                                if (workflow?.canIssue ?? false)
                                  TextButton(
                                    key: Key('quote_invoice_issue_${item.id}'),
                                    onPressed: () async {
                                      final result = await ref
                                          .read(
                                            quoteInvoiceProvider(quoteId)
                                                .notifier,
                                          )
                                          .issue(item.id);
                                      if (result.isSuccess) {
                                        BillingFeedbackPresenter.showSnackBar(
                                          BillingFeedback.invoiceIssued,
                                        );
                                      }
                                    },
                                    child: const Text('Emitir'),
                                  ),
                                if (workflow?.canMarkPaid ?? false)
                                  TextButton(
                                    key: Key('quote_invoice_pay_${item.id}'),
                                    onPressed: () async {
                                      final result = await ref
                                          .read(
                                            quoteInvoiceProvider(quoteId)
                                                .notifier,
                                          )
                                          .registerPayment(item.id);
                                      if (result.isSuccess) {
                                        BillingFeedbackPresenter.showSnackBar(
                                          BillingFeedback.invoicePaid,
                                        );
                                      }
                                    },
                                    child: const Text('Pagar'),
                                  ),
                                if (workflow?.canCancel ?? false)
                                  TextButton(
                                    key:
                                        Key('quote_invoice_cancel_${item.id}'),
                                    onPressed: () async {
                                      final result = await ref
                                          .read(
                                            quoteInvoiceProvider(quoteId)
                                                .notifier,
                                          )
                                          .cancel(item.id);
                                      if (result.isSuccess) {
                                        BillingFeedbackPresenter.showSnackBar(
                                          BillingFeedback.invoiceCancelled,
                                        );
                                      }
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
      ),
    );
  }
}

class _QuoteInvoiceGenerateValues {
  const _QuoteInvoiceGenerateValues({
    required this.description,
    required this.quantityText,
    required this.priceText,
  });

  final String description;
  final String quantityText;
  final String priceText;
}

class _QuoteInvoiceGenerateDialog extends StatefulWidget {
  const _QuoteInvoiceGenerateDialog();

  @override
  State<_QuoteInvoiceGenerateDialog> createState() =>
      _QuoteInvoiceGenerateDialogState();
}

class _QuoteInvoiceGenerateDialogState
    extends State<_QuoteInvoiceGenerateDialog> {
  late final TextEditingController _descriptionController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: 'Serviço');
    _quantityController = TextEditingController(text: '1');
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Gerar faturamento'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('quote_invoice_form_description'),
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              key: const Key('quote_invoice_form_quantity'),
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              key: const Key('quote_invoice_form_price'),
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Preço unitário'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          key: const Key('quote_invoice_form_save'),
          onPressed: () {
            Navigator.pop(
              context,
              _QuoteInvoiceGenerateValues(
                description: _descriptionController.text,
                quantityText: _quantityController.text,
                priceText: _priceController.text,
              ),
            );
          },
          child: const Text('Gerar'),
        ),
      ],
    );
  }
}
