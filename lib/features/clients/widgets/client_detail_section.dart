import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../utils/client_detail_presenter.dart';
import 'client_detail_row.dart';

class ClientDetailSection extends StatelessWidget {
  const ClientDetailSection({
    super.key,
    required this.title,
    required this.items,
    this.footer,
  });

  final String title;
  final List<ClientDetailItem> items;
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
              ClientDetailRow(
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
