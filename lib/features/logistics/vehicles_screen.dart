import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'models/vehicle_list_summary.dart';
import 'providers/filtered_vehicles_provider.dart';
import 'providers/vehicle_filters_provider.dart';
import 'providers/vehicle_list_summary_provider.dart';
import 'providers/vehicle_type_provider.dart';
import 'logistics_feedback.dart';
import 'widgets/vehicle_empty_state.dart';
import 'widgets/vehicle_filters_bar.dart';
import 'widgets/vehicle_list_item.dart';
import 'widgets/vehicle_summary_cards.dart';

class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  static const _maxContentWidth = 960.0;

  Future<void> _openNew(BuildContext context) async {
    final created = await context.push<bool>(AppRoutes.vehiclesNew);
    if (created == true && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LogisticsFeedbackPresenter.showSnackBar(
          LogisticsFeedback.vehicleCreated,
        );
      });
    }
  }

  String _typeName(WidgetRef ref, String typeId) {
    return ref.read(vehicleTypeProvider).value
            ?.where((type) => type.id == typeId)
            .map((type) => type.name)
            .firstOrNull ??
        'Tipo';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(filteredVehiclesProvider);
    final summaryAsync = ref.watch(vehicleListSummaryProvider);
    final filters = ref.watch(vehicleFiltersProvider);
    final types = ref.watch(vehicleTypeProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Logística & Transporte',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('vehicle_types_button'),
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Tipos de veículo',
            onPressed: () => context.push(AppRoutes.vehicleTypes),
          ),
          IconButton(
            key: const Key('vehicle_new_button'),
            icon: const Icon(Icons.add),
            tooltip: 'Novo veículo',
            onPressed: () => _openNew(context),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          final summary = summaryAsync.value ?? VehicleListSummary.empty;
          return CustomScrollView(
            key: const Key('vehicles_scroll'),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: _maxContentWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          VehicleSummaryCards(summary: summary),
                          const SizedBox(height: 16),
                          VehicleFiltersBar(
                            filters: filters,
                            types: types,
                            onTypeChanged: (typeId) => ref
                                .read(vehicleFiltersProvider.notifier)
                                .setVehicleTypeId(typeId),
                            onStatusChanged: (status) => ref
                                .read(vehicleFiltersProvider.notifier)
                                .setStatus(status),
                            onPlateQueryChanged: (query) => ref
                                .read(vehicleFiltersProvider.notifier)
                                .setPlateQuery(query),
                            onClear: () =>
                                ref.read(vehicleFiltersProvider.notifier).clear(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (items.isEmpty)
                SliverToBoxAdapter(
                  child: VehicleEmptyState(onAdd: () => _openNew(context)),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  sliver: SliverList.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final vehicle = items[index];
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: _maxContentWidth,
                          ),
                          child: VehicleListItem(
                            vehicle: vehicle,
                            typeName: _typeName(ref, vehicle.vehicleTypeId),
                            onTap: () => context.push(
                              AppRoutes.vehicleDetail(vehicle.id),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
