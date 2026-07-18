import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/quote_equipment.dart';
import '../models/quote_equipment_summary.dart';

class QuoteEquipmentSummaryCards extends StatelessWidget {
  const QuoteEquipmentSummaryCards({super.key, required this.summary});

  final QuoteEquipmentSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Card(
            key: const Key('quote_equipment_summary_lines'),
            label: 'Itens',
            value: '${summary.lineCount}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Card(
            key: const Key('quote_equipment_summary_quantity'),
            label: 'Quantidade total',
            value: '${summary.totalQuantity}',
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.headlineMedium.copyWith(fontSize: 22)),
        ],
      ),
    );
  }
}

class QuoteEquipmentListItem extends StatelessWidget {
  const QuoteEquipmentListItem({
    super.key,
    required this.item,
    required this.equipmentName,
    required this.onEditQuantity,
    required this.onRemove,
  });

  final QuoteEquipment item;
  final String equipmentName;
  final VoidCallback onEditQuantity;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(equipmentName, style: AppTextStyles.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Quantidade: ${item.quantity}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            key: Key('quote_equipment_edit_${item.id}'),
            tooltip: 'Alterar quantidade',
            onPressed: onEditQuantity,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            key: Key('quote_equipment_remove_${item.id}'),
            tooltip: 'Remover',
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
