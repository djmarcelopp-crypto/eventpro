import 'package:flutter/material.dart';

import '../../../core/widgets/feedback/app_empty_state.dart';

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
    if (hasActiveFilters && onClearFilters != null) {
      return AppEmptyState(
        icon: Icons.filter_alt_off_outlined,
        title: 'Nenhum equipamento corresponde aos filtros',
        message: 'Ajuste ou limpe os filtros para ver mais itens.',
        primaryActionLabel: 'Limpar filtros',
        primaryActionKey: const Key('equipment_clear_filters_button'),
        onPrimaryAction: onClearFilters,
      );
    }

    return AppEmptyState(
      icon: Icons.handyman_outlined,
      title: 'Nenhum equipamento cadastrado',
      message: 'Cadastre o inventário operacional da empresa.',
      primaryActionLabel: 'Novo equipamento',
      primaryActionKey: const Key('equipment_empty_new_button'),
      onPrimaryAction: onNewEquipment,
    );
  }
}
