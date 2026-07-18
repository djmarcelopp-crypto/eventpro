import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../agenda/providers/agenda_occupancy_provider.dart';
import '../../billing/models/invoice_list_summary.dart';
import '../../billing/providers/invoice_list_summary_provider.dart';
import '../../billing/providers/invoice_provider.dart';
import '../../contracts/providers/contract_provider.dart';
import '../../equipment/models/equipment_list_summary.dart';
import '../../equipment/providers/equipment_list_summary_provider.dart';
import '../../logistics/models/vehicle_list_summary.dart';
import '../../logistics/providers/vehicle_list_summary_provider.dart';
import '../../quotes/providers/quotes_provider.dart';
import '../../team/models/team_list_summary.dart';
import '../../team/providers/team_list_summary_provider.dart';
import '../models/dashboard_operations_snapshot.dart';
import '../utils/dashboard_operations_builder.dart';

/// Assembles the operations dashboard from existing feature providers only.
final dashboardOperationsProvider =
    Provider<AsyncValue<DashboardOperationsSnapshot>>((ref) {
  final occupancyAsync = ref.watch(agendaOccupancyProvider);
  final contractsAsync = ref.watch(contractProvider);
  final invoicesAsync = ref.watch(invoiceProvider);
  final invoiceSummaryAsync = ref.watch(invoiceListSummaryProvider);
  final equipmentSummaryAsync = ref.watch(equipmentListSummaryProvider);
  final teamSummaryAsync = ref.watch(teamListSummaryProvider);
  final vehicleSummaryAsync = ref.watch(vehicleListSummaryProvider);
  final quotes = ref.watch(quotesProvider);

  if (occupancyAsync.isLoading ||
      contractsAsync.isLoading ||
      invoicesAsync.isLoading ||
      invoiceSummaryAsync.isLoading ||
      equipmentSummaryAsync.isLoading ||
      teamSummaryAsync.isLoading ||
      vehicleSummaryAsync.isLoading) {
    return const AsyncValue.loading();
  }

  final occupancyError = occupancyAsync.error;
  if (occupancyError != null) {
    return AsyncValue.error(occupancyError, occupancyAsync.stackTrace!);
  }
  final contractsError = contractsAsync.error;
  if (contractsError != null) {
    return AsyncValue.error(contractsError, contractsAsync.stackTrace!);
  }
  final invoicesError = invoicesAsync.error;
  if (invoicesError != null) {
    return AsyncValue.error(invoicesError, invoicesAsync.stackTrace!);
  }

  return AsyncValue.data(
    DashboardOperationsBuilder.build(
      occupancy: occupancyAsync.value ?? const [],
      quotes: quotes,
      contracts: contractsAsync.value ?? const [],
      invoices: invoicesAsync.value ?? const [],
      invoiceSummary: invoiceSummaryAsync.value ?? InvoiceListSummary.empty,
      equipmentSummary:
          equipmentSummaryAsync.value ?? EquipmentListSummary.empty,
      teamSummary: teamSummaryAsync.value ?? TeamListSummary.empty,
      vehicleSummary: vehicleSummaryAsync.value ?? VehicleListSummary.empty,
    ),
  );
});
