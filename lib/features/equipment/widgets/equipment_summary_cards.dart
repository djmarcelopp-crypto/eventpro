import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/equipment_list_summary.dart';

class EquipmentSummaryCards extends StatelessWidget {
  const EquipmentSummaryCards({super.key, required this.summary});

  final EquipmentListSummary summary;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryCard(
        key: const Key('equipment_summary_total'),
        label: 'Itens',
        value: '${summary.totalItems}',
        color: AppColors.primary,
      ),
      _SummaryCard(
        key: const Key('equipment_summary_quantity'),
        label: 'Quantidade',
        value: '${summary.totalQuantity}',
        color: AppColors.white,
      ),
      _SummaryCard(
        key: const Key('equipment_summary_available'),
        label: 'Disponíveis',
        value: '${summary.availableCount}',
        color: AppColors.success,
      ),
      _SummaryCard(
        key: const Key('equipment_summary_maintenance'),
        label: 'Manutenção',
        value: '${summary.maintenanceCount}',
        color: AppColors.warning,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useGrid = constraints.maxWidth >= 560;
        if (!useGrid) {
          return Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                cards[i],
              ],
            ],
          );
        }
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final card in cards)
              SizedBox(
                width: (constraints.maxWidth - 12) / 2,
                child: card,
              ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

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
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 22,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
