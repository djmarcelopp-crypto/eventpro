import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

class TeamEmptyState extends StatelessWidget {
  const TeamEmptyState({
    super.key,
    required this.onNewMember,
    required this.hasActiveFilters,
    required this.onClearFilters,
  });

  final VoidCallback onNewMember;
  final bool hasActiveFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.groups_outlined,
            size: 48,
            color: AppColors.white.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            hasActiveFilters
                ? 'Nenhum colaborador encontrado'
                : 'Nenhum colaborador cadastrado',
            style: AppTextStyles.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            hasActiveFilters
                ? 'Ajuste ou limpe os filtros para ver mais resultados.'
                : 'Cadastre a equipe para associá-la aos orçamentos.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (hasActiveFilters)
            TextButton(
              key: const Key('team_empty_clear_filters'),
              onPressed: onClearFilters,
              child: const Text('Limpar filtros'),
            )
          else
            PrimaryButton(
              key: const Key('team_empty_new_button'),
              label: 'Novo colaborador',
              onPressed: onNewMember,
            ),
        ],
      ),
    );
  }
}
