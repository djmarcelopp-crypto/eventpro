import 'package:eventpro/features/agenda/models/agenda_occupancy.dart';
import 'package:eventpro/features/billing/models/invoice_list_summary.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/dashboard/utils/dashboard_operations_builder.dart';
import 'package:eventpro/features/equipment/models/equipment_list_summary.dart';
import 'package:eventpro/features/logistics/models/vehicle_list_summary.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/team/models/team_list_summary.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../billing/billing_test_helpers.dart' as billing;
import '../../contracts/contracts_test_helpers.dart' as contracts;

void main() {
  group('DashboardOperationsBuilder', () {
    final now = DateTime(2026, 7, 17, 12);

    test('assembles KPIs from existing module data without new totals', () {
      final snapshot = DashboardOperationsBuilder.build(
        clock: () => now,
        occupancy: [
          AgendaOccupancy(
            id: 'q1',
            kind: AgendaOccupancyKind.confirmed,
            title: 'Casamento',
            start: DateTime(2026, 7, 17, 18),
            end: DateTime(2026, 7, 17, 23),
            sourceQuoteId: 'quote-1',
          ),
          AgendaOccupancy(
            id: 'q2',
            kind: AgendaOccupancyKind.proposal,
            title: 'Aniversário',
            start: DateTime(2026, 7, 20, 18),
            end: DateTime(2026, 7, 20, 23),
            sourceQuoteId: 'quote-2',
          ),
        ],
        quotes: [
          contracts.buildTestQuote(id: 'quote-1').copyWith(
                status: QuoteStatus.sent,
              ),
          contracts.buildTestQuote(id: 'quote-2').copyWith(
                status: QuoteStatus.approved,
              ),
        ],
        contracts: [
          contracts.buildTestContract(
            id: 'c-1',
            status: ContractStatus.sent,
            sentAt: DateTime(2026, 7, 16),
          ),
        ],
        invoices: [
          billing.buildTestInvoice(
            id: 'i-1',
            status: InvoiceStatus.issued,
            totalCents: 5000,
          ),
          billing.buildTestInvoice(
            id: 'i-2',
            invoiceNumber: 'INV-2026-0002',
            status: InvoiceStatus.paid,
            totalCents: 9000,
          ),
        ],
        invoiceSummary: const InvoiceListSummary(
          total: 2,
          draft: 0,
          issued: 1,
          paid: 1,
          cancelled: 0,
          totalBilledCents: 14000,
          totalPaidCents: 9000,
          totalPendingCents: 5000,
        ),
        equipmentSummary: const EquipmentListSummary(
          totalItems: 3,
          totalQuantity: 10,
          availableCount: 1,
          reservedCount: 1,
          maintenanceCount: 1,
          inactiveCount: 0,
        ),
        teamSummary: const TeamListSummary(
          totalMembers: 4,
          activeCount: 2,
          unavailableCount: 1,
          inactiveCount: 1,
          rolesCount: 2,
        ),
        vehicleSummary: const VehicleListSummary(
          total: 3,
          available: 1,
          maintenance: 1,
          unavailable: 1,
          inactive: 0,
          typeCount: 1,
        ),
      );

      expect(snapshot.eventsToday, hasLength(1));
      expect(snapshot.eventsThisWeek, hasLength(2));
      expect(snapshot.pendingQuotes, hasLength(1));
      expect(snapshot.contractsAwaitingSignature, hasLength(1));
      expect(snapshot.issuedInvoices, hasLength(1));
      expect(snapshot.plannedRevenueCents, 5000);
      expect(snapshot.receivedRevenueCents, 9000);
      expect(snapshot.unavailableEquipmentCount, 2);
      expect(snapshot.unavailableTeamCount, 1);
      expect(snapshot.unavailableVehicleCount, 2);
      expect(snapshot.alerts, isNotEmpty);
      expect(snapshot.recentActivities, isNotEmpty);
    });
  });
}
