import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/vehicle.dart';
import '../models/vehicle_status.dart';

class VehicleListItem extends StatelessWidget {
  const VehicleListItem({
    super.key,
    required this.vehicle,
    required this.typeName,
    required this.onTap,
  });

  final Vehicle vehicle;
  final String typeName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        key: Key('vehicle_list_item_${vehicle.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle.plate, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '$typeName · ${vehicle.status.label}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vehicle.payloadCapacityKg} kg · '
                    '${vehicle.volumeCapacityM3} m³',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
