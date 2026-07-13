import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../catalog/catalog_category.dart';
import '../../catalog/catalog_item_type.dart';
import '../../catalog/models/catalog_item.dart';
import '../../catalog/utils/catalog_price_formatter.dart';
import '../../catalog/widgets/catalog_item_image_view.dart';
import '../utils/quote_catalog_search.dart';

class QuoteCatalogItemSelectorSheet extends StatefulWidget {
  const QuoteCatalogItemSelectorSheet({
    super.key,
    required this.items,
    required this.existingCatalogItemIds,
    required this.pageContext,
  });

  final List<CatalogItem> items;
  final Set<String> existingCatalogItemIds;
  final BuildContext pageContext;

  @override
  State<QuoteCatalogItemSelectorSheet> createState() =>
      _QuoteCatalogItemSelectorSheetState();
}

class _QuoteCatalogItemSelectorSheetState
    extends State<QuoteCatalogItemSelectorSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CatalogItem> get _activeItems {
    return QuoteCatalogSearch.filterActive(widget.items, _query);
  }

  Future<void> _openNewCatalogItem() async {
    Navigator.of(context).pop();
    await widget.pageContext.push<bool>(AppRoutes.catalogNew);
  }

  @override
  Widget build(BuildContext context) {
    final activeItems = _activeItems;
    final hasAnyActive = widget.items.any((item) => item.active);

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
              'Adicionar item do catálogo',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('quote_catalog_search_field'),
              label: 'Buscar item',
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 16),
            if (!hasAnyActive) ...[
              Text(
                'Nenhum item ativo no catálogo. Cadastre um item para '
                'continuar o orçamento.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                key: const Key('quote_register_catalog_item_button'),
                label: 'Cadastrar item',
                onPressed: _openNewCatalogItem,
              ),
            ] else if (activeItems.isEmpty) ...[
              Text(
                'Nenhum item encontrado para a busca.',
                style: AppTextStyles.bodyMedium,
              ),
            ] else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: activeItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = activeItems[index];
                    final isDuplicate =
                        widget.existingCatalogItemIds.contains(item.id);

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: Key('quote_catalog_option_${item.id}'),
                        borderRadius: BorderRadius.circular(12),
                        onTap: isDuplicate
                            ? null
                            : () => Navigator.of(context).pop(item),
                        child: Opacity(
                          opacity: isDuplicate ? 0.5 : 1,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      if (isDuplicate) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'Já adicionado ao orçamento',
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.warning,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
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

Future<CatalogItem?> showQuoteCatalogItemSelector({
  required BuildContext context,
  required List<CatalogItem> items,
  required Set<String> existingCatalogItemIds,
}) {
  return showModalBottomSheet<CatalogItem>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return QuoteCatalogItemSelectorSheet(
        items: items,
        existingCatalogItemIds: existingCatalogItemIds,
        pageContext: context,
      );
    },
  );
}
