import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/quote_package_component_snapshot.dart';
import '../utils/quote_package_line_presenter.dart';

class QuoteLinePackageComponents extends StatefulWidget {
  const QuoteLinePackageComponents({
    super.key,
    required this.components,
    required this.lineQuantity,
    this.compact = false,
  });

  final List<QuotePackageComponentSnapshot> components;
  final double lineQuantity;
  final bool compact;

  @override
  State<QuoteLinePackageComponents> createState() =>
      _QuoteLinePackageComponentsState();
}

class _QuoteLinePackageComponentsState extends State<QuoteLinePackageComponents> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.components.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            key: Key(
              _expanded
                  ? 'quote_package_components_collapse'
                  : 'quote_package_components_expand',
            ),
            onPressed: () => setState(() => _expanded = !_expanded),
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            label: Text(
              _expanded
                  ? 'Ocultar itens do pacote'
                  : 'Ver itens do pacote (${widget.components.length})',
            ),
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 4),
          for (final component in widget.components) ...[
            _ComponentRow(
              component: component,
              lineQuantity: widget.lineQuantity,
              compact: widget.compact,
            ),
            const SizedBox(height: 8),
          ],
        ],
      ],
    );
  }
}

class _ComponentRow extends StatelessWidget {
  const _ComponentRow({
    required this.component,
    required this.lineQuantity,
    required this.compact,
  });

  final QuotePackageComponentSnapshot component;
  final double lineQuantity;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final effectiveQuantity =
        component.effectiveQuantity(lineQuantity);

    return Container(
      key: Key('quote_package_component_${component.catalogItemId ?? component.name}'),
      padding: EdgeInsets.all(compact ? 10 : 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            component.name,
            style: compact ? AppTextStyles.bodyMedium : AppTextStyles.titleSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${component.typeLabel} • ${component.categoryLabel} • ${component.unit}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.secondaryText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Qtd. efetiva: ${QuotePackageLinePresenter.formatEffectiveQuantity(effectiveQuantity)}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class QuotePackageBadge extends StatelessWidget {
  const QuotePackageBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('quote_package_badge'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'Pacote',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
