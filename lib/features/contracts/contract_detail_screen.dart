import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import '../quotes/utils/quote_date_formatter.dart';
import 'contracts_feedback.dart';
import 'models/contract_status.dart';
import 'providers/contract_provider.dart';
import 'providers/contract_workflow_provider.dart';

class ContractDetailScreen extends ConsumerWidget {
  const ContractDetailScreen({super.key, required this.contractId});

  final String contractId;

  String _formatDate(DateTime? value) {
    if (value == null) return 'Não informado';
    return QuoteDateFormatter.format(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(contractProvider).value
        ?.where((item) => item.id == contractId)
        .firstOrNull;

    if (contract == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Contrato')),
        body: const Center(child: Text('Contrato não encontrado')),
      );
    }

    final workflow = ref.watch(contractWorkflowSummaryProvider(contractId)).value;
    final canCancel = workflow?.canCancel ?? false;
    final canMarkSent = workflow?.canMarkSent ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(contract.contractNumber),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          AppCard(
            key: const Key('contract_detail_card'),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contract.contractNumber, style: AppTextStyles.headlineMedium),
                const SizedBox(height: 8),
                Text('Status: ${contract.status.label}'),
                Text('Orçamento: ${contract.quoteId}'),
                Text('Gerado em: ${_formatDate(contract.generatedAt)}'),
                Text('Enviado em: ${_formatDate(contract.sentAt)}'),
                Text('Assinado em: ${_formatDate(contract.signedAt)}'),
                Text('Expira em: ${_formatDate(contract.expiresAt)}'),
                if (contract.notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(contract.notes),
                ],
              ],
            ),
          ),
          if (canMarkSent) ...[
            const SizedBox(height: 16),
            PrimaryButton(
              key: const Key('contract_detail_mark_sent'),
              label: 'Marcar como enviado',
              onPressed: () async {
                final result = await ref
                    .read(contractProvider.notifier)
                    .markSent(contract.id);
                if (result.isSuccess) {
                  ContractsFeedbackPresenter.showSnackBar(
                    ContractsFeedback.contractSent,
                  );
                } else {
                  ContractsFeedbackPresenter.showError(
                    ContractsFeedbackPresenter.contractWriteError(result),
                  );
                }
              },
            ),
          ],
          if (canCancel) ...[
            const SizedBox(height: 16),
            PrimaryButton(
              key: const Key('contract_detail_cancel'),
              label: 'Cancelar contrato',
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Cancelar contrato'),
                      content: Text(
                        'Cancelar "${contract.contractNumber}"?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          child: const Text('Voltar'),
                        ),
                        TextButton(
                          key: const Key('contract_cancel_confirm'),
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
                    .read(contractProvider.notifier)
                    .cancelContract(contract.id);
                if (result.isSuccess) {
                  ContractsFeedbackPresenter.showSnackBar(
                    ContractsFeedback.contractCancelled,
                  );
                  if (context.mounted) context.pop();
                } else {
                  ContractsFeedbackPresenter.showError(
                    ContractsFeedbackPresenter.contractWriteError(result),
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
