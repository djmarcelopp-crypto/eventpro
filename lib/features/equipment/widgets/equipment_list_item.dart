import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/equipment.dart';
import '../models/equipment_status.dart';

class EquipmentListItem extends StatelessWidget {
  const EquipmentListItem({
    super.key,
    required this.equipment,
    required this.categoryName,
    required this.onTap,
  });

  final Equipment equipment;
  final String categoryName;
  final VoidCallback onTap;

  Color get _statusColor => switch (equipment.status) {
        EquipmentStatus.available => AppColors.success,
        EquipmentStatus.reserved => AppColors.warning,
        EquipmentStatus.maintenance => AppColors.primary,
        EquipmentStatus.inactive => AppColors.white.withValues(alpha: 0.5),
      };

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        key: Key('equipment_list_item_${equipment.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(equipment.name, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    categoryName,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _Chip(
                        label: equipment.status.label,
                        color: _statusColor,
                      ),
                      _Chip(
                        label: 'Qtd ${equipment.totalQuantity}',
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.white),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: color),
      ),
    );
  }
}
