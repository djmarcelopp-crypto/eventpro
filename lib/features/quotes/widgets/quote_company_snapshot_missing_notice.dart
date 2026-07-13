import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';

class QuoteCompanySnapshotMissingNotice extends StatelessWidget {
  const QuoteCompanySnapshotMissingNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: const Key('quote_company_snapshot_missing_notice'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: AppColors.secondaryText,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Os dados da empresa emissora não foram capturados neste orçamento.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
