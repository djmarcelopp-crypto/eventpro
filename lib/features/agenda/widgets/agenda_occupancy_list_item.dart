import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/agenda_occupancy.dart';
import '../utils/agenda_occupancy_presenter.dart';

class AgendaOccupancyListItem extends StatelessWidget {
  const AgendaOccupancyListItem({
    super.key,
    required this.occupancy,
    required this.onTap,
  });

  final AgendaOccupancy occupancy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final kindColor = occupancy.kind.color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: kindColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kindColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  occupancy.kind.label,
                  style: AppTextStyles.caption.copyWith(
                    color: kindColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                occupancy.title,
                style: AppTextStyles.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                AgendaDateFormatter.formatRange(occupancy.start, occupancy.end),
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
