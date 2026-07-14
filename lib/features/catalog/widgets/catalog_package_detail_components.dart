import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/catalog_package_component.dart';
import '../utils/catalog_quantity_parser.dart';

class CatalogPackageDetailComponents extends StatelessWidget {
  const CatalogPackageDetailComponents({
    super.key,
    required this.components,
  });

  final List<CatalogPackageComponent> components;

  @override
  Widget build(BuildContext context) {
    if (components.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Itens incluídos (${components.length})',
          key: const Key('catalog_detail_package_components_title'),
          style: AppTextStyles.titleSmall,
        ),
        const SizedBox(height: 12),
        for (final component in components) ...[
          _ComponentBlock(component: component),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ComponentBlock extends StatelessWidget {
  const _ComponentBlock({
    required this.component,
  });

  final CatalogPackageComponent component;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('catalog_detail_package_component_${component.catalogItemId}'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            component.nameSnapshot,
            style: AppTextStyles.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${component.typeSnapshot} • ${component.categorySnapshot} • ${component.unitSnapshot}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.secondaryText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Qtd. por pacote: ${CatalogQuantityParser.formatForInput(component.quantityPerPackage)}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
