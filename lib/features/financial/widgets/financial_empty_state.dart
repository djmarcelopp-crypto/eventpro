import 'package:flutter/material.dart';

import '../../../core/widgets/feedback/app_empty_state.dart';

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
    if (hasActiveFilters && onClearFilters != null) {
      return AppEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Nenhum lançamento com esses filtros',
        message: 'Ajuste ou limpe os filtros para ver outros lançamentos.',
        primaryActionLabel: 'Limpar filtros',
        primaryActionKey: const Key('financial_empty_clear_filters'),
        onPrimaryAction: onClearFilters,
      );
    }

    return AppEmptyState(
      icon: Icons.account_balance_wallet_outlined,
      title: 'Nenhum lançamento financeiro',
      message: 'Registre receitas e despesas para acompanhar o saldo.',
      primaryActionLabel: 'Novo lançamento',
      primaryActionKey: const Key('financial_empty_new_entry'),
      onPrimaryAction: onNewEntry,
    );
  }
}
