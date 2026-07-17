import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/vehicle_list_summary.dart';

class VehicleSummaryCards extends StatelessWidget {
  const VehicleSummaryCards({super.key, required this.summary});

  final VehicleListSummary summary;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _Card(
          key: const Key('vehicle_summary_total'),
          label: 'Total',
          value: '${summary.total}',
        ),
        _Card(
          key: const Key('vehicle_summary_available'),
          label: 'Disponíveis',
          value: '${summary.available}',
        ),
        _Card(
          key: const Key('vehicle_summary_maintenance'),
          label: 'Manutenção',
          value: '${summary.maintenance}',
        ),
        _Card(
          key: const Key('vehicle_summary_unavailable'),
          label: 'Indisponíveis',
          value: '${summary.unavailable}',
        ),
        _Card(
          key: const Key('vehicle_summary_types'),
          label: 'Tipos',
          value: '${summary.typeCount}',
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }
}
