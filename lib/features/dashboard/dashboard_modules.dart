import 'package:flutter/material.dart';

enum DashboardModuleId {
  clients,
  catalog,
  quotes,
  settings,
}

class DashboardModule {
  const DashboardModule({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  final DashboardModuleId id;
  final String title;
  final String description;
  final IconData icon;
}

const List<DashboardModule> dashboardModules = [
  DashboardModule(
    id: DashboardModuleId.clients,
    title: 'Clientes',
    description: 'Gerencie clientes e contatos',
    icon: Icons.people_outline,
  ),
  DashboardModule(
    id: DashboardModuleId.catalog,
    title: 'Catálogo',
    description: 'Serviços e equipamentos',
    icon: Icons.inventory_2_outlined,
  ),
  DashboardModule(
    id: DashboardModuleId.quotes,
    title: 'Orçamentos',
    description: 'Crie e envie orçamentos',
    icon: Icons.request_quote_outlined,
  ),
  DashboardModule(
    id: DashboardModuleId.settings,
    title: 'Configurações',
    description: 'Dados da empresa',
    icon: Icons.settings_outlined,
  ),
];
