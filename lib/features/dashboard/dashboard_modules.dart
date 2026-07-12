import 'package:flutter/material.dart';

class DashboardModule {
  const DashboardModule({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

const List<DashboardModule> dashboardModules = [
  DashboardModule(
    title: 'Clientes',
    description: 'Gerencie clientes e contatos',
    icon: Icons.people_outline,
  ),
  DashboardModule(
    title: 'Catálogo',
    description: 'Serviços e equipamentos',
    icon: Icons.inventory_2_outlined,
  ),
  DashboardModule(
    title: 'Orçamentos',
    description: 'Crie e envie orçamentos',
    icon: Icons.request_quote_outlined,
  ),
  DashboardModule(
    title: 'Configurações',
    description: 'Dados da empresa',
    icon: Icons.settings_outlined,
  ),
];
