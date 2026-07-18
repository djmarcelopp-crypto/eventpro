import 'package:flutter/material.dart';

import '../../../core/widgets/feedback/app_empty_state.dart';

class AgendaEmptyState extends StatelessWidget {
  const AgendaEmptyState({
    super.key,
    required this.onNewBlock,
  });

  final VoidCallback onNewBlock;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.event_available_outlined,
      title: 'Nenhum evento ou bloqueio na agenda',
      message: 'Crie um bloqueio manual ou aguarde novos orçamentos.',
      primaryActionLabel: 'Novo bloqueio',
      onPrimaryAction: onNewBlock,
    );
  }
}
