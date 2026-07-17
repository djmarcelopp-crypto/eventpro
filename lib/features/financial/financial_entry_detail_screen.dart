import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../quotes/providers/quotes_provider.dart';
import 'financial_feedback.dart';
import 'models/financial_entry_status.dart';
import 'models/financial_flow_kind.dart';
import 'providers/financial_categories_provider.dart';
import 'providers/financial_entries_provider.dart';
import 'utils/financial_display_formatter.dart';

class FinancialEntryDetailScreen extends ConsumerWidget {
  const FinancialEntryDetailScreen({super.key, required this.entryId});

  final String entryId;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final entry = ref.read(financialEntriesProvider.notifier).findById(entryId);
    if (entry == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir lançamento'),
          content: Text(
            'Excluir "${entry.description}"? Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: const Key('financial_entry_delete_confirm_button'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final result = await ref
        .read(financialEntriesProvider.notifier)
        .deleteEntry(entryId);

    if (!context.mounted) {
      return;
    }

    if (!result.isDeleted) {
      FinancialFeedbackPresenter.showError(
        FinancialFeedbackPresenter.entryDeleteError(result),
      );
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }
      context.go(AppRoutes.financial);
      FinancialFeedbackPresenter.showSnackBar(FinancialFeedback.entryDeleted);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(financialEntriesProvider);
    final entry = entriesAsync.value
        ?.where((item) => item.id == entryId)
        .firstOrNull;
    final category = entry == null
        ? null
        : ref
              .watch(financialCategoriesProvider)
              .value
              ?.where((item) => item.id == entry.categoryId)
              .firstOrNull;
    final quote = entry?.quoteId == null
        ? null
        : ref.read(quotesProvider.notifier).findById(entry!.quoteId!);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Detalhe do lançamento',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          if (entry != null) ...[
            IconButton(
              key: const Key('financial_entry_edit_button'),
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Editar',
              onPressed: () =>
                  context.push(AppRoutes.financialEdit(entryId)),
            ),
            IconButton(
              key: const Key('financial_entry_delete_button'),
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Excluir',
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ],
      ),
      body: entry == null
          ? Center(
              child: Text(
                'Lançamento não encontrado.',
                style: AppTextStyles.bodyLarge,
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.description, style: AppTextStyles.titleMedium),
                          const SizedBox(height: 12),
                          _DetailRow(
                            label: 'Tipo',
                            value: entry.kind.label,
                            valueColor: entry.kind.color,
                          ),
                          _DetailRow(
                            label: 'Valor',
                            value: FinancialDisplayFormatter.money(
                              entry.amountCents,
                            ),
                            valueColor: entry.kind.color,
                          ),
                          _DetailRow(
                            label: 'Data',
                            value: FinancialDisplayFormatter.civilDate(
                              entry.date,
                            ),
                          ),
                          _DetailRow(
                            label: 'Status',
                            value: entry.status.label,
                            valueColor: entry.status.color,
                          ),
                          _DetailRow(
                            label: 'Categoria',
                            value: category?.name ?? '—',
                          ),
                          _DetailRow(
                            label: 'Orçamento',
                            value: quote == null
                                ? 'Sem vínculo'
                                : quote.number,
                          ),
                          if (entry.notes != null &&
                              entry.notes!.trim().isNotEmpty)
                            _DetailRow(
                              label: 'Observações',
                              value: entry.notes!,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.mutedWhite,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyLarge.copyWith(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}
