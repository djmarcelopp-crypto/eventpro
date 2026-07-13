import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../catalog/utils/brazilian_currency_input_formatter.dart';
import '../models/quote_line_draft.dart';
import '../state/quote_form_state.dart';
import '../utils/quote_money_display.dart';
import '../utils/quote_quantity_input_formatter.dart';

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
  });

  final QuoteLineDraft draft;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final QuoteLineCalculation calculation;
  final ValueChanged<String> onQuantityChanged;
  final ValueChanged<String> onPriceChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: Key('quote_line_editor_${draft.draftId}'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft.name,
                      style: AppTextStyles.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      draft.unit,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
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
          ),
          const SizedBox(height: 16),
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
        ],
      ),
    );
  }
}
