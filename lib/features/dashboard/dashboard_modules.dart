import 'package:flutter/material.dart';

enum DashboardModuleId {
  clients,
  catalog,
  quotes,
  agenda,
  financial,
  equipment,
  team,
  logistics,
  contracts,
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
    id: DashboardModuleId.agenda,
    title: 'Agenda',
    description: 'Propostas, eventos confirmados e bloqueios',
    icon: Icons.calendar_month_outlined,
  ),
  DashboardModule(
    id: DashboardModuleId.financial,
    title: 'Financeiro',
    description: 'Receitas, despesas e saldo',
    icon: Icons.account_balance_wallet_outlined,
  ),
  DashboardModule(
    id: DashboardModuleId.equipment,
    title: 'Estoque',
    description: 'Equipamentos e inventário',
    icon: Icons.handyman_outlined,
  ),
  DashboardModule(
    id: DashboardModuleId.team,
    title: 'Equipe',
    description: 'Colaboradores e funções',
    icon: Icons.groups_outlined,
  ),
  DashboardModule(
    id: DashboardModuleId.logistics,
    title: 'Logística',
    description: 'Veículos e transporte',
    icon: Icons.local_shipping_outlined,
  ),
  DashboardModule(
    id: DashboardModuleId.contracts,
    title: 'Contratos',
    description: 'Modelos e assinaturas',
    icon: Icons.handshake_outlined,
  ),
  DashboardModule(
    id: DashboardModuleId.settings,
    title: 'Configurações',
    description: 'Dados da empresa',
    icon: Icons.settings_outlined,
  ),
];
