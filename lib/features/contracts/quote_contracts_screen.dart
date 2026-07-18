import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../quotes/utils/quote_date_formatter.dart';
import 'contracts_feedback.dart';
import 'models/contract_status.dart';
import 'providers/contract_template_provider.dart';
import 'providers/quote_contract_provider.dart';

class QuoteContractsScreen extends ConsumerWidget {
  const QuoteContractsScreen({super.key, required this.quoteId});

  final String quoteId;

  String _formatDate(DateTime? value) {
    if (value == null) return '—';
    return QuoteDateFormatter.format(value);
  }

  Future<void> _generate(BuildContext context, WidgetRef ref) async {
    final templates = (ref.read(contractTemplateProvider).value ?? const [])
        .where((template) => template.active)
        .toList();

    String? templateId = templates.isEmpty ? null : templates.first.id;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Gerar contrato'),
              content: templates.isEmpty
                  ? const Text(
                      'Nenhum modelo ativo. O contrato será gerado sem modelo.',
                    )
                  : DropdownButtonFormField<String?>(
                      key: const Key('quote_contract_form_template'),
                      initialValue: templateId,
                      decoration: const InputDecoration(labelText: 'Modelo'),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Sem modelo'),
                        ),
                        for (final template in templates)
                          DropdownMenuItem(
                            value: template.id,
                            child: Text(template.name),
                          ),
                      ],
                      onChanged: (value) => setState(() => templateId = value),
                    ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  key: const Key('quote_contract_form_save'),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Gerar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final result = await ref.read(quoteContractProvider(quoteId).notifier).generate(
          templateId: templateId,
        );
    if (!context.mounted) return;
    if (result.isSuccess) {
      ContractsFeedbackPresenter.showSnackBar(
        ContractsFeedback.contractGenerated,
      );
    } else {
      ContractsFeedbackPresenter.showError(
        ContractsFeedbackPresenter.contractWriteError(result),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(quoteContractProvider(quoteId));
    final summaryAsync = ref.watch(quoteContractSummaryProvider(quoteId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contratos do orçamento'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            key: const Key('quote_contract_generate'),
            icon: const Icon(Icons.add),
            onPressed: () => _generate(context, ref),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          final summary = summaryAsync.value;
          return ListView(
            key: const Key('quote_contract_list'),
            padding: const EdgeInsets.all(24),
            children: [
              AppCard(
                key: const Key('quote_contract_summary_status'),
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Status atual: ${summary?.latestStatus?.label ?? 'Nenhum'}',
                  style: AppTextStyles.titleMedium,
                ),
              ),
              const SizedBox(height: 16),
              if (items.isEmpty)
                const Text('Nenhum contrato associado a este orçamento.')
              else
                for (final item in items) ...[
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.contractNumber,
                                style: AppTextStyles.titleMedium,
                              ),
                              Text('Status: ${item.status.label}'),
                              Text(
                                'Gerado: ${_formatDate(item.generatedAt)} · '
                                'Enviado: ${_formatDate(item.sentAt)} · '
                                'Assinado: ${_formatDate(item.signedAt)}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          key: Key('quote_contract_cancel_${item.id}'),
                          icon: const Icon(Icons.cancel_outlined),
                          onPressed: () async {
                            final result = await ref
                                .read(quoteContractProvider(quoteId).notifier)
                                .cancel(item.id);
                            if (result.isSuccess) {
                              ContractsFeedbackPresenter.showSnackBar(
                                ContractsFeedback.contractCancelled,
                              );
                            } else {
                              ContractsFeedbackPresenter.showError(
                                ContractsFeedbackPresenter.contractWriteError(
                                  result,
                                ),
                              );
                            }
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
