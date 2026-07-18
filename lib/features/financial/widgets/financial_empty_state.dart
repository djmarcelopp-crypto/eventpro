import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

class FinancialEmptyState extends StatelessWidget {
  const FinancialEmptyState({
    super.key,
    required this.onNewEntry,
    this.hasActiveFilters = false,
    this.onClearFilters,
  });

  final VoidCallback onNewEntry;
  final bool hasActiveFilters;
  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 48,
                color: AppColors.mutedWhite,
              ),
              const SizedBox(height: 12),
              Text(
                hasActiveFilters
                    ? 'Nenhum lançamento com esses filtros'
                    : 'Nenhum lançamento financeiro',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                hasActiveFilters
                    ? 'Ajuste ou limpe os filtros para ver outros lançamentos.'
                    : 'Registre receitas e despesas para acompanhar o saldo.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mutedWhite,
                ),
              ),
              const SizedBox(height: 20),
              if (hasActiveFilters && onClearFilters != null)
                OutlinedButton(
                  key: const Key('financial_empty_clear_filters'),
                  onPressed: onClearFilters,
                  child: const Text('Limpar filtros'),
                )
              else
                PrimaryButton(
                  key: const Key('financial_empty_new_entry'),
                  label: 'Novo lançamento',
                  onPressed: onNewEntry,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
