import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/agenda/data/repositories/drift_agenda_block_repository.dart';
import 'package:eventpro/features/billing/data/repositories/drift_invoice_item_repository.dart';
import 'package:eventpro/features/billing/data/repositories/drift_invoice_repository.dart';
import 'package:eventpro/features/billing/utils/invoice_service.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/data/repositories/drift_client_repository.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/contracts/data/repositories/drift_contract_repository.dart';
import 'package:eventpro/features/contracts/data/repositories/drift_contract_template_repository.dart';
import 'package:eventpro/features/contracts/utils/contract_service.dart';
import 'package:eventpro/features/contracts/utils/contract_workflow_service.dart';
import 'package:eventpro/features/contracts/utils/quote_contract_service.dart';
import 'package:eventpro/features/demo/data/demo_manifest_store.dart';
import 'package:eventpro/features/demo/models/demo_seed_manifest.dart';
import 'package:eventpro/features/demo/utils/demo_seeder.dart';
import 'package:eventpro/features/equipment/data/repositories/drift_equipment_category_repository.dart';
import 'package:eventpro/features/equipment/data/repositories/drift_equipment_repository.dart';
import 'package:eventpro/features/equipment/utils/equipment_category_service.dart';
import 'package:eventpro/features/equipment/utils/equipment_service.dart';
import 'package:eventpro/features/financial/data/repositories/drift_financial_category_repository.dart';
import 'package:eventpro/features/financial/data/repositories/drift_financial_entry_repository.dart';
import 'package:eventpro/features/financial/utils/financial_category_service.dart';
import 'package:eventpro/features/financial/utils/financial_entry_service.dart';
import 'package:eventpro/features/logistics/data/repositories/drift_vehicle_repository.dart';
import 'package:eventpro/features/logistics/data/repositories/drift_vehicle_type_repository.dart';
import 'package:eventpro/features/logistics/utils/vehicle_service.dart';
import 'package:eventpro/features/logistics/utils/vehicle_type_service.dart';
import 'package:eventpro/features/quotes/data/repositories/drift_quote_repository.dart';
import 'package:eventpro/features/team/data/repositories/drift_team_member_repository.dart';
import 'package:eventpro/features/team/data/repositories/drift_team_role_repository.dart';
import 'package:eventpro/features/team/utils/team_member_service.dart';
import 'package:eventpro/features/team/utils/team_role_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DemoSeeder', () {
    late Directory tempDir;
    late AppDatabase database;
    late DemoManifestStore manifestStore;
    late DemoSeeder seeder;
    final now = DateTime(2026, 7, 17, 14, 0);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('demo_seeder_test_');
      database = AppDatabase.forTesting(File('${tempDir.path}/eventpro.sqlite'));
      manifestStore = DemoManifestStore(
        documentsDirectory: () async => tempDir,
      );

      final clientRepository = DriftClientRepository(database);
      final quoteRepository = DriftQuoteRepository(database);
      final contractRepository = DriftContractRepository(database);
      final templateRepository = DriftContractTemplateRepository(database);
      final invoiceRepository = DriftInvoiceRepository(database);
      final invoiceItemRepository = DriftInvoiceItemRepository(database);
      final teamRoleRepository = DriftTeamRoleRepository(database);
      final teamMemberRepository = DriftTeamMemberRepository(database);
      final equipmentCategoryRepository =
          DriftEquipmentCategoryRepository(database);
      final equipmentRepository = DriftEquipmentRepository(database);
      final vehicleTypeRepository = DriftVehicleTypeRepository(database);
      final vehicleRepository = DriftVehicleRepository(database);
      final financialCategoryRepository =
          DriftFinancialCategoryRepository(database);
      final financialEntryRepository = DriftFinancialEntryRepository(database);
      final agendaBlockRepository = DriftAgendaBlockRepository(database);

      final contractService = ContractService(
        contractRepository: contractRepository,
        templateRepository: templateRepository,
        quoteRepository: quoteRepository,
        clock: () => now,
      );
      final workflowService = ContractWorkflowService(
        contractService: contractService,
        contractRepository: contractRepository,
      );

      seeder = DemoSeeder(
        database: database,
        clientRepository: clientRepository,
        quoteRepository: quoteRepository,
        contractService: contractService,
        quoteContractService: QuoteContractService(
          contractService: contractService,
          workflowService: workflowService,
        ),
        contractRepository: contractRepository,
        invoiceService: InvoiceService(
          invoiceRepository: invoiceRepository,
          itemRepository: invoiceItemRepository,
          quoteRepository: quoteRepository,
          clock: () => now,
        ),
        invoiceRepository: invoiceRepository,
        teamRoleService: TeamRoleService(
          roleRepository: teamRoleRepository,
          memberRepository: teamMemberRepository,
          clock: () => now,
        ),
        teamMemberService: TeamMemberService(
          memberRepository: teamMemberRepository,
          roleRepository: teamRoleRepository,
          clock: () => now,
        ),
        teamRoleRepository: teamRoleRepository,
        teamMemberRepository: teamMemberRepository,
        equipmentCategoryService: EquipmentCategoryService(
          categoryRepository: equipmentCategoryRepository,
          equipmentRepository: equipmentRepository,
          clock: () => now,
        ),
        equipmentService: EquipmentService(
          equipmentRepository: equipmentRepository,
          categoryRepository: equipmentCategoryRepository,
          clock: () => now,
        ),
        equipmentCategoryRepository: equipmentCategoryRepository,
        equipmentRepository: equipmentRepository,
        vehicleTypeService: VehicleTypeService(
          typeRepository: vehicleTypeRepository,
          vehicleRepository: vehicleRepository,
          clock: () => now,
        ),
        vehicleService: VehicleService(
          vehicleRepository: vehicleRepository,
          typeRepository: vehicleTypeRepository,
          clock: () => now,
        ),
        vehicleTypeRepository: vehicleTypeRepository,
        vehicleRepository: vehicleRepository,
        financialCategoryService: FinancialCategoryService(
          categoryRepository: financialCategoryRepository,
          entryRepository: financialEntryRepository,
          clock: () => now,
        ),
        financialEntryService: FinancialEntryService(
          entryRepository: financialEntryRepository,
          categoryRepository: financialCategoryRepository,
          clock: () => now,
        ),
        financialCategoryRepository: financialCategoryRepository,
        financialEntryRepository: financialEntryRepository,
        agendaBlockRepository: agendaBlockRepository,
        manifestStore: manifestStore,
        clock: () => now,
      );
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('seeds coherent demo data and persists manifest', () async {
      expect(await seeder.isSeeded(), isFalse);

      final manifest = await seeder.seed();

      expect(await seeder.isSeeded(), isTrue);
      expect(manifest.clientIds, isNotEmpty);
      expect(manifest.quoteIds.length, 2);
      expect(manifest.contractIds, isNotEmpty);
      expect(manifest.invoiceIds.length, 2);
      expect(manifest.teamMemberIds.length, 2);
      expect(manifest.equipmentIds.length, 2);
      expect(manifest.vehicleIds.length, 2);
      expect(manifest.financialEntryIds.length, 2);
      expect(manifest.agendaBlockIds, ['demo-block-1']);
      expect(manifest.seededAt, now);

      final clients = await DriftClientRepository(database).listAll();
      final quotes = await DriftQuoteRepository(database).listAll();
      final invoices = await DriftInvoiceRepository(database).listAll();
      expect(clients.length, 1);
      expect(quotes.length, 2);
      expect(invoices.length, 2);
    });

    test('clear removes demo rows tracked by the manifest', () async {
      await seeder.seed();
      await seeder.clear();

      expect(await seeder.isSeeded(), isFalse);
      expect(await DriftClientRepository(database).listAll(), isEmpty);
      expect(await DriftQuoteRepository(database).listAll(), isEmpty);
      expect(await DriftInvoiceRepository(database).listAll(), isEmpty);
      expect(await DriftContractRepository(database).listAll(), isEmpty);
      expect(await DriftTeamMemberRepository(database).listAll(), isEmpty);
      expect(await DriftEquipmentRepository(database).listAll(), isEmpty);
      expect(await DriftVehicleRepository(database).listAll(), isEmpty);
      expect(await DriftFinancialEntryRepository(database).listAll(), isEmpty);
      expect(await DriftAgendaBlockRepository(database).listAll(), isEmpty);
      expect(await manifestStore.read(), isNull);
    });

    test('seed after clear recreates a fresh demo set', () async {
      final first = await seeder.seed();
      await seeder.clear();
      final second = await seeder.seed();

      expect(second.clientIds, first.clientIds);
      expect(second.quoteIds, first.quoteIds);
      expect(await DriftClientRepository(database).listAll(), hasLength(1));
      expect(await DriftQuoteRepository(database).listAll(), hasLength(2));
    });

    test('clear twice is safe and seed twice does not duplicate', () async {
      await seeder.seed();
      await seeder.clear();
      await seeder.clear();
      expect(await seeder.isSeeded(), isFalse);

      await seeder.seed();
      await seeder.seed();

      expect(await DriftClientRepository(database).listAll(), hasLength(1));
      expect(await DriftQuoteRepository(database).listAll(), hasLength(2));
      expect(await DriftInvoiceRepository(database).listAll(), hasLength(2));
    });

    test('clear never deletes real data outside the manifest', () async {
      final now = DateTime(2026, 7, 17, 14, 0);
      final realClient = Client.fromForm(
        id: 'real-client-keep',
        createdAt: now,
        type: ClientType.individual,
        name: 'Cliente Real',
        phone: '67911112222',
      );
      await DriftClientRepository(database).insert(realClient);

      await seeder.seed();
      expect(await DriftClientRepository(database).listAll(), hasLength(2));

      await seeder.clear();
      final remaining = await DriftClientRepository(database).listAll();
      expect(remaining, hasLength(1));
      expect(remaining.single.id, 'real-client-keep');
      expect(await DriftQuoteRepository(database).listAll(), isEmpty);
    });

    test('absent or corrupted manifest does not wipe real rows', () async {
      final now = DateTime(2026, 7, 17, 14, 0);
      final realClient = Client.fromForm(
        id: 'real-client-safe',
        createdAt: now,
        type: ClientType.individual,
        name: 'Cliente Seguro',
        phone: '67933334444',
      );
      await DriftClientRepository(database).insert(realClient);

      await seeder.clear();
      expect(await DriftClientRepository(database).listAll(), hasLength(1));

      final file = File('${tempDir.path}/${DemoManifestStore.fileName}');
      await file.writeAsString('{broken');
      await seeder.clear();
      expect(await DriftClientRepository(database).listAll(), hasLength(1));
      expect((await DriftClientRepository(database).listAll()).single.id,
          'real-client-safe');
    });

    test('manifest with blank IDs never triggers unfiltered deletes', () async {
      final now = DateTime(2026, 7, 17, 14, 0);
      final realClient = Client.fromForm(
        id: 'real-client-blank-guard',
        createdAt: now,
        type: ClientType.individual,
        name: 'Cliente Blank Guard',
        phone: '67955556666',
      );
      await DriftClientRepository(database).insert(realClient);

      await manifestStore.write(
        const DemoSeedManifest(
          clientIds: ['', '   '],
          quoteIds: [''],
        ),
      );
      await seeder.clear();

      final remaining = await DriftClientRepository(database).listAll();
      expect(remaining, hasLength(1));
      expect(remaining.single.id, 'real-client-blank-guard');
      expect(await seeder.isSeeded(), isFalse);
    });
  });
}
