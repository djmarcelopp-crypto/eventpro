import '../../../app/router/app_router.dart';
import '../../agenda/models/agenda_occupancy.dart';
import '../../billing/models/invoice.dart';
import '../../billing/models/invoice_list_summary.dart';
import '../../billing/models/invoice_status.dart';
import '../../contracts/models/contract.dart';
import '../../contracts/models/contract_status.dart';
import '../../equipment/models/equipment_list_summary.dart';
import '../../logistics/models/vehicle_list_summary.dart';
import '../../quotes/models/quote.dart';
import '../../quotes/models/quote_status.dart';
import '../../team/models/team_list_summary.dart';
import '../models/dashboard_activity_item.dart';
import '../models/dashboard_alert.dart';
import '../models/dashboard_operations_snapshot.dart';

/// Presentation assembler for the operations dashboard.
///
/// Only filters, sorts and maps already-computed module data:
/// - revenue KPIs reuse [InvoiceListSummary] totals (no new formulas);
/// - status filters use existing enum values for UI grouping only;
/// - unavailable counts reuse module list summaries (no availability matrix).
///
/// Does not invent financial formulas, status transitions, or domain rules.
abstract class DashboardOperationsBuilder {
  static DashboardOperationsSnapshot build({
    required List<AgendaOccupancy> occupancy,
    required List<Quote> quotes,
    required List<Contract> contracts,
    required List<Invoice> invoices,
    required InvoiceListSummary invoiceSummary,
    required EquipmentListSummary equipmentSummary,
    required TeamListSummary teamSummary,
    required VehicleListSummary vehicleSummary,
    DateTime Function()? clock,
    int recentLimit = 5,
    int upcomingLimit = 8,
    int agendaHorizonDays = 7,
  }) {
    final now = clock?.call() ?? DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));
    final weekEnd = todayStart.add(const Duration(days: 7));
    final horizonEnd = todayStart.add(Duration(days: agendaHorizonDays));

    final eventOccupancies = occupancy
        .where(
          (item) =>
              item.kind == AgendaOccupancyKind.confirmed ||
              item.kind == AgendaOccupancyKind.proposal,
        )
        .toList(growable: false);

    final eventsToday = eventOccupancies
        .where(
          (item) =>
              !item.start.isBefore(todayStart) && item.start.isBefore(tomorrowStart),
        )
        .toList(growable: false);

    final eventsThisWeek = eventOccupancies
        .where(
          (item) =>
              !item.start.isBefore(todayStart) && item.start.isBefore(weekEnd),
        )
        .toList(growable: false);

    final agendaNextDays = occupancy
        .where(
          (item) =>
              !item.start.isBefore(todayStart) && item.start.isBefore(horizonEnd),
        )
        .toList(growable: false)
      ..sort((a, b) => a.start.compareTo(b.start));

    final upcomingEvents = eventOccupancies
        .where((item) => !item.start.isBefore(now))
        .toList(growable: false)
      ..sort((a, b) => a.start.compareTo(b.start));
    final upcoming = upcomingEvents.take(upcomingLimit).toList(growable: false);

    final pendingQuotes = quotes
        .where(
          (quote) =>
              quote.status == QuoteStatus.draft ||
              quote.status == QuoteStatus.sent,
        )
        .toList(growable: false)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final awaitingSignature = contracts
        .where((contract) => contract.status == ContractStatus.sent)
        .toList(growable: false)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final issued = invoices
        .where((invoice) => invoice.status == InvoiceStatus.issued)
        .toList(growable: false)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final latestContracts = [...contracts]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final latestInvoices = [...invoices]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final unavailableEquipment =
        equipmentSummary.reservedCount + equipmentSummary.maintenanceCount;

    final alerts = <DashboardAlert>[
      if (eventsToday.isNotEmpty)
        DashboardAlert(
          id: 'events-today',
          message: '${eventsToday.length} evento(s) hoje',
          severity: DashboardAlertSeverity.info,
          route: AppRoutes.agenda,
        ),
      if (pendingQuotes.isNotEmpty)
        DashboardAlert(
          id: 'pending-quotes',
          message: '${pendingQuotes.length} orçamento(s) pendente(s)',
          severity: DashboardAlertSeverity.warning,
          route: AppRoutes.quotes,
        ),
      if (awaitingSignature.isNotEmpty)
        DashboardAlert(
          id: 'contracts-sent',
          message:
              '${awaitingSignature.length} contrato(s) aguardando assinatura',
          severity: DashboardAlertSeverity.warning,
          route: AppRoutes.contracts,
        ),
      if (issued.isNotEmpty)
        DashboardAlert(
          id: 'invoices-issued',
          message: '${issued.length} faturamento(s) emitido(s) pendente(s)',
          severity: DashboardAlertSeverity.info,
          route: AppRoutes.invoices,
        ),
      if (unavailableEquipment > 0)
        DashboardAlert(
          id: 'equipment-unavailable',
          message: '$unavailableEquipment equipamento(s) indisponível(is)',
          severity: DashboardAlertSeverity.warning,
          route: AppRoutes.equipment,
        ),
      if (teamSummary.unavailableCount > 0)
        DashboardAlert(
          id: 'team-unavailable',
          message: '${teamSummary.unavailableCount} colaborador(es) indisponível(is)',
          severity: DashboardAlertSeverity.warning,
          route: AppRoutes.team,
        ),
      if (vehicleSummary.unavailable + vehicleSummary.maintenance > 0)
        DashboardAlert(
          id: 'vehicles-unavailable',
          message:
              '${vehicleSummary.unavailable + vehicleSummary.maintenance} veículo(s) indisponível(is)',
          severity: DashboardAlertSeverity.warning,
          route: AppRoutes.vehicles,
        ),
    ];

    final activities = <DashboardActivityItem>[
      for (final contract in latestContracts.take(recentLimit))
        DashboardActivityItem(
          id: 'contract-${contract.id}',
          kind: DashboardActivityKind.contract,
          title: contract.contractNumber,
          subtitle: 'Contrato · ${contract.status.label}',
          occurredAt: contract.updatedAt,
          route: AppRoutes.contractDetail(contract.id),
        ),
      for (final invoice in latestInvoices.take(recentLimit))
        DashboardActivityItem(
          id: 'invoice-${invoice.id}',
          kind: DashboardActivityKind.invoice,
          title: invoice.invoiceNumber,
          subtitle: 'Faturamento · ${invoice.status.label}',
          occurredAt: invoice.updatedAt,
          route: AppRoutes.invoiceDetail(invoice.id),
        ),
      for (final quote in pendingQuotes.take(recentLimit))
        DashboardActivityItem(
          id: 'quote-${quote.id}',
          kind: DashboardActivityKind.quote,
          title: quote.number,
          subtitle: 'Orçamento · ${quote.status.label}',
          occurredAt: quote.updatedAt,
          route: AppRoutes.quotesDetail(quote.id),
        ),
    ]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    return DashboardOperationsSnapshot(
      eventsToday: eventsToday,
      eventsThisWeek: eventsThisWeek,
      agendaNextDays: agendaNextDays.take(upcomingLimit).toList(growable: false),
      pendingQuotes: pendingQuotes,
      contractsAwaitingSignature: awaitingSignature,
      issuedInvoices: issued,
      plannedRevenueCents: invoiceSummary.totalPendingCents,
      receivedRevenueCents: invoiceSummary.totalPaidCents,
      unavailableEquipmentCount: unavailableEquipment,
      unavailableTeamCount: teamSummary.unavailableCount,
      unavailableVehicleCount:
          vehicleSummary.unavailable + vehicleSummary.maintenance,
      upcomingEvents: upcoming,
      latestContracts: latestContracts.take(recentLimit).toList(growable: false),
      latestInvoices: latestInvoices.take(recentLimit).toList(growable: false),
      alerts: alerts,
      recentActivities: activities.take(recentLimit * 2).toList(growable: false),
    );
  }
}
