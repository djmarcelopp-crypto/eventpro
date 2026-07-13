import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/quote.dart';
import '../state/quote_form_state.dart';
import 'quote_status_badge.dart';

class QuoteListItem extends StatelessWidget {
  const QuoteListItem({
    super.key,
    required this.quote,
  });

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: Key('quote_list_item_${quote.id}'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  quote.number,
                  style: AppTextStyles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              QuoteStatusBadge(status: quote.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            QuoteListPresenter.clientName(quote),
            style: AppTextStyles.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Evento',
            value: QuoteListPresenter.formatEventDate(quote),
          ),
          const SizedBox(height: 4),
          _InfoRow(
            label: 'Total',
            value: QuoteListPresenter.formatTotal(quote),
          ),
          const SizedBox(height: 4),
          _InfoRow(
            label: 'Validade',
            value: QuoteListPresenter.formatValidUntil(quote),
          ),
          const SizedBox(height: 4),
          _InfoRow(
            label: 'Itens',
            value: QuoteListPresenter.formatItemsCount(quote),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mutedWhite,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
