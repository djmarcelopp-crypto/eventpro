import 'package:flutter/material.dart';

import '../../../core/widgets/feedback/app_empty_state.dart';

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
    if (hasActiveFilters) {
      return AppEmptyState(
        icon: Icons.groups_outlined,
        title: 'Nenhum colaborador encontrado',
        message: 'Ajuste ou limpe os filtros para ver mais resultados.',
        primaryActionLabel: 'Limpar filtros',
        primaryActionKey: const Key('team_empty_clear_filters'),
        onPrimaryAction: onClearFilters,
      );
    }

    return AppEmptyState(
      icon: Icons.groups_outlined,
      title: 'Nenhum colaborador cadastrado',
      message: 'Cadastre a equipe para associá-la aos orçamentos.',
      primaryActionLabel: 'Novo colaborador',
      primaryActionKey: const Key('team_empty_new_button'),
      onPrimaryAction: onNewMember,
    );
  }
}
