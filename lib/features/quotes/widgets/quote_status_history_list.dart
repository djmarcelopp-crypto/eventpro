import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/quote_status.dart';
import '../models/quote_status_history_entry.dart';
import '../utils/quote_detail_presenter.dart';

class QuoteStatusHistoryList extends StatelessWidget {
  const QuoteStatusHistoryList({
    super.key,
    required this.entries,
  });

  final List<QuoteStatusHistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppCard(
      key: const Key('quote_status_history_section'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Histórico de status', style: AppTextStyles.titleSmall),
          const SizedBox(height: 12),
          for (var i = 0; i < entries.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _HistoryEntryRow(entry: entries[i]),
          ],
        ],
      ),
    );
  }
}

class _HistoryEntryRow extends StatelessWidget {
  const _HistoryEntryRow({required this.entry});

  final QuoteStatusHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.history,
          size: 18,
          color: entry.newStatus.color,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                QuoteDetailPresenter.historyEntryLabel(entry),
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                QuoteDetailPresenter.formatDateTime(entry.changedAt),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
