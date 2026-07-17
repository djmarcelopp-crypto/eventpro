import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/team_list_summary.dart';

class TeamSummaryCards extends StatelessWidget {
  const TeamSummaryCards({super.key, required this.summary});

  final TeamListSummary summary;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryCard(
        key: const Key('team_summary_active'),
        label: 'Ativos',
        value: '${summary.activeCount}',
        color: AppColors.success,
      ),
      _SummaryCard(
        key: const Key('team_summary_unavailable'),
        label: 'Indisponíveis',
        value: '${summary.unavailableCount}',
        color: AppColors.warning,
      ),
      _SummaryCard(
        key: const Key('team_summary_roles'),
        label: 'Funções',
        value: '${summary.rolesCount}',
        color: AppColors.primary,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRow = constraints.maxWidth >= 560;
        if (!useRow) {
          return Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                cards[i],
              ],
            ],
          );
        }
        return Row(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(child: cards[i]),
            ],
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
