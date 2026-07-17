import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

class EquipmentEmptyState extends StatelessWidget {
  const EquipmentEmptyState({
    super.key,
    required this.onNewEquipment,
    this.hasActiveFilters = false,
    this.onClearFilters,
  });

  final VoidCallback onNewEquipment;
  final bool hasActiveFilters;
  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(
            hasActiveFilters
                ? Icons.filter_alt_off_outlined
                : Icons.handyman_outlined,
            size: 48,
            color: AppColors.white.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            hasActiveFilters
                ? 'Nenhum equipamento corresponde aos filtros'
                : 'Nenhum equipamento cadastrado',
            style: AppTextStyles.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            hasActiveFilters
                ? 'Ajuste ou limpe os filtros para ver mais itens.'
                : 'Cadastre o inventário operacional da empresa.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (hasActiveFilters && onClearFilters != null)
            PrimaryButton(
              key: const Key('equipment_clear_filters_button'),
              label: 'Limpar filtros',
              onPressed: onClearFilters,
            )
          else
            PrimaryButton(
              key: const Key('equipment_empty_new_button'),
              label: 'Novo equipamento',
              onPressed: onNewEquipment,
            ),
        ],
      ),
    );
  }
}
