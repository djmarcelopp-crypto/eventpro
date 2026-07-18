import 'package:flutter/material.dart';

import '../../../core/widgets/feedback/app_empty_state.dart';

class ClientsEmptyState extends StatelessWidget {
  const ClientsEmptyState({
    super.key,
    required this.onNewClient,
  });

  final VoidCallback onNewClient;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      key: const Key('clients_empty_state'),
      icon: Icons.people_outline,
      title: 'Nenhum cliente cadastrado',
      message: 'Cadastre seu primeiro cliente para começar a operar com o EventPro.',
      primaryActionLabel: 'Novo cliente',
      onPrimaryAction: onNewClient,
    );
  }
}
