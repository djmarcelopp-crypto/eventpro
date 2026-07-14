import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/catalog_item.dart';
import '../models/catalog_package_component.dart';
import 'catalog_package_component_selector_sheet.dart';
import 'catalog_package_component_tile.dart';

class CatalogPackageComponentsSection extends StatelessWidget {
  const CatalogPackageComponentsSection({
    super.key,
    required this.entries,
    required this.catalogItems,
    required this.onAdd,
    required this.onRemove,
    this.enabled = true,
  });

  final List<CatalogPackageComponentEntry> entries;
  final List<CatalogItem> catalogItems;
  final ValueChanged<CatalogItem> onAdd;
  final ValueChanged<String> onRemove;
  final bool enabled;

  CatalogItem? _resolveItem(String id) {
    for (final item in catalogItems) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  Set<String> get _excludedIds {
    return entries.map((entry) => entry.component.catalogItemId).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Itens do pacote (${entries.length})',
          key: const Key('catalog_package_components_title'),
          style: AppTextStyles.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Defina os equipamentos e serviços incluídos em uma unidade deste pacote.',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 16),
        if (entries.isEmpty)
          Text(
            'Nenhum item adicionado ao pacote.',
            key: const Key('catalog_package_components_empty'),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        for (final entry in entries) ...[
          CatalogPackageComponentTile(
            component: entry.component,
            quantityController: entry.quantityController,
            isInactive: _isInactive(entry.component),
            isMissing: _isMissing(entry.component),
            enabled: enabled,
            onRemove: () => onRemove(entry.component.catalogItemId),
          ),
          const SizedBox(height: 12),
        ],
        PrimaryButton(
          key: const Key('catalog_package_add_component_button'),
          label: 'Adicionar item',
          onPressed: enabled ? () => _openSelector(context) : null,
        ),
      ],
    );
  }

  bool _isInactive(CatalogPackageComponent component) {
    final item = _resolveItem(component.catalogItemId);
    return item != null && !item.active;
  }

  bool _isMissing(CatalogPackageComponent component) {
    return _resolveItem(component.catalogItemId) == null;
  }

  Future<void> _openSelector(BuildContext context) async {
    final selected = await showCatalogPackageComponentSelector(
      context: context,
      items: catalogItems,
      excludedIds: _excludedIds,
    );

    if (selected != null) {
      onAdd(selected);
    }
  }
}

class CatalogPackageComponentEntry {
  CatalogPackageComponentEntry({
    required this.component,
    required this.quantityController,
  });

  final CatalogPackageComponent component;
  final TextEditingController quantityController;

  void dispose() {
    quantityController.dispose();
  }
}
