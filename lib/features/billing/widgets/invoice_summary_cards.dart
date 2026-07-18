import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../quotes/utils/quote_money_display.dart';
import '../models/invoice_list_summary.dart';

class InvoiceSummaryCards extends StatelessWidget {
  const InvoiceSummaryCards({super.key, required this.summary});

  final InvoiceListSummary summary;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _Card(
          key: const Key('invoice_summary_draft'),
          label: 'Rascunhos',
          value: '${summary.draft}',
        ),
        _Card(
          key: const Key('invoice_summary_issued'),
          label: 'Emitidos',
          value: '${summary.issued}',
        ),
        _Card(
          key: const Key('invoice_summary_paid'),
          label: 'Pagos',
          value: '${summary.paid}',
        ),
        _Card(
          key: const Key('invoice_summary_cancelled'),
          label: 'Cancelados',
          value: '${summary.cancelled}',
        ),
        _Card(
          key: const Key('invoice_summary_total_billed'),
          label: 'Total faturado',
          value: QuoteMoneyDisplay.format(summary.totalBilledCents),
        ),
        _Card(
          key: const Key('invoice_summary_total_paid'),
          label: 'Total pago',
          value: QuoteMoneyDisplay.format(summary.totalPaidCents),
        ),
        _Card(
          key: const Key('invoice_summary_total_pending'),
          label: 'Total pendente',
          value: QuoteMoneyDisplay.format(summary.totalPendingCents),
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
