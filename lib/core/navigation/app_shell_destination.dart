import 'package:flutter/material.dart';

import '../../app/router/app_router.dart';

/// Top-level shell destinations shared by rail and drawer.
class AppShellDestination {
  const AppShellDestination({
    required this.label,
    required this.icon,
    required this.route,
    required this.matchPrefixes,
  });

  final String label;
  final IconData icon;
  final String route;
  final List<String> matchPrefixes;
}

const List<AppShellDestination> appShellDestinations = [
  AppShellDestination(
    label: 'Operações',
    icon: Icons.dashboard_outlined,
    route: AppRoutes.dashboard,
    matchPrefixes: [AppRoutes.dashboard],
  ),
  AppShellDestination(
    label: 'Clientes',
    icon: Icons.people_outline,
    route: AppRoutes.clients,
    matchPrefixes: [AppRoutes.clients],
  ),
  AppShellDestination(
    label: 'Catálogo',
    icon: Icons.inventory_2_outlined,
    route: AppRoutes.catalog,
    matchPrefixes: [AppRoutes.catalog],
  ),
  AppShellDestination(
    label: 'Orçamentos',
    icon: Icons.request_quote_outlined,
    route: AppRoutes.quotes,
    matchPrefixes: [AppRoutes.quotes],
  ),
  AppShellDestination(
    label: 'Agenda',
    icon: Icons.calendar_month_outlined,
    route: AppRoutes.agenda,
    matchPrefixes: [AppRoutes.agenda],
  ),
  AppShellDestination(
    label: 'Financeiro',
    icon: Icons.account_balance_wallet_outlined,
    route: AppRoutes.financial,
    matchPrefixes: [AppRoutes.financial],
  ),
  AppShellDestination(
    label: 'Estoque',
    icon: Icons.handyman_outlined,
    route: AppRoutes.equipment,
    matchPrefixes: [AppRoutes.equipment],
  ),
  AppShellDestination(
    label: 'Equipe',
    icon: Icons.groups_outlined,
    route: AppRoutes.team,
    matchPrefixes: [AppRoutes.team],
  ),
  AppShellDestination(
    label: 'Logística',
    icon: Icons.local_shipping_outlined,
    route: AppRoutes.vehicles,
    matchPrefixes: [AppRoutes.vehicles],
  ),
  AppShellDestination(
    label: 'Contratos',
    icon: Icons.handshake_outlined,
    route: AppRoutes.contracts,
    matchPrefixes: [AppRoutes.contracts],
  ),
  AppShellDestination(
    label: 'Faturamento',
    icon: Icons.receipt_long_outlined,
    route: AppRoutes.invoices,
    matchPrefixes: [AppRoutes.invoices],
  ),
  AppShellDestination(
    label: 'Configurações',
    icon: Icons.settings_outlined,
    route: AppRoutes.settings,
    matchPrefixes: [AppRoutes.settings],
  ),
];

int appShellSelectedIndex(String location) {
  for (var index = 0; index < appShellDestinations.length; index++) {
    final destination = appShellDestinations[index];
    for (final prefix in destination.matchPrefixes) {
      if (location == prefix || location.startsWith('$prefix/')) {
        return index;
      }
    }
  }
  return 0;
}
