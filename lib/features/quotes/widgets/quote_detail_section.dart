import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../utils/quote_detail_presenter.dart';
import 'quote_detail_row.dart';

class QuoteDetailSection extends StatelessWidget {
  const QuoteDetailSection({
    super.key,
    required this.title,
    required this.items,
    this.footer,
  });

  final String title;
  final List<QuoteDetailItem> items;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty && footer == null) {
      return const SizedBox.shrink();
    }

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleSmall),
          if (items.isNotEmpty) ...[
            const SizedBox(height: 12),
            for (final item in items)
              QuoteDetailRow(
                label: item.label,
                value: item.value,
              ),
          ],
          if (footer != null) ...[
            if (items.isNotEmpty) const SizedBox(height: 4),
            footer!,
          ],
        ],
      ),
    );
  }
}
