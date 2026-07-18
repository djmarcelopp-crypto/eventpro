import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../quotes/utils/quote_money_display.dart';
import 'billing_feedback.dart';
import 'models/invoice_item_input.dart';
import 'models/invoice_type.dart';
import 'providers/invoice_provider.dart';

class NewInvoiceScreen extends ConsumerStatefulWidget {
  const NewInvoiceScreen({super.key, this.initialQuoteId});

  final String? initialQuoteId;

  @override
  ConsumerState<NewInvoiceScreen> createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends ConsumerState<NewInvoiceScreen> {
  late final TextEditingController _quoteIdController;
  late final TextEditingController _numberController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _quantityController;
  late final TextEditingController _unitPriceController;
  late final TextEditingController _taxController;
  late final TextEditingController _discountController;
  late final TextEditingController _notesController;
  InvoiceType _type = InvoiceType.service;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _quoteIdController =
        TextEditingController(text: widget.initialQuoteId ?? '');
    _numberController = TextEditingController();
    _descriptionController = TextEditingController();
    _quantityController = TextEditingController(text: '1');
    _unitPriceController = TextEditingController();
    _taxController = TextEditingController(text: '0');
    _discountController = TextEditingController(text: '0');
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _quoteIdController.dispose();
    _numberController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _taxController.dispose();
    _discountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final quantity = double.tryParse(_quantityController.text.replaceAll(',', '.'));
    final unitPrice =
        QuoteMoneyDisplay.parseNonNegativeCents(_unitPriceController.text);
    final tax = QuoteMoneyDisplay.parseNonNegativeCents(_taxController.text);
    final discount =
        QuoteMoneyDisplay.parseNonNegativeCents(_discountController.text);

    if (quantity == null || unitPrice == null || tax == null || discount == null) {
      BillingFeedbackPresenter.showError('Verifique quantidade e valores');
      return;
    }

    setState(() => _saving = true);
    final number = _numberController.text.trim();
    final result = await ref.read(invoiceProvider.notifier).createInvoice(
          quoteId: _quoteIdController.text.trim(),
          type: _type,
          invoiceNumber: number.isEmpty ? null : number,
          taxCents: tax,
          discountCents: discount,
          notes: _notesController.text,
          items: [
            InvoiceItemInput(
              description: _descriptionController.text,
              quantity: quantity,
              unitPriceCents: unitPrice,
            ),
          ],
        );
    if (!mounted) return;
    setState(() => _saving = false);

    if (result.isSuccess) {
      BillingFeedbackPresenter.showSnackBar(BillingFeedback.invoiceCreated);
      context.pop();
    } else {
      BillingFeedbackPresenter.showError(
        BillingFeedbackPresenter.invoiceWriteError(result),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo faturamento'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Dados', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('invoice_form_quote_id'),
            label: 'ID do orçamento',
            controller: _quoteIdController,
          ),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('invoice_form_number'),
            label: 'Número (opcional)',
            controller: _numberController,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<InvoiceType>(
            key: const Key('invoice_form_type'),
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Tipo'),
            items: [
              for (final type in InvoiceType.values)
                DropdownMenuItem(value: type, child: Text(type.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _type = value);
            },
          ),
          const SizedBox(height: 24),
          Text('Item', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('invoice_form_description'),
            label: 'Descrição',
            controller: _descriptionController,
          ),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('invoice_form_quantity'),
            label: 'Quantidade',
            controller: _quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('invoice_form_unit_price'),
            label: 'Preço unitário',
            controller: _unitPriceController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('invoice_form_tax'),
            label: 'Impostos',
            controller: _taxController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('invoice_form_discount'),
            label: 'Desconto',
            controller: _discountController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('invoice_form_notes'),
            label: 'Observações',
            controller: _notesController,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            key: const Key('invoice_form_save'),
            label: _saving ? 'Salvando...' : 'Criar faturamento',
            onPressed: _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}
