import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/contract_list_summary.dart';

class ContractSummaryCards extends StatelessWidget {
  const ContractSummaryCards({super.key, required this.summary});

  final ContractListSummary summary;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _Card(
          key: const Key('contract_summary_draft'),
          label: 'Rascunho',
          value: '${summary.draft}',
        ),
        _Card(
          key: const Key('contract_summary_sent'),
          label: 'Enviados',
          value: '${summary.sent}',
        ),
        _Card(
          key: const Key('contract_summary_signed'),
          label: 'Assinados',
          value: '${summary.signed}',
        ),
        _Card(
          key: const Key('contract_summary_expired'),
          label: 'Expirados',
          value: '${summary.expired}',
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }
}
