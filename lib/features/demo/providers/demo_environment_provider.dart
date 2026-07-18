import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../agenda/providers/agenda_block_repository_provider.dart';
import '../../agenda/providers/agenda_blocks_provider.dart';
import '../../billing/providers/invoice_provider.dart';
import '../../billing/providers/invoice_repository_provider.dart';
import '../../billing/providers/invoice_service_provider.dart';
import '../../clients/providers/client_repository_provider.dart';
import '../../clients/providers/clients_provider.dart';
import '../../contracts/providers/contract_provider.dart';
import '../../contracts/providers/contract_repository_provider.dart';
import '../../contracts/providers/contract_service_provider.dart';
import '../../contracts/providers/quote_contract_service_provider.dart';
import '../../equipment/providers/equipment_category_provider.dart';
import '../../equipment/providers/equipment_category_repository_provider.dart';
import '../../equipment/providers/equipment_category_service_provider.dart';
import '../../equipment/providers/equipment_provider.dart';
import '../../equipment/providers/equipment_repository_provider.dart';
import '../../equipment/providers/equipment_service_provider.dart';
import '../../financial/providers/financial_categories_provider.dart';
import '../../financial/providers/financial_category_repository_provider.dart';
import '../../financial/providers/financial_category_service_provider.dart';
import '../../financial/providers/financial_entries_provider.dart';
import '../../financial/providers/financial_entry_repository_provider.dart';
import '../../financial/providers/financial_entry_service_provider.dart';
import '../../logistics/providers/vehicle_provider.dart';
import '../../logistics/providers/vehicle_repository_provider.dart';
import '../../logistics/providers/vehicle_service_provider.dart';
import '../../logistics/providers/vehicle_type_provider.dart';
import '../../logistics/providers/vehicle_type_repository_provider.dart';
import '../../logistics/providers/vehicle_type_service_provider.dart';
import '../../quotes/providers/quote_repository_provider.dart';
import '../../quotes/providers/quotes_provider.dart';
import '../../team/providers/team_member_provider.dart';
import '../../team/providers/team_member_repository_provider.dart';
import '../../team/providers/team_member_service_provider.dart';
import '../../team/providers/team_role_provider.dart';
import '../../team/providers/team_role_repository_provider.dart';
import '../../team/providers/team_role_service_provider.dart';
import '../data/demo_manifest_store.dart';
import '../utils/demo_seeder.dart';

class DemoEnvironmentState {
  const DemoEnvironmentState({
    this.isSeeded = false,
    this.isBusy = false,
    this.seededAt,
    this.lastError,
  });

  final bool isSeeded;
  final bool isBusy;
  final DateTime? seededAt;
  final String? lastError;

  DemoEnvironmentState copyWith({
    bool? isSeeded,
    bool? isBusy,
    DateTime? seededAt,
    String? lastError,
    bool clearError = false,
    bool clearSeededAt = false,
  }) {
    return DemoEnvironmentState(
      isSeeded: isSeeded ?? this.isSeeded,
      isBusy: isBusy ?? this.isBusy,
      seededAt: clearSeededAt ? null : (seededAt ?? this.seededAt),
      lastError: clearError ? null : (lastError ?? this.lastError),
    );
  }
}

final demoManifestStoreProvider = Provider<DemoManifestStore>((ref) {
  return DemoManifestStore();
});

final demoSeederProvider = Provider<DemoSeeder>((ref) {
  return DemoSeeder(
    database: ref.watch(appDatabaseProvider),
    clientRepository: ref.watch(clientRepositoryProvider),
    quoteRepository: ref.watch(quoteRepositoryProvider),
    contractService: ref.watch(contractServiceProvider),
    quoteContractService: ref.watch(quoteContractServiceProvider),
    contractRepository: ref.watch(contractRepositoryProvider),
    invoiceService: ref.watch(invoiceServiceProvider),
    invoiceRepository: ref.watch(invoiceRepositoryProvider),
    teamRoleService: ref.watch(teamRoleServiceProvider),
    teamMemberService: ref.watch(teamMemberServiceProvider),
    teamRoleRepository: ref.watch(teamRoleRepositoryProvider),
    teamMemberRepository: ref.watch(teamMemberRepositoryProvider),
    equipmentCategoryService: ref.watch(equipmentCategoryServiceProvider),
    equipmentService: ref.watch(equipmentServiceProvider),
    equipmentCategoryRepository: ref.watch(equipmentCategoryRepositoryProvider),
    equipmentRepository: ref.watch(equipmentRepositoryProvider),
    vehicleTypeService: ref.watch(vehicleTypeServiceProvider),
    vehicleService: ref.watch(vehicleServiceProvider),
    vehicleTypeRepository: ref.watch(vehicleTypeRepositoryProvider),
    vehicleRepository: ref.watch(vehicleRepositoryProvider),
    financialCategoryService: ref.watch(financialCategoryServiceProvider),
    financialEntryService: ref.watch(financialEntryServiceProvider),
    financialCategoryRepository:
        ref.watch(financialCategoryRepositoryProvider),
    financialEntryRepository: ref.watch(financialEntryRepositoryProvider),
    agendaBlockRepository: ref.watch(agendaBlockRepositoryProvider),
    manifestStore: ref.watch(demoManifestStoreProvider),
  );
});

class DemoEnvironmentNotifier extends AsyncNotifier<DemoEnvironmentState> {
  DemoSeeder get _seeder => ref.read(demoSeederProvider);

  @override
  Future<DemoEnvironmentState> build() async {
    try {
      final manifest = await ref.watch(demoManifestStoreProvider).read();
      return DemoEnvironmentState(
        isSeeded: manifest != null && !manifest.isEmpty,
        seededAt: manifest?.seededAt,
      );
    } catch (_) {
      return const DemoEnvironmentState();
    }
  }

  Future<bool> seedDemoData() async {
    final current = state.value ?? const DemoEnvironmentState();
    state = AsyncValue.data(current.copyWith(isBusy: true, clearError: true));
    try {
      final manifest = await _seeder.seed();
      await _refreshModuleState();
      state = AsyncValue.data(
        DemoEnvironmentState(
          isSeeded: true,
          isBusy: false,
          seededAt: manifest.seededAt,
        ),
      );
      return true;
    } catch (error) {
      state = AsyncValue.data(
        current.copyWith(
          isBusy: false,
          lastError: error.toString(),
        ),
      );
      return false;
    }
  }

  Future<bool> clearDemoData() async {
    final current = state.value ?? const DemoEnvironmentState();
    state = AsyncValue.data(current.copyWith(isBusy: true, clearError: true));
    try {
      await _seeder.clear();
      await _refreshModuleState();
      state = const AsyncValue.data(
        DemoEnvironmentState(isSeeded: false, isBusy: false),
      );
      return true;
    } catch (error) {
      state = AsyncValue.data(
        current.copyWith(
          isBusy: false,
          lastError: error.toString(),
        ),
      );
      return false;
    }
  }

  Future<void> _refreshModuleState() async {
    final clients = await ref.read(clientRepositoryProvider).listAll();
    final quotes = await ref.read(quoteRepositoryProvider).listAll();
    ref.read(clientsProvider.notifier).hydrate(clients);
    ref.read(quotesProvider.notifier).hydrate(quotes);

    ref.invalidate(contractProvider);
    ref.invalidate(invoiceProvider);
    ref.invalidate(teamRoleProvider);
    ref.invalidate(teamMemberProvider);
    ref.invalidate(equipmentCategoryProvider);
    ref.invalidate(equipmentProvider);
    ref.invalidate(vehicleTypeProvider);
    ref.invalidate(vehicleProvider);
    ref.invalidate(financialCategoriesProvider);
    ref.invalidate(financialEntriesProvider);
    ref.invalidate(agendaBlocksProvider);
  }
}

final demoEnvironmentProvider =
    AsyncNotifierProvider<DemoEnvironmentNotifier, DemoEnvironmentState>(
  DemoEnvironmentNotifier.new,
);
