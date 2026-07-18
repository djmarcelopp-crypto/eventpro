import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/agenda/data/repositories/agenda_block_repository.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:eventpro/features/billing/models/invoice_item_input.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:eventpro/features/billing/utils/invoice_service.dart';
import 'package:eventpro/features/billing/data/repositories/invoice_repository.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/data/repositories/client_repository.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/contracts/data/repositories/contract_repository.dart';
import 'package:eventpro/features/contracts/utils/contract_service.dart';
import 'package:eventpro/features/contracts/utils/quote_contract_service.dart';
import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:eventpro/features/equipment/utils/equipment_category_service.dart';
import 'package:eventpro/features/equipment/utils/equipment_service.dart';
import 'package:eventpro/features/equipment/data/repositories/equipment_repository.dart';
import 'package:eventpro/features/equipment/data/repositories/equipment_category_repository.dart';
import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_entry_status.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/utils/financial_category_service.dart';
import 'package:eventpro/features/financial/utils/financial_entry_service.dart';
import 'package:eventpro/features/financial/data/repositories/financial_entry_repository.dart';
import 'package:eventpro/features/financial/data/repositories/financial_category_repository.dart';
import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/models/vehicle_type.dart';
import 'package:eventpro/features/logistics/utils/vehicle_service.dart';
import 'package:eventpro/features/logistics/utils/vehicle_type_service.dart';
import 'package:eventpro/features/logistics/data/repositories/vehicle_repository.dart';
import 'package:eventpro/features/logistics/data/repositories/vehicle_type_repository.dart';
import 'package:eventpro/features/quotes/data/repositories/quote_repository.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_line_item.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/models/team_role.dart';
import 'package:eventpro/features/team/utils/team_member_service.dart';
import 'package:eventpro/features/team/utils/team_role_service.dart';
import 'package:eventpro/features/team/data/repositories/team_member_repository.dart';
import 'package:eventpro/features/team/data/repositories/team_role_repository.dart';

import '../data/demo_manifest_store.dart';
import '../models/demo_seed_manifest.dart';

/// Seeds a coherent operational demo company without touching schema.
///
/// Demo IDs are tracked in [DemoManifestStore] (file), not in SQLite columns.
class DemoSeeder {
  DemoSeeder({
    required AppDatabase database,
    required ClientRepository clientRepository,
    required QuoteRepository quoteRepository,
    required ContractService contractService,
    required QuoteContractService quoteContractService,
    required ContractRepository contractRepository,
    required InvoiceService invoiceService,
    required InvoiceRepository invoiceRepository,
    required TeamRoleService teamRoleService,
    required TeamMemberService teamMemberService,
    required TeamRoleRepository teamRoleRepository,
    required TeamMemberRepository teamMemberRepository,
    required EquipmentCategoryService equipmentCategoryService,
    required EquipmentService equipmentService,
    required EquipmentCategoryRepository equipmentCategoryRepository,
    required EquipmentRepository equipmentRepository,
    required VehicleTypeService vehicleTypeService,
    required VehicleService vehicleService,
    required VehicleTypeRepository vehicleTypeRepository,
    required VehicleRepository vehicleRepository,
    required FinancialCategoryService financialCategoryService,
    required FinancialEntryService financialEntryService,
    required FinancialCategoryRepository financialCategoryRepository,
    required FinancialEntryRepository financialEntryRepository,
    required AgendaBlockRepository agendaBlockRepository,
    DemoManifestStore? manifestStore,
    DateTime Function()? clock,
  })  : _database = database,
        _clientRepository = clientRepository,
        _quoteRepository = quoteRepository,
        _contractService = contractService,
        _quoteContractService = quoteContractService,
        _contractRepository = contractRepository,
        _invoiceService = invoiceService,
        _invoiceRepository = invoiceRepository,
        _teamRoleService = teamRoleService,
        _teamMemberService = teamMemberService,
        _teamRoleRepository = teamRoleRepository,
        _teamMemberRepository = teamMemberRepository,
        _equipmentCategoryService = equipmentCategoryService,
        _equipmentService = equipmentService,
        _equipmentCategoryRepository = equipmentCategoryRepository,
        _equipmentRepository = equipmentRepository,
        _vehicleTypeService = vehicleTypeService,
        _vehicleService = vehicleService,
        _vehicleTypeRepository = vehicleTypeRepository,
        _vehicleRepository = vehicleRepository,
        _financialCategoryService = financialCategoryService,
        _financialEntryService = financialEntryService,
        _financialCategoryRepository = financialCategoryRepository,
        _financialEntryRepository = financialEntryRepository,
        _agendaBlockRepository = agendaBlockRepository,
        _manifestStore = manifestStore ?? DemoManifestStore(),
        _clock = clock ?? DateTime.now;

  final AppDatabase _database;
  final ClientRepository _clientRepository;
  final QuoteRepository _quoteRepository;
  final ContractService _contractService;
  final QuoteContractService _quoteContractService;
  final ContractRepository _contractRepository;
  final InvoiceService _invoiceService;
  final InvoiceRepository _invoiceRepository;
  final TeamRoleService _teamRoleService;
  final TeamMemberService _teamMemberService;
  final TeamRoleRepository _teamRoleRepository;
  final TeamMemberRepository _teamMemberRepository;
  final EquipmentCategoryService _equipmentCategoryService;
  final EquipmentService _equipmentService;
  final EquipmentCategoryRepository _equipmentCategoryRepository;
  final EquipmentRepository _equipmentRepository;
  final VehicleTypeService _vehicleTypeService;
  final VehicleService _vehicleService;
  final VehicleTypeRepository _vehicleTypeRepository;
  final VehicleRepository _vehicleRepository;
  final FinancialCategoryService _financialCategoryService;
  final FinancialEntryService _financialEntryService;
  final FinancialCategoryRepository _financialCategoryRepository;
  final FinancialEntryRepository _financialEntryRepository;
  final AgendaBlockRepository _agendaBlockRepository;
  final DemoManifestStore _manifestStore;
  final DateTime Function() _clock;

  Future<bool> isSeeded() async {
    final manifest = await _manifestStore.read();
    return manifest != null && !manifest.isEmpty;
  }

  Future<DemoSeedManifest> seed() async {
    await clear();
    final now = _clock();
    final tracker = _DemoIdTracker();

    try {
      final client = Client.fromForm(
        id: 'demo-client-1',
        createdAt: now,
        type: ClientType.individual,
        name: 'Ana Souza',
        phone: '67999990001',
        whatsApp: '67999990001',
        email: 'ana.souza@example.com',
        city: 'Campo Grande',
        state: 'MS',
        internalNotes: 'Cliente demonstrativo EventPro',
      );
      await _clientRepository.insert(client);
      tracker.clientIds.add(client.id);

      final quoteToday = await _insertQuote(
        id: 'demo-quote-today',
        numberHint: 'DEMO-TODAY',
        client: client,
        status: QuoteStatus.approved,
        eventName: 'Casamento Ana & Pedro',
        eventDate: DateTime(now.year, now.month, now.day, 18),
        totalCents: 850000,
        now: now,
      );
      tracker.quoteIds.add(quoteToday.id);
      final quoteWeek = await _insertQuote(
        id: 'demo-quote-week',
        numberHint: 'DEMO-WEEK',
        client: client,
        status: QuoteStatus.sent,
        eventName: 'Aniversário 15 anos',
        eventDate: now.add(const Duration(days: 3)),
        totalCents: 420000,
        now: now,
      );
      tracker.quoteIds.add(quoteWeek.id);

      final contractGenerated = await _quoteContractService.generateForQuote(
        quoteId: quoteToday.id,
      );
      if (contractGenerated.contract != null) {
        tracker.contractIds.add(contractGenerated.contract!.id);
      }
      final contractDraft =
          await _contractService.create(quoteId: quoteWeek.id);
      if (contractDraft.contract != null) {
        tracker.contractIds.add(contractDraft.contract!.id);
      }

      final issued = await _invoiceService.create(
        quoteId: quoteToday.id,
        type: InvoiceType.service,
        invoiceNumber: 'INV-DEMO-0001',
        items: const [
          InvoiceItemInput(
            description: 'Pacote som e DJ',
            quantity: 1,
            unitPriceCents: 850000,
          ),
        ],
      );
      if (issued.isSuccess && issued.invoice != null) {
        tracker.invoiceIds.add(issued.invoice!.id);
        await _invoiceService.issue(issued.invoice!.id);
      }
      final paid = await _invoiceService.create(
        quoteId: quoteToday.id,
        type: InvoiceType.service,
        invoiceNumber: 'INV-DEMO-0002',
        items: const [
          InvoiceItemInput(
            description: 'Sinal do evento',
            quantity: 1,
            unitPriceCents: 200000,
          ),
        ],
      );
      if (paid.isSuccess && paid.invoice != null) {
        tracker.invoiceIds.add(paid.invoice!.id);
        await _invoiceService.issue(paid.invoice!.id);
        await _invoiceService.markPaid(paid.invoice!.id);
      }

      final roleResult = await _teamRoleService.create(
        TeamRole(
          id: 'tmp',
          name: 'DJ Demonstração',
          description: 'Função demo',
          createdAt: now,
          updatedAt: now,
        ),
      );
      final role = roleResult.role;
      if (role == null) {
        throw StateError('Demo seed failed: team role');
      }
      tracker.teamRoleIds.add(role.id);
      final memberResult = await _teamMemberService.create(
        TeamMember(
          id: 'tmp',
          name: 'Carlos Demo',
          phone: '67988887777',
          roleId: role.id,
          dailyRate: 80000,
          status: TeamMemberStatus.active,
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (memberResult.member != null) {
        tracker.teamMemberIds.add(memberResult.member!.id);
      }
      final unavailableMember = await _teamMemberService.create(
        TeamMember(
          id: 'tmp2',
          name: 'Marina Indisponível',
          phone: '67988886666',
          roleId: role.id,
          dailyRate: 70000,
          status: TeamMemberStatus.unavailable,
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (unavailableMember.member != null) {
        tracker.teamMemberIds.add(unavailableMember.member!.id);
      }

      final categoryResult = await _equipmentCategoryService.create(
        EquipmentCategory(
          id: 'tmp',
          name: 'Som Demo',
          createdAt: now,
          updatedAt: now,
        ),
      );
      final category = categoryResult.category;
      if (category == null) {
        throw StateError('Demo seed failed: equipment category');
      }
      tracker.equipmentCategoryIds.add(category.id);
      final equipmentAvailable = await _equipmentService.create(
        Equipment(
          id: 'tmp',
          name: 'Caixa Ativa Demo',
          categoryId: category.id,
          totalQuantity: 4,
          status: EquipmentStatus.available,
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (equipmentAvailable.equipment != null) {
        tracker.equipmentIds.add(equipmentAvailable.equipment!.id);
      }
      final equipmentMaintenance = await _equipmentService.create(
        Equipment(
          id: 'tmp2',
          name: 'Mesa Digital Demo',
          categoryId: category.id,
          totalQuantity: 1,
          status: EquipmentStatus.maintenance,
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (equipmentMaintenance.equipment != null) {
        tracker.equipmentIds.add(equipmentMaintenance.equipment!.id);
      }

      final typeResult = await _vehicleTypeService.create(
        VehicleType(
          id: 'tmp',
          name: 'Van Demo',
          createdAt: now,
          updatedAt: now,
        ),
      );
      final type = typeResult.type;
      if (type == null) {
        throw StateError('Demo seed failed: vehicle type');
      }
      tracker.vehicleTypeIds.add(type.id);
      final vehicleOk = await _vehicleService.create(
        Vehicle(
          id: 'tmp',
          plate: 'DEM1A23',
          vehicleTypeId: type.id,
          payloadCapacityKg: 800,
          volumeCapacityM3: 12,
          status: VehicleStatus.available,
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (vehicleOk.vehicle != null) {
        tracker.vehicleIds.add(vehicleOk.vehicle!.id);
      }
      final vehicleDown = await _vehicleService.create(
        Vehicle(
          id: 'tmp2',
          plate: 'DEM2B45',
          vehicleTypeId: type.id,
          payloadCapacityKg: 500,
          volumeCapacityM3: 8,
          status: VehicleStatus.unavailable,
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (vehicleDown.vehicle != null) {
        tracker.vehicleIds.add(vehicleDown.vehicle!.id);
      }

      final incomeCategory = await _financialCategoryService.create(
        FinancialCategory(
          id: 'tmp',
          name: 'Receitas Demo',
          kind: FinancialFlowKind.income,
          createdAt: now,
        ),
      );
      final incomeCat = incomeCategory.category;
      if (incomeCat == null) {
        throw StateError('Demo seed failed: financial category');
      }
      tracker.financialCategoryIds.add(incomeCat.id);
      final planned = await _financialEntryService.create(
        FinancialEntry(
          id: 'tmp',
          kind: FinancialFlowKind.income,
          description: 'Receita prevista casamento',
          amountCents: 650000,
          date: now,
          categoryId: incomeCat.id,
          status: FinancialEntryStatus.pending,
          quoteId: quoteToday.id,
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (planned.entry != null) {
        tracker.financialEntryIds.add(planned.entry!.id);
      }
      final received = await _financialEntryService.create(
        FinancialEntry(
          id: 'tmp2',
          kind: FinancialFlowKind.income,
          description: 'Sinal recebido',
          amountCents: 200000,
          date: now.subtract(const Duration(days: 2)),
          categoryId: incomeCat.id,
          status: FinancialEntryStatus.paid,
          paidAt: now.subtract(const Duration(days: 2)),
          quoteId: quoteToday.id,
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (received.entry != null) {
        tracker.financialEntryIds.add(received.entry!.id);
      }

      final block = AgendaBlock(
        id: 'demo-block-1',
        title: 'Bloqueio técnico demo',
        start: now.add(const Duration(days: 5, hours: 10)),
        end: now.add(const Duration(days: 5, hours: 12)),
        notes: 'Reservado para manutenção',
        createdAt: now,
        updatedAt: now,
      );
      await _agendaBlockRepository.insert(block);
      tracker.agendaBlockIds.add(block.id);

      final manifest = tracker.toManifest(seededAt: now);
      await _manifestStore.write(manifest);
      return manifest;
    } catch (_) {
      // Never leave a success-looking manifest after a partial seed.
      final partial = tracker.toManifest(seededAt: now);
      if (!partial.isEmpty) {
        await _clearTrackedIds(partial);
      }
      await _manifestStore.clearFile();
      rethrow;
    }
  }

  Future<void> clear() async {
    final manifest = await _manifestStore.read();
    if (manifest == null || manifest.isEmpty) {
      // Absent / empty / unreadable manifest ⇒ no DB deletes.
      await _manifestStore.clearFile();
      return;
    }

    await _clearTrackedIds(manifest);
    await _manifestStore.clearFile();
  }

  /// Deletes only concrete IDs from [manifest]. Never runs unfiltered deletes.
  Future<void> _clearTrackedIds(DemoSeedManifest manifest) async {
    for (final id in _usableIds(manifest.invoiceIds)) {
      await _safe(() => _invoiceRepository.delete(id));
    }
    for (final id in _usableIds(manifest.contractIds)) {
      await _safe(() => _contractRepository.delete(id));
    }
    for (final id in _usableIds(manifest.financialEntryIds)) {
      await _safe(() => _financialEntryRepository.delete(id));
    }
    for (final id in _usableIds(manifest.agendaBlockIds)) {
      await _safe(() => _agendaBlockRepository.delete(id));
    }
    for (final id in _usableIds(manifest.quoteIds)) {
      await _safe(() => _deleteQuoteByManifestId(id));
    }
    for (final id in _usableIds(manifest.clientIds)) {
      await _safe(() => _clientRepository.delete(id));
    }
    for (final id in _usableIds(manifest.teamMemberIds)) {
      await _safe(() => _teamMemberRepository.delete(id));
    }
    for (final id in _usableIds(manifest.teamRoleIds)) {
      await _safe(() => _teamRoleRepository.delete(id));
    }
    for (final id in _usableIds(manifest.equipmentIds)) {
      await _safe(() => _equipmentRepository.delete(id));
    }
    for (final id in _usableIds(manifest.equipmentCategoryIds)) {
      await _safe(() => _equipmentCategoryRepository.delete(id));
    }
    for (final id in _usableIds(manifest.vehicleIds)) {
      await _safe(() => _vehicleRepository.delete(id));
    }
    for (final id in _usableIds(manifest.vehicleTypeIds)) {
      await _safe(() => _vehicleTypeRepository.delete(id));
    }
    for (final id in _usableIds(manifest.financialCategoryIds)) {
      await _safe(() => _financialCategoryRepository.delete(id));
    }
  }

  List<String> _usableIds(List<String> ids) {
    return [
      for (final id in ids)
        if (id.trim().isNotEmpty) id.trim(),
    ];
  }

  Future<Quote> _insertQuote({
    required String id,
    required String numberHint,
    required Client client,
    required QuoteStatus status,
    required String eventName,
    required DateTime eventDate,
    required int totalCents,
    required DateTime now,
  }) {
    return _quoteRepository.insert(
      Quote(
        id: id,
        number: numberHint,
        status: status,
        clientSnapshot: QuoteClientSnapshot.fromClient(client),
        eventSnapshot: QuoteEventSnapshot(
          name: eventName,
          date: eventDate,
          guestCount: 120,
        ),
        items: [
          QuoteLineItem(
            name: 'Pacote completo',
            unit: 'Evento',
            quantity: 1,
            unitPriceCents: totalCents,
            lineTotalCents: totalCents,
          ),
        ],
        subtotalCents: totalCents,
        discountCents: 0,
        freightCents: 0,
        totalCents: totalCents,
        statusHistory: [
          QuoteStatusHistoryEntry(
            previousStatus: null,
            newStatus: status,
            changedAt: now,
          ),
        ],
        createdAt: now,
        updatedAt: now,
        approvedAt: status == QuoteStatus.approved ? now : null,
        notes: 'Orçamento demonstrativo',
        internalNotes: 'demo',
      ),
    );
  }

  /// QuoteRepository has no delete API. SQL is parameterized and only runs for
  /// a single non-empty ID already listed in the demo manifest.
  Future<void> _deleteQuoteByManifestId(String quoteId) async {
    final id = quoteId.trim();
    if (id.isEmpty) return;
    await _database.customStatement(
      'DELETE FROM quotes WHERE id = ?',
      [id],
    );
  }

  Future<void> _safe(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      // Best-effort cleanup for partially seeded environments.
    }
  }
}

/// Accumulates IDs created during a seed attempt for safe rollback on failure.
class _DemoIdTracker {
  final List<String> clientIds = [];
  final List<String> quoteIds = [];
  final List<String> contractIds = [];
  final List<String> invoiceIds = [];
  final List<String> teamRoleIds = [];
  final List<String> teamMemberIds = [];
  final List<String> equipmentCategoryIds = [];
  final List<String> equipmentIds = [];
  final List<String> vehicleTypeIds = [];
  final List<String> vehicleIds = [];
  final List<String> financialCategoryIds = [];
  final List<String> financialEntryIds = [];
  final List<String> agendaBlockIds = [];

  DemoSeedManifest toManifest({required DateTime seededAt}) {
    return DemoSeedManifest(
      clientIds: List.unmodifiable(clientIds),
      quoteIds: List.unmodifiable(quoteIds),
      contractIds: List.unmodifiable(contractIds),
      invoiceIds: List.unmodifiable(invoiceIds),
      teamRoleIds: List.unmodifiable(teamRoleIds),
      teamMemberIds: List.unmodifiable(teamMemberIds),
      equipmentCategoryIds: List.unmodifiable(equipmentCategoryIds),
      equipmentIds: List.unmodifiable(equipmentIds),
      vehicleTypeIds: List.unmodifiable(vehicleTypeIds),
      vehicleIds: List.unmodifiable(vehicleIds),
      financialCategoryIds: List.unmodifiable(financialCategoryIds),
      financialEntryIds: List.unmodifiable(financialEntryIds),
      agendaBlockIds: List.unmodifiable(agendaBlockIds),
      seededAt: seededAt,
    );
  }
}
