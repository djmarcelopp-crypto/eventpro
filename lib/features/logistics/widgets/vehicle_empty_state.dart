import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

class VehicleEmptyState extends StatelessWidget {
  const VehicleEmptyState({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.local_shipping_outlined, size: 48, color: AppColors.primary),
          const SizedBox(height: 16),
          Text('Nenhum veículo cadastrado', style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Cadastre a frota para planejar transporte nos orçamentos.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            key: const Key('vehicle_empty_add'),
            label: 'Novo veículo',
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}
