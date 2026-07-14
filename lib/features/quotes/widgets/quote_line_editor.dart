import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../catalog/utils/brazilian_currency_input_formatter.dart';
import '../models/quote_line_draft.dart';
import '../state/quote_form_state.dart';
import '../utils/quote_money_display.dart';
import '../utils/quote_package_line_presenter.dart';
import '../utils/quote_quantity_input_formatter.dart';
import 'quote_line_package_components.dart';

class QuoteLineEditor extends StatelessWidget {
  const QuoteLineEditor({
    super.key,
    required this.draft,
    required this.quantityController,
    required this.priceController,
    required this.calculation,
    required this.onQuantityChanged,
    required this.onPriceChanged,
    required this.onRemove,
    this.catalogWarning,
  });

  final QuoteLineDraft draft;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final QuoteLineCalculation calculation;
  final ValueChanged<String> onQuantityChanged;
  final ValueChanged<String> onPriceChanged;
  final VoidCallback onRemove;
  final String? catalogWarning;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;

        return AppCard(
          key: Key('quote_line_editor_${draft.draftId}'),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (compact)
                _buildCompactHeader()
              else
                _buildWideHeader(),
              if (catalogWarning != null) ...[
                const SizedBox(height: 12),
                Text(
                  catalogWarning!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (compact) ...[
                AppTextField(
                  key: Key('quote_line_quantity_${draft.draftId}'),
                  label: 'Quantidade',
                  controller: quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: const [QuoteQuantityInputFormatter()],
                  onChanged: onQuantityChanged,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  key: Key('quote_line_price_${draft.draftId}'),
                  label: 'Preço unitário (R\$)',
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [BrazilianCurrencyInputFormatter()],
                  onChanged: onPriceChanged,
                ),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        key: Key('quote_line_quantity_${draft.draftId}'),
                        label: 'Quantidade',
                        controller: quantityController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: const [QuoteQuantityInputFormatter()],
                        onChanged: onQuantityChanged,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppTextField(
                        key: Key('quote_line_price_${draft.draftId}'),
                        label: 'Preço unitário (R\$)',
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [BrazilianCurrencyInputFormatter()],
                        onChanged: onPriceChanged,
                      ),
                    ),
                  ],
                ),
              if (calculation.quantityError != null) ...[
                const SizedBox(height: 4),
                Text(
                  calculation.quantityError!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ],
              if (calculation.priceError != null) ...[
                const SizedBox(height: 4),
                Text(
                  calculation.priceError!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ],
              const SizedBox(height: 12),
              if (compact)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total da linha',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      QuoteMoneyDisplay.format(calculation.lineTotalCents),
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Text(
                      'Total da linha',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const Spacer(),
                    Text(
                      QuoteMoneyDisplay.format(calculation.lineTotalCents),
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              if (draft.isPackageLine && calculation.quantity != null) ...[
                const SizedBox(height: 12),
                QuoteLinePackageComponents(
                  components: draft.packageComponents!,
                  lineQuantity: calculation.quantity!,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildWideHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildHeaderContent()),
        IconButton(
          key: Key('quote_line_remove_${draft.draftId}'),
          tooltip: 'Remover item',
          onPressed: onRemove,
          icon: const Icon(
            Icons.delete_outline,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            key: Key('quote_line_remove_${draft.draftId}'),
            tooltip: 'Remover item',
            onPressed: onRemove,
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.error,
            ),
          ),
        ),
        _buildHeaderContent(),
      ],
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (draft.isPackageLine) const QuotePackageBadge(),
            Text(
              draft.name,
              style: AppTextStyles.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          draft.unit,
          style: AppTextStyles.bodyMedium,
        ),
        if (draft.isPackageLine) ...[
          const SizedBox(height: 4),
          Text(
            QuotePackageLinePresenter.includedItemsSummary(
              draft.packageComponents,
            ),
            key: Key('quote_package_summary_${draft.draftId}'),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],
        if (draft.description?.trim().isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Text(
            draft.description!.trim(),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.secondaryText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
