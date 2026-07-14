import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/quote_line_item.dart';
import '../utils/quote_detail_presenter.dart';
import '../utils/quote_package_line_presenter.dart';
import 'quote_line_package_components.dart';

class QuoteLineItemsSection extends StatefulWidget {
  const QuoteLineItemsSection({
    super.key,
    required this.items,
    this.collapsedLimit = 6,
    this.twoColumnBreakpoint = 720,
  });

  final List<QuoteLineItem> items;
  final int collapsedLimit;
  final double twoColumnBreakpoint;

  @override
  State<QuoteLineItemsSection> createState() => _QuoteLineItemsSectionState();
}

class _QuoteLineItemsSectionState extends State<QuoteLineItemsSection> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final shouldCollapse = widget.items.length > widget.collapsedLimit;
    final visibleItems = !shouldCollapse || _expanded
        ? widget.items
        : widget.items.take(widget.collapsedLimit).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns =
            constraints.maxWidth >= widget.twoColumnBreakpoint;

        return AppCard(
          key: const Key('quote_line_items_section'),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Itens do orçamento (${widget.items.length})',
                style: AppTextStyles.titleSmall,
              ),
              const SizedBox(height: 12),
              if (useTwoColumns)
                _buildTwoColumnGrid(visibleItems)
              else
                _buildSingleColumn(visibleItems),
              if (shouldCollapse) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    key: Key(
                      _expanded
                          ? 'quote_items_show_less_button'
                          : 'quote_items_show_all_button',
                    ),
                    onPressed: () => setState(() => _expanded = !_expanded),
                    child: Text(
                      _expanded
                          ? 'Mostrar menos'
                          : 'Mostrar todos os itens',
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSingleColumn(List<QuoteLineItem> items) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          QuoteLineItemCard(item: items[i]),
        ],
      ],
    );
  }

  Widget _buildTwoColumnGrid(List<QuoteLineItem> items) {
    final rows = <Widget>[];

    for (var i = 0; i < items.length; i += 2) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: QuoteLineItemCard(item: items[i])),
            const SizedBox(width: 12),
            Expanded(
              child: i + 1 < items.length
                  ? QuoteLineItemCard(item: items[i + 1])
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );

      if (i + 2 < items.length) {
        rows.add(const SizedBox(height: 12));
      }
    }

    return Column(children: rows);
  }
}

class QuoteLineItemCard extends StatefulWidget {
  const QuoteLineItemCard({
    super.key,
    required this.item,
  });

  final QuoteLineItem item;

  @override
  State<QuoteLineItemCard> createState() => _QuoteLineItemCardState();
}

class _QuoteLineItemCardState extends State<QuoteLineItemCard> {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final description = item.description?.trim();

    return AppCard(
      key: Key('quote_line_item_card_${item.catalogItemId}'),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (item.isPackageLine) const QuotePackageBadge(),
              Text(
                item.name,
                style: AppTextStyles.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          if (item.isPackageLine) ...[
            const SizedBox(height: 6),
            Text(
              QuotePackageLinePresenter.includedItemsSummary(
                item.packageComponents,
              ),
              key: Key('quote_detail_package_summary_${item.catalogItemId}'),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 10),
          _QuantityUnitChip(
            quantityLabel: QuoteDetailPresenter.formatQuantity(item.quantity),
            unit: item.unit,
          ),
          const SizedBox(height: 10),
          Text(
            'Preço unitário: ${QuoteDetailPresenter.formatMoney(item.unitPriceCents)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            QuoteDetailPresenter.formatMoney(item.lineTotalCents),
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
          if (item.isPackageLine) ...[
            const SizedBox(height: 8),
            QuoteLinePackageComponents(
              components: item.packageComponents!,
              lineQuantity: item.quantity,
              compact: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _QuantityUnitChip extends StatelessWidget {
  const _QuantityUnitChip({
    required this.quantityLabel,
    required this.unit,
  });

  final String quantityLabel;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        '$quantityLabel × $unit',
        style: AppTextStyles.caption,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
