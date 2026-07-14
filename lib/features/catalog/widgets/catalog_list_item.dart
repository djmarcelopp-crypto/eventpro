import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../catalog_category.dart';
import '../catalog_item_type.dart';
import '../models/catalog_item.dart';
import '../utils/catalog_price_formatter.dart';
import 'catalog_item_image_view.dart';

class CatalogListItem extends StatelessWidget {
  const CatalogListItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  final CatalogItem item;
  final VoidCallback onTap;

  static String _packageSummary(CatalogItem item) {
    final count = item.components.length;
    if (count == 1) {
      return '1 item incluído';
    }
    return '$count itens incluídos';
  }

  @override
  Widget build(BuildContext context) {
    final isActive = item.active;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Opacity(
          opacity: isActive ? 1 : 0.7,
          child: AppCard(
            key: Key('catalog_list_item_${item.id}'),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CatalogItemImageView(
                    imageReference: item.imageReference,
                    width: double.infinity,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: AppTextStyles.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!isActive) ...[
                      const SizedBox(width: 8),
                      _InactiveBadge(),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.type.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        item.category.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${CatalogPriceFormatter.format(item.price)} / ${item.unit}',
                  style: AppTextStyles.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.isPackage) ...[
                  const SizedBox(height: 4),
                  Text(
                    _packageSummary(item),
                    key: Key('catalog_package_summary_${item.id}'),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.secondaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InactiveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('catalog_inactive_badge'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'Inativo',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.warning,
        ),
      ),
    );
  }
}
