import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/quote_status.dart';
import '../models/quote_status_history_entry.dart';
import '../utils/quote_detail_presenter.dart';

class QuoteStatusHistoryList extends StatefulWidget {
  const QuoteStatusHistoryList({
    super.key,
    required this.entries,
  });

  final List<QuoteStatusHistoryEntry> entries;

  @override
  State<QuoteStatusHistoryList> createState() => _QuoteStatusHistoryListState();
}

class _QuoteStatusHistoryListState extends State<QuoteStatusHistoryList> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppCard(
      key: const Key('quote_status_history_section'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            key: const Key('quote_status_history_toggle'),
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Histórico de status (${widget.entries.length})',
                      style: AppTextStyles.titleSmall,
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.secondaryText,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: 12),
            for (var i = 0; i < widget.entries.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _HistoryEntryRow(entry: widget.entries[i]),
            ],
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
