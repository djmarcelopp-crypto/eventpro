import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CatalogItemImagePlaceholder extends StatelessWidget {
  const CatalogItemImagePlaceholder({
    super.key,
    this.width = 160,
    this.height = 120,
    this.borderRadius = 12,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('catalog_item_image_placeholder'),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: AppColors.secondaryText,
        ),
      ),
    );
  }
}
