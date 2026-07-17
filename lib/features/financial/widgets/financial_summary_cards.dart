import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/financial_global_summary.dart';
import '../utils/financial_display_formatter.dart';

class FinancialSummaryCards extends StatelessWidget {
  const FinancialSummaryCards({super.key, required this.summary});

  final FinancialGlobalSummary summary;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useGrid = constraints.maxWidth >= 560;
        final cards = [
          _SummaryCard(
            key: const Key('financial_summary_income'),
            label: 'Receitas',
            value: FinancialDisplayFormatter.money(summary.totalIncomeCents),
            color: AppColors.success,
          ),
          _SummaryCard(
            key: const Key('financial_summary_expense'),
            label: 'Despesas',
            value: FinancialDisplayFormatter.money(summary.totalExpenseCents),
            color: AppColors.error,
          ),
          _SummaryCard(
            key: const Key('financial_summary_balance'),
            label: 'Saldo',
            value: FinancialDisplayFormatter.money(summary.balanceCents),
            color: summary.balanceCents >= 0
                ? AppColors.success
                : AppColors.error,
          ),
          _SummaryCard(
            key: const Key('financial_summary_pending'),
            label: 'Pendentes',
            value: FinancialDisplayFormatter.money(summary.pendingCents),
            color: AppColors.warning,
          ),
        ];

        if (!useGrid) {
          return Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                cards[i],
              ],
            ],
          );
        }

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final card in cards)
              SizedBox(
                width: (constraints.maxWidth - 12) / 2,
                child: card,
              ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mutedWhite,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
