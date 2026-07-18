import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../catalog/utils/brazilian_currency_input_formatter.dart';
import '../quotes/providers/quotes_provider.dart';
import '../quotes/utils/quote_money_display.dart';
import 'financial_feedback.dart';
import 'models/financial_category.dart';
import 'models/financial_entry.dart';
import 'models/financial_entry_status.dart';
import 'models/financial_flow_kind.dart';
import 'providers/financial_categories_provider.dart';
import 'providers/financial_entries_provider.dart';
import 'utils/financial_display_formatter.dart';
import 'widgets/financial_quote_selector.dart';

class NewFinancialEntryScreen extends ConsumerStatefulWidget {
  const NewFinancialEntryScreen({super.key, this.entryId});

  final String? entryId;

  @override
  ConsumerState<NewFinancialEntryScreen> createState() =>
      _NewFinancialEntryScreenState();
}

class _NewFinancialEntryScreenState
    extends ConsumerState<NewFinancialEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  FinancialFlowKind _kind = FinancialFlowKind.expense;
  FinancialEntryStatus _status = FinancialEntryStatus.pending;
  DateTime _date = DateTime.now();
  String? _categoryId;
  String? _quoteId;
  var _isSaving = false;
  var _initializedForEdit = false;

  bool get _isEditing => widget.entryId != null;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tryInitializeForEdit();
  }

  void _tryInitializeForEdit() {
    if (!_isEditing || _initializedForEdit) {
      return;
    }
    final entry = ref
        .read(financialEntriesProvider.notifier)
        .findById(widget.entryId!);
    if (entry == null) {
      return;
    }
    _initializedForEdit = true;
    _descriptionController.text = entry.description;
    _amountController.text = QuoteMoneyDisplay.formatForInput(entry.amountCents);
    _notesController.text = entry.notes ?? '';
    _kind = entry.kind;
    _status = entry.status;
    _date = entry.date;
    _categoryId = entry.categoryId;
    _quoteId = entry.quoteId;
  }

  List<FinancialCategory> _compatibleCategories(
    List<FinancialCategory> categories,
  ) {
    return categories
        .where((category) => category.kind == _kind && category.active)
        .toList(growable: false);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickQuote() async {
    final quotes = ref.read(quotesProvider);
    final selected = await showFinancialQuoteSelector(
      context: context,
      quotes: quotes,
      selectedQuoteId: _quoteId,
    );
    if (selected != null) {
      setState(() => _quoteId = selected.id);
    }
  }

  Future<void> _onSave() async {
    if (_isSaving) {
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_categoryId == null) {
      FinancialFeedbackPresenter.showError('Selecione uma categoria.');
      return;
    }

    final amountCents = QuoteMoneyDisplay.parseToCents(_amountController.text);
    if (amountCents == null) {
      FinancialFeedbackPresenter.showError('Informe um valor válido.');
      return;
    }

    setState(() => _isSaving = true);

    final now = DateTime.now();
    final draft = FinancialEntry(
      id: widget.entryId ?? '',
      kind: _kind,
      description: _descriptionController.text.trim(),
      amountCents: amountCents,
      date: DateTime(_date.year, _date.month, _date.day),
      categoryId: _categoryId!,
      status: _status,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      quoteId: _quoteId,
      createdAt: now,
      updatedAt: now,
    );

    final notifier = ref.read(financialEntriesProvider.notifier);
    final result = _isEditing
        ? await notifier.updateEntry(draft)
        : await notifier.addEntry(draft);

    if (!mounted) {
      return;
    }

    setState(() => _isSaving = false);

    if (!result.isSuccess) {
      FinancialFeedbackPresenter.showError(
        FinancialFeedbackPresenter.entryWriteError(result),
      );
      return;
    }

    // Defer navigation to the next frame so Riverpod can finish notifying
    // listeners outside an active build/overlay update (GoRouter + TickerMode).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (_isEditing) {
        context.go(AppRoutes.financial);
        FinancialFeedbackPresenter.showSnackBar(FinancialFeedback.entryUpdated);
      } else {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(financialCategoriesProvider);
    final quotes = ref.watch(quotesProvider);
    final quote = _quoteId == null
        ? null
        : quotes.where((item) => item.id == _quoteId).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isSaving ? null : () => context.pop(),
        ),
        title: Text(
          _isEditing ? 'Editar lançamento' : 'Novo lançamento',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: categoriesAsync.when(
        data: (categories) {
          final compatible = _compatibleCategories(categories);

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Tipo', style: AppTextStyles.titleMedium),
                        const SizedBox(height: 8),
                        SegmentedButton<FinancialFlowKind>(
                          key: const Key('financial_entry_kind'),
                          segments: [
                            for (final kind in FinancialFlowKind.values)
                              ButtonSegment(
                                value: kind,
                                label: Text(kind.label),
                              ),
                          ],
                          selected: {_kind},
                          onSelectionChanged: _isSaving
                              ? null
                              : (selection) {
                                  setState(() {
                                    _kind = selection.first;
                                    _categoryId = null;
                                  });
                                },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          key: const Key('financial_entry_description'),
                          label: 'Descrição',
                          controller: _descriptionController,
                          enabled: !_isSaving,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Informe a descrição.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          key: const Key('financial_entry_amount'),
                          label: 'Valor',
                          controller: _amountController,
                          enabled: !_isSaving,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            BrazilianCurrencyInputFormatter(),
                          ],
                          validator: (value) {
                            if (QuoteMoneyDisplay.parseToCents(value) == null) {
                              return 'Informe um valor válido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Data',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: InkWell(
                            key: const Key('financial_entry_date'),
                            onTap: _isSaving ? null : _pickDate,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                FinancialDisplayFormatter.civilDate(_date),
                                style: AppTextStyles.bodyLarge,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        KeyedSubtree(
                          key: const Key('financial_entry_category'),
                          child: DropdownButtonFormField<String>(
                            key: ValueKey(
                              'financial_entry_category_${_kind.name}_${_categoryId ?? 'none'}',
                            ),
                            initialValue: compatible.any(
                              (category) => category.id == _categoryId,
                            )
                                ? _categoryId
                                : null,
                            decoration: const InputDecoration(
                              labelText: 'Categoria',
                            ),
                            items: [
                              for (final category in compatible)
                                DropdownMenuItem(
                                  value: category.id,
                                  child: Text(category.name),
                                ),
                            ],
                            onChanged: _isSaving
                                ? null
                                : (value) =>
                                    setState(() => _categoryId = value),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Selecione uma categoria.';
                              }
                              return null;
                            },
                          ),
                        ),
                        if (compatible.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Nenhuma categoria ativa para este tipo. '
                            'Crie uma em Categorias.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Text('Status', style: AppTextStyles.titleMedium),
                        const SizedBox(height: 8),
                        SegmentedButton<FinancialEntryStatus>(
                          key: const Key('financial_entry_status'),
                          segments: [
                            for (final status in FinancialEntryStatus.values)
                              ButtonSegment(
                                value: status,
                                label: Text(status.label),
                              ),
                          ],
                          selected: {_status},
                          onSelectionChanged: _isSaving
                              ? null
                              : (selection) {
                                  setState(() => _status = selection.first);
                                },
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          key: const Key('financial_entry_quote'),
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            quote == null
                                ? 'Orçamento (opcional)'
                                : quote.number,
                            style: AppTextStyles.bodyLarge,
                          ),
                          subtitle: Text(
                            quote == null
                                ? 'Sem vínculo com evento/orçamento'
                                : (quote.eventSnapshot.name?.trim().isNotEmpty ==
                                          true
                                      ? quote.eventSnapshot.name!
                                      : quote.clientSnapshot.displayName),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_quoteId != null)
                                IconButton(
                                  key: const Key(
                                    'financial_entry_clear_quote',
                                  ),
                                  icon: const Icon(Icons.clear),
                                  onPressed: _isSaving
                                      ? null
                                      : () => setState(() => _quoteId = null),
                                ),
                              IconButton(
                                icon: const Icon(Icons.link),
                                onPressed: _isSaving ? null : _pickQuote,
                              ),
                            ],
                          ),
                          onTap: _isSaving ? null : _pickQuote,
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          key: const Key('financial_entry_notes'),
                          label: 'Observações',
                          controller: _notesController,
                          enabled: !_isSaving,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          key: const Key('financial_entry_save_button'),
                          label: 'Salvar',
                          isLoading: _isSaving,
                          onPressed: _onSave,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Text(
            'Não foi possível carregar as categorias.',
            style: AppTextStyles.bodyLarge,
          ),
        ),
      ),
    );
  }
}
