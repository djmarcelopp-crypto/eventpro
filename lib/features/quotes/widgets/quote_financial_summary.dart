import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../state/quote_form_state.dart';
import '../utils/quote_money_display.dart';

class QuoteFinancialSummary extends StatelessWidget {
  const QuoteFinancialSummary({
    super.key,
    required this.summary,
  });

  final QuoteFinancialSummaryData summary;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: const Key('quote_financial_summary'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Resumo financeiro',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            key: const Key('quote_summary_subtotal'),
            label: 'Subtotal',
            value: QuoteMoneyDisplay.format(summary.subtotalCents),
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            key: const Key('quote_summary_discount'),
            label: 'Desconto',
            value: QuoteMoneyDisplay.format(summary.discountCents),
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            key: const Key('quote_summary_freight'),
            label: 'Frete',
            value: QuoteMoneyDisplay.format(summary.freightCents),
          ),
          const Divider(height: 24, color: AppColors.border),
          _SummaryRow(
            key: const Key('quote_summary_total'),
            label: 'Total',
            value: QuoteMoneyDisplay.format(summary.totalCents),
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = emphasized
        ? AppTextStyles.titleSmall.copyWith(color: AppColors.primary)
        : AppTextStyles.bodyLarge;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium,
          ),
        ),
        Text(
          value,
          style: style,
        ),
      ],
    );
  }
}
