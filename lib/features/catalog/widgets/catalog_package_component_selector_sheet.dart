import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../catalog_category.dart';
import '../catalog_item_type.dart';
import '../models/catalog_item.dart';
import '../utils/catalog_package_component_search.dart';
import '../utils/catalog_price_formatter.dart';
import 'catalog_item_image_view.dart';

class CatalogPackageComponentSelectorSheet extends StatefulWidget {
  const CatalogPackageComponentSelectorSheet({
    super.key,
    required this.items,
    required this.excludedIds,
  });

  final List<CatalogItem> items;
  final Set<String> excludedIds;

  @override
  State<CatalogPackageComponentSelectorSheet> createState() =>
      _CatalogPackageComponentSelectorSheetState();
}

class _CatalogPackageComponentSelectorSheetState
    extends State<CatalogPackageComponentSelectorSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CatalogItem> get _filteredItems {
    return CatalogPackageComponentSearch.filterSelectable(
      items: widget.items,
      excludedIds: widget.excludedIds,
      query: _query,
    );
  }

  bool get _hasAnySelectable {
    return CatalogPackageComponentSearch.filterSelectable(
      items: widget.items,
      excludedIds: widget.excludedIds,
    ).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Adicionar item ao pacote',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Somente equipamentos e serviços ativos podem ser incluídos.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('catalog_package_component_search_field'),
              label: 'Buscar item',
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 16),
            if (!_hasAnySelectable) ...[
              Text(
                'Nenhum equipamento ou serviço ativo disponível para incluir.',
                style: AppTextStyles.bodyMedium,
              ),
            ] else if (filteredItems.isEmpty) ...[
              Text(
                'Nenhum item encontrado para a busca.',
                style: AppTextStyles.bodyMedium,
              ),
            ] else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: filteredItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: Key('catalog_package_option_${item.id}'),
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.of(context).pop(item),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CatalogItemImageView(
                                  imageReference: item.imageReference,
                                  width: 56,
                                  height: 56,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: AppTextStyles.titleSmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item.category.label} • ${item.type.label}',
                                      style: AppTextStyles.caption,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${CatalogPriceFormatter.format(item.price)} / ${item.unit}',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<CatalogItem?> showCatalogPackageComponentSelector({
  required BuildContext context,
  required List<CatalogItem> items,
  required Set<String> excludedIds,
}) {
  return showModalBottomSheet<CatalogItem>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.85,
        ),
        child: CatalogPackageComponentSelectorSheet(
          items: items,
          excludedIds: excludedIds,
        ),
      );
    },
  );
}
