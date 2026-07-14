import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/catalog_package_component.dart';
import '../utils/catalog_quantity_input_formatter.dart';
import '../utils/catalog_quantity_parser.dart';

class CatalogPackageComponentTile extends StatelessWidget {
  const CatalogPackageComponentTile({
    super.key,
    required this.component,
    required this.quantityController,
    required this.onRemove,
    this.isInactive = false,
    this.isMissing = false,
    this.enabled = true,
  });

  final CatalogPackageComponent component;
  final TextEditingController quantityController;
  final VoidCallback onRemove;
  final bool isInactive;
  final bool isMissing;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('catalog_package_component_${component.catalogItemId}'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMissing ? AppColors.error : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      component.nameSnapshot,
                      style: AppTextStyles.titleSmall,
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
                  ],
                ),
              ),
              if (isInactive) ...[
                const SizedBox(width: 8),
                _StatusBadge(
                  key: Key(
                    'catalog_package_component_inactive_${component.catalogItemId}',
                  ),
                  label: 'Inativo',
                  color: AppColors.warning,
                ),
              ],
              if (isMissing) ...[
                const SizedBox(width: 8),
                _StatusBadge(
                  key: Key(
                    'catalog_package_component_missing_${component.catalogItemId}',
                  ),
                  label: 'Ausente',
                  color: AppColors.error,
                ),
              ],
              IconButton(
                key: Key(
                  'catalog_package_component_remove_${component.catalogItemId}',
                ),
                tooltip: 'Remover componente',
                onPressed: enabled ? onRemove : null,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          if (isInactive) ...[
            const SizedBox(height: 8),
            Text(
              'Este item está inativo no catálogo. Você pode mantê-lo ou removê-lo.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warning,
              ),
            ),
          ],
          if (isMissing) ...[
            const SizedBox(height: 8),
            Text(
              'Componente removido do catálogo. Remova-o para salvar.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.error,
              ),
            ),
          ],
          const SizedBox(height: 8),
          AppTextField(
            key: Key(
              'catalog_package_component_quantity_${component.catalogItemId}',
            ),
            label: 'Quantidade por pacote',
            controller: quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: const [CatalogQuantityInputFormatter()],
            enabled: enabled,
            validator: CatalogQuantityParser.validateForSave,
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: color),
      ),
    );
  }
}
