import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_page_header.dart';
import '../agenda/models/agenda_occupancy.dart';
import '../billing/models/invoice_status.dart';
import '../contracts/models/contract_status.dart';
import '../quotes/utils/quote_date_formatter.dart';
import '../quotes/utils/quote_money_display.dart';
import '../settings/providers/company_profile_provider.dart';
import '../settings/utils/company_profile_presenter.dart';
import 'dashboard_modules.dart';
import 'models/dashboard_operations_snapshot.dart';
import 'providers/dashboard_operations_provider.dart';
import 'widgets/dashboard_alerts_card.dart';
import 'widgets/dashboard_entity_list_card.dart';
import 'widgets/dashboard_kpi_card.dart';
import 'widgets/dashboard_section_header.dart';
import 'widgets/dashboard_shortcut_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const _maxContentWidth = 1200.0;
  static const _horizontalPadding = 24.0;
  static const _sectionSpacing = 32.0;
  static const _gridSpacing = 16.0;

  int _columnCountForWidth(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 2;
    return 1;
  }

  int _kpiColumnCountForWidth(double width) {
    if (width >= 1100) return 4;
    if (width >= 800) return 3;
    if (width >= 560) return 2;
    return 1;
  }

  double _contentWidthFor(double bodyWidth) {
    return (bodyWidth - (_horizontalPadding * 2)).clamp(0, _maxContentWidth);
  }

  double _cardWidthFor(double bodyWidth, int columnCount) {
    final contentWidth = _contentWidthFor(bodyWidth);
    final totalSpacing = _gridSpacing * (columnCount - 1);
    return (contentWidth - totalSpacing) / columnCount;
  }

  static String _occupancyKindLabel(AgendaOccupancyKind kind) {
    return switch (kind) {
      AgendaOccupancyKind.proposal => 'Proposta',
      AgendaOccupancyKind.confirmed => 'Confirmado',
      AgendaOccupancyKind.block => 'Bloqueio',
    };
  }

  void _onModuleTap(BuildContext context, DashboardModuleId id) {
    // Prefer go() for module switches to keep navigation shallow and fluid.
    switch (id) {
      case DashboardModuleId.clients:
        context.go(AppRoutes.clients);
      case DashboardModuleId.catalog:
        context.go(AppRoutes.catalog);
      case DashboardModuleId.quotes:
        context.go(AppRoutes.quotes);
      case DashboardModuleId.agenda:
        context.go(AppRoutes.agenda);
      case DashboardModuleId.financial:
        context.go(AppRoutes.financial);
      case DashboardModuleId.equipment:
        context.go(AppRoutes.equipment);
      case DashboardModuleId.team:
        context.go(AppRoutes.team);
      case DashboardModuleId.logistics:
        context.go(AppRoutes.vehicles);
      case DashboardModuleId.contracts:
        context.go(AppRoutes.contracts);
      case DashboardModuleId.billing:
        context.go(AppRoutes.invoices);
      case DashboardModuleId.settings:
        context.go(AppRoutes.settings);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(companyProfileProvider);
    final companyLine = profile == null
        ? 'DJ Marcelo PP Festas e Eventos'
        : CompanyProfilePresenter.displayName(profile);
    final operationsAsync = ref.watch(dashboardOperationsProvider);

    return Scaffold(
      appBar: const AppPageHeader(title: 'Centro de Operações'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final moduleColumns = _columnCountForWidth(constraints.maxWidth);
          final kpiColumns = _kpiColumnCountForWidth(constraints.maxWidth);
          final listColumns = constraints.maxWidth >= 900 ? 2 : 1;

          return SingleChildScrollView(
            key: const Key('dashboard_operations_scroll'),
            padding: const EdgeInsets.all(_horizontalPadding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bem-vindo ao EventPro',
                      style: AppTextStyles.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      companyLine,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.mutedWhite,
                      ),
                    ),
                    const SizedBox(height: _sectionSpacing),
                    const DashboardSectionHeader(title: 'Módulos'),
                    const SizedBox(height: _gridSpacing),
                    Wrap(
                      spacing: _gridSpacing,
                      runSpacing: _gridSpacing,
                      children: [
                        for (final module in dashboardModules)
                          SizedBox(
                            width: _cardWidthFor(
                              constraints.maxWidth,
                              moduleColumns,
                            ),
                            child: DashboardShortcutCard(
                              module: module,
                              onTap: () => _onModuleTap(context, module.id),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: _sectionSpacing),
                    operationsAsync.when(
                      data: (snapshot) => _OperationsBody(
                        snapshot: snapshot,
                        bodyWidth: constraints.maxWidth,
                        kpiColumns: kpiColumns,
                        listColumns: listColumns,
                        cardWidthFor: _cardWidthFor,
                        gridSpacing: _gridSpacing,
                        sectionSpacing: _sectionSpacing,
                        occupancyKindLabel: _occupancyKindLabel,
                      ),
                      loading: () => _OperationsBody(
                        snapshot: DashboardOperationsSnapshot.empty,
                        bodyWidth: constraints.maxWidth,
                        kpiColumns: kpiColumns,
                        listColumns: listColumns,
                        cardWidthFor: _cardWidthFor,
                        gridSpacing: _gridSpacing,
                        sectionSpacing: _sectionSpacing,
                        occupancyKindLabel: _occupancyKindLabel,
                      ),
                      error: (_, _) => Text(
                        'Não foi possível carregar o centro de operações.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OperationsBody extends StatelessWidget {
  const _OperationsBody({
    required this.snapshot,
    required this.bodyWidth,
    required this.kpiColumns,
    required this.listColumns,
    required this.cardWidthFor,
    required this.gridSpacing,
    required this.sectionSpacing,
    required this.occupancyKindLabel,
  });

  final DashboardOperationsSnapshot snapshot;
  final double bodyWidth;
  final int kpiColumns;
  final int listColumns;
  final double Function(double bodyWidth, int columnCount) cardWidthFor;
  final double gridSpacing;
  final double sectionSpacing;
  final String Function(AgendaOccupancyKind kind) occupancyKindLabel;

  @override
  Widget build(BuildContext context) {
    final kpiWidth = cardWidthFor(bodyWidth, kpiColumns);
    final listWidth = cardWidthFor(bodyWidth, listColumns);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionHeader(title: 'Indicadores operacionais'),
        const SizedBox(height: 12),
        Wrap(
          key: const Key('dashboard_kpi_grid'),
          spacing: gridSpacing,
          runSpacing: gridSpacing,
          children: [
            SizedBox(
              width: kpiWidth,
              child: DashboardKpiCard(
                key: const Key('dashboard_kpi_events_today'),
                label: 'Eventos de hoje',
                value: '${snapshot.eventsToday.length}',
                icon: Icons.today_outlined,
                onTap: () => context.push(AppRoutes.agenda),
              ),
            ),
            SizedBox(
              width: kpiWidth,
              child: DashboardKpiCard(
                key: const Key('dashboard_kpi_events_week'),
                label: 'Eventos da semana',
                value: '${snapshot.eventsThisWeek.length}',
                icon: Icons.date_range_outlined,
                onTap: () => context.push(AppRoutes.agenda),
              ),
            ),
            SizedBox(
              width: kpiWidth,
              child: DashboardKpiCard(
                key: const Key('dashboard_kpi_pending_quotes'),
                label: 'Orçamentos pendentes',
                value: '${snapshot.pendingQuotes.length}',
                icon: Icons.request_quote_outlined,
                onTap: () => context.push(AppRoutes.quotes),
              ),
            ),
            SizedBox(
              width: kpiWidth,
              child: DashboardKpiCard(
                key: const Key('dashboard_kpi_contracts_waiting'),
                label: 'Contratos aguardando assinatura',
                value: '${snapshot.contractsAwaitingSignature.length}',
                icon: Icons.draw_outlined,
                onTap: () => context.push(AppRoutes.contracts),
              ),
            ),
            SizedBox(
              width: kpiWidth,
              child: DashboardKpiCard(
                key: const Key('dashboard_kpi_issued_invoices'),
                label: 'Faturamentos emitidos',
                value: '${snapshot.issuedInvoices.length}',
                icon: Icons.receipt_long_outlined,
                onTap: () => context.push(AppRoutes.invoices),
              ),
            ),
            SizedBox(
              width: kpiWidth,
              child: DashboardKpiCard(
                key: const Key('dashboard_kpi_planned_revenue'),
                label: 'Receita prevista',
                value: QuoteMoneyDisplay.format(snapshot.plannedRevenueCents),
                icon: Icons.trending_up,
                onTap: () => context.push(AppRoutes.invoices),
              ),
            ),
            SizedBox(
              width: kpiWidth,
              child: DashboardKpiCard(
                key: const Key('dashboard_kpi_received_revenue'),
                label: 'Receita recebida',
                value: QuoteMoneyDisplay.format(snapshot.receivedRevenueCents),
                icon: Icons.payments_outlined,
                onTap: () => context.push(AppRoutes.financial),
              ),
            ),
            SizedBox(
              width: kpiWidth,
              child: DashboardKpiCard(
                key: const Key('dashboard_kpi_equipment_unavailable'),
                label: 'Equipamentos indisponíveis',
                value: '${snapshot.unavailableEquipmentCount}',
                icon: Icons.handyman_outlined,
                onTap: () => context.push(AppRoutes.equipment),
              ),
            ),
            SizedBox(
              width: kpiWidth,
              child: DashboardKpiCard(
                key: const Key('dashboard_kpi_team_unavailable'),
                label: 'Equipe indisponível',
                value: '${snapshot.unavailableTeamCount}',
                icon: Icons.groups_outlined,
                onTap: () => context.push(AppRoutes.team),
              ),
            ),
            SizedBox(
              width: kpiWidth,
              child: DashboardKpiCard(
                key: const Key('dashboard_kpi_vehicles_unavailable'),
                label: 'Veículos indisponíveis',
                value: '${snapshot.unavailableVehicleCount}',
                icon: Icons.local_shipping_outlined,
                onTap: () => context.push(AppRoutes.vehicles),
              ),
            ),
          ],
        ),
        SizedBox(height: sectionSpacing),
        const DashboardSectionHeader(title: 'Alertas operacionais'),
        const SizedBox(height: 12),
        DashboardAlertsCard(alerts: snapshot.alerts),
        SizedBox(height: sectionSpacing),
        Wrap(
          spacing: gridSpacing,
          runSpacing: gridSpacing,
          children: [
            SizedBox(
              width: listWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardSectionHeader(
                    title: 'Agenda dos próximos dias',
                    actionLabel: 'Abrir',
                    onAction: () => context.push(AppRoutes.agenda),
                  ),
                  const SizedBox(height: 12),
                  DashboardEntityListCard(
                    key: const Key('dashboard_agenda_next_days'),
                    emptyMessage: 'Nenhum compromisso nos próximos dias.',
                    items: [
                      for (final item in snapshot.agendaNextDays)
                        DashboardEntityListItem(
                          title: item.title,
                          subtitle:
                              '${QuoteDateFormatter.format(item.start)} · '
                              '${occupancyKindLabel(item.kind)}',
                          onTap: item.sourceQuoteId == null
                              ? () => context.push(AppRoutes.agenda)
                              : () => context.push(
                                    AppRoutes.quotesDetail(item.sourceQuoteId!),
                                  ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: listWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardSectionHeader(
                    title: 'Próximos eventos',
                    actionLabel: 'Abrir',
                    onAction: () => context.push(AppRoutes.agenda),
                  ),
                  const SizedBox(height: 12),
                  DashboardEntityListCard(
                    key: const Key('dashboard_upcoming_events'),
                    emptyMessage: 'Nenhum evento futuro.',
                    items: [
                      for (final item in snapshot.upcomingEvents)
                        DashboardEntityListItem(
                          title: item.title,
                          subtitle: QuoteDateFormatter.format(item.start),
                          onTap: item.sourceQuoteId == null
                              ? null
                              : () => context.push(
                                    AppRoutes.quotesDetail(item.sourceQuoteId!),
                                  ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: listWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardSectionHeader(
                    title: 'Últimos contratos',
                    actionLabel: 'Abrir',
                    onAction: () => context.push(AppRoutes.contracts),
                  ),
                  const SizedBox(height: 12),
                  DashboardEntityListCard(
                    key: const Key('dashboard_latest_contracts'),
                    emptyMessage: 'Nenhum contrato recente.',
                    items: [
                      for (final item in snapshot.latestContracts)
                        DashboardEntityListItem(
                          title: item.contractNumber,
                          subtitle: item.status.label,
                          onTap: () => context.push(
                            AppRoutes.contractDetail(item.id),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: listWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardSectionHeader(
                    title: 'Últimos faturamentos',
                    actionLabel: 'Abrir',
                    onAction: () => context.push(AppRoutes.invoices),
                  ),
                  const SizedBox(height: 12),
                  DashboardEntityListCard(
                    key: const Key('dashboard_latest_invoices'),
                    emptyMessage: 'Nenhum faturamento recente.',
                    items: [
                      for (final item in snapshot.latestInvoices)
                        DashboardEntityListItem(
                          title: item.invoiceNumber,
                          subtitle:
                              '${item.status.label} · '
                              '${QuoteMoneyDisplay.format(item.totalCents)}',
                          onTap: () => context.push(
                            AppRoutes.invoiceDetail(item.id),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: listWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardSectionHeader(title: 'Atividades recentes'),
                  const SizedBox(height: 12),
                  DashboardEntityListCard(
                    key: const Key('dashboard_recent_activities'),
                    emptyMessage: 'Nenhuma atividade recente.',
                    items: [
                      for (final item in snapshot.recentActivities)
                        DashboardEntityListItem(
                          title: item.title,
                          subtitle: item.subtitle,
                          onTap: item.route == null
                              ? null
                              : () => context.push(item.route!),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
