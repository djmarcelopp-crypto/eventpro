import '../../agenda/models/agenda_occupancy.dart';
import '../../billing/models/invoice.dart';
import '../../contracts/models/contract.dart';
import '../../quotes/models/quote.dart';
import 'dashboard_activity_item.dart';
import 'dashboard_alert.dart';

/// Read-only presentation snapshot for the operations dashboard.
///
/// Built only from existing module data — no new domain rules or totals.
class DashboardOperationsSnapshot {
  const DashboardOperationsSnapshot({
    required this.eventsToday,
    required this.eventsThisWeek,
    required this.agendaNextDays,
    required this.pendingQuotes,
    required this.contractsAwaitingSignature,
    required this.issuedInvoices,
    required this.plannedRevenueCents,
    required this.receivedRevenueCents,
    required this.unavailableEquipmentCount,
    required this.unavailableTeamCount,
    required this.unavailableVehicleCount,
    required this.upcomingEvents,
    required this.latestContracts,
    required this.latestInvoices,
    required this.alerts,
    required this.recentActivities,
  });

  static const empty = DashboardOperationsSnapshot(
    eventsToday: [],
    eventsThisWeek: [],
    agendaNextDays: [],
    pendingQuotes: [],
    contractsAwaitingSignature: [],
    issuedInvoices: [],
    plannedRevenueCents: 0,
    receivedRevenueCents: 0,
    unavailableEquipmentCount: 0,
    unavailableTeamCount: 0,
    unavailableVehicleCount: 0,
    upcomingEvents: [],
    latestContracts: [],
    latestInvoices: [],
    alerts: [],
    recentActivities: [],
  );

  final List<AgendaOccupancy> eventsToday;
  final List<AgendaOccupancy> eventsThisWeek;
  final List<AgendaOccupancy> agendaNextDays;
  final List<Quote> pendingQuotes;
  final List<Contract> contractsAwaitingSignature;
  final List<Invoice> issuedInvoices;

  /// Existing [InvoiceListSummary.totalPendingCents] surface.
  final int plannedRevenueCents;

  /// Existing [InvoiceListSummary.totalPaidCents] surface.
  final int receivedRevenueCents;

  final int unavailableEquipmentCount;
  final int unavailableTeamCount;
  final int unavailableVehicleCount;
  final List<AgendaOccupancy> upcomingEvents;
  final List<Contract> latestContracts;
  final List<Invoice> latestInvoices;
  final List<DashboardAlert> alerts;
  final List<DashboardActivityItem> recentActivities;
}
