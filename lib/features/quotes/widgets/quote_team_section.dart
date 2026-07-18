import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';

/// Entry point from quote detail to associate roster members.
/// Does not create schedules or payroll entries.
class QuoteTeamSection extends StatelessWidget {
  const QuoteTeamSection({super.key, required this.quoteId});

  final String quoteId;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: const Key('quote_team_section'),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Equipe do evento',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Associe colaboradores da equipe a este orçamento '
                  '(sem escala automática).',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            key: const Key('quote_team_open_button'),
            onPressed: () => context.push(AppRoutes.quotesTeam(quoteId)),
            child: const Text('Gerenciar'),
          ),
        ],
      ),
    );
  }
}
