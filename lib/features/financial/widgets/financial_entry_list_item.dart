import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/financial_entry.dart';
import '../models/financial_entry_status.dart';
import '../models/financial_flow_kind.dart';
import '../utils/financial_display_formatter.dart';

class FinancialEntryListItem extends StatelessWidget {
  const FinancialEntryListItem({
    super.key,
    required this.entry,
    required this.onTap,
    this.categoryName,
    this.quoteLabel,
  });

  final FinancialEntry entry;
  final VoidCallback onTap;
  final String? categoryName;
  final String? quoteLabel;

  @override
  Widget build(BuildContext context) {
    final kindColor = entry.kind.color;
    final amountPrefix = entry.isIncome ? '+' : '−';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 56,
              decoration: BoxDecoration(
                color: kindColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.description,
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [
                      FinancialDisplayFormatter.civilDate(entry.date),
                      entry.kind.label,
                      entry.status.label,
                      if (categoryName != null && categoryName!.isNotEmpty)
                        categoryName!,
                    ].join(' · '),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.mutedWhite,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (quoteLabel != null && quoteLabel!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      quoteLabel!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$amountPrefix${FinancialDisplayFormatter.money(entry.amountCents)}',
              style: AppTextStyles.titleMedium.copyWith(
                color: kindColor,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
