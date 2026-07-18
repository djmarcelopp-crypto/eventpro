import 'package:flutter/material.dart';

import '../../../core/widgets/feedback/app_empty_state.dart';

class VehicleEmptyState extends StatelessWidget {
  const VehicleEmptyState({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.local_shipping_outlined,
      title: 'Nenhum veículo cadastrado',
      message: 'Cadastre a frota para planejar transporte nos orçamentos.',
      primaryActionLabel: 'Novo veículo',
      primaryActionKey: const Key('vehicle_empty_add'),
      onPrimaryAction: onAdd,
    );
  }
}
