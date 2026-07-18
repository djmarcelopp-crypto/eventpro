import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';

class DashboardEntityListItem {
  const DashboardEntityListItem({
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;
}

/// Reusable compact list card for recent/upcoming entities.
class DashboardEntityListCard extends StatelessWidget {
  const DashboardEntityListCard({
    super.key,
    required this.items,
    this.emptyMessage = 'Nenhum item',
  });

  final List<DashboardEntityListItem> items;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: items.isEmpty
          ? Text(
              emptyMessage,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            )
          : Column(
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  if (index > 0) const Divider(height: 16),
                  InkWell(
                    onTap: items[index].onTap,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items[index].title,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                items[index].subtitle,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (items[index].onTap != null)
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
