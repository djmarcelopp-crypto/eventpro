import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../quotes/utils/quote_money_display.dart';
import '../models/quote_team_member.dart';
import '../models/quote_team_summary.dart';

class QuoteTeamSummaryCards extends StatelessWidget {
  const QuoteTeamSummaryCards({super.key, required this.summary});

  final QuoteTeamSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Card(
            key: const Key('quote_team_summary_lines'),
            label: 'Colaboradores',
            value: '${summary.lineCount}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Card(
            key: const Key('quote_team_summary_total'),
            label: 'Custo diário total',
            value: QuoteMoneyDisplay.format(summary.totalCostCents),
          ),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 22),
          ),
        ],
      ),
    );
  }
}

class QuoteTeamListItem extends StatelessWidget {
  const QuoteTeamListItem({
    super.key,
    required this.item,
    required this.memberName,
    required this.roleName,
    required this.onRemove,
  });

  final QuoteTeamMember item;
  final String memberName;
  final String roleName;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(memberName, style: AppTextStyles.titleMedium),
                const SizedBox(height: 4),
                Text(
                  roleName,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Diária: ${QuoteMoneyDisplay.format(item.dailyRate)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
                if (item.notes != null && item.notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.notes!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            key: Key('quote_team_remove_${item.id}'),
            tooltip: 'Remover',
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
