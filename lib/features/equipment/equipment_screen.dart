import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'equipment_feedback.dart';
import 'models/equipment_list_summary.dart';
import 'providers/equipment_category_provider.dart';
import 'providers/equipment_filters_provider.dart';
import 'providers/equipment_list_summary_provider.dart';
import 'providers/equipment_provider.dart';
import 'providers/filtered_equipment_provider.dart';
import 'widgets/equipment_empty_state.dart';
import 'widgets/equipment_filters_bar.dart';
import 'widgets/equipment_list_item.dart';
import 'widgets/equipment_summary_cards.dart';

class EquipmentScreen extends ConsumerWidget {
  const EquipmentScreen({super.key});

  static const _maxContentWidth = 960.0;

  Future<void> _openNew(BuildContext context) async {
    final created = await context.push<bool>(AppRoutes.equipmentNew);
    if (created == true && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        EquipmentFeedbackPresenter.showSnackBar(
          EquipmentFeedback.equipmentCreated,
        );
      });
    }
  }

  String _categoryName(WidgetRef ref, String categoryId) {
    return ref.read(equipmentCategoryProvider).value
            ?.where((category) => category.id == categoryId)
            .map((category) => category.name)
            .firstOrNull ??
        'Categoria';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(filteredEquipmentProvider);
    final summaryAsync = ref.watch(equipmentListSummaryProvider);
    final filters = ref.watch(equipmentFiltersProvider);
    final categories =
        ref.watch(equipmentCategoryProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Estoque & Equipamentos',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('equipment_categories_button'),
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Categorias',
            onPressed: () => context.push(AppRoutes.equipmentCategories),
          ),
          IconButton(
            key: const Key('equipment_new_button'),
            icon: const Icon(Icons.add),
            tooltip: 'Novo equipamento',
            onPressed: () => _openNew(context),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          final summary = summaryAsync.value ?? EquipmentListSummary.empty;
          return CustomScrollView(
            key: const Key('equipment_scroll'),
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
                          EquipmentSummaryCards(summary: summary),
                          const SizedBox(height: 16),
                          EquipmentFiltersBar(
                            filters: filters,
                            categories: categories,
                            onCategoryChanged: (categoryId) => ref
                                .read(equipmentFiltersProvider.notifier)
                                .setCategoryId(categoryId),
                            onStatusChanged: (status) => ref
                                .read(equipmentFiltersProvider.notifier)
                                .setStatus(status),
                            onNameQueryChanged: (query) => ref
                                .read(equipmentFiltersProvider.notifier)
                                .setNameQuery(query),
                            onClear: () => ref
                                .read(equipmentFiltersProvider.notifier)
                                .clear(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (items.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _maxContentWidth,
                        ),
                        child: EquipmentEmptyState(
                          onNewEquipment: () => _openNew(context),
                          hasActiveFilters: filters.hasActiveFilters,
                          onClearFilters: () => ref
                              .read(equipmentFiltersProvider.notifier)
                              .clear(),
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList.separated(
                    key: const Key('equipment_list'),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final equipment = items[index];
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: _maxContentWidth,
                          ),
                          child: EquipmentListItem(
                            equipment: equipment,
                            categoryName: _categoryName(
                              ref,
                              equipment.categoryId,
                            ),
                            onTap: () => context.push(
                              AppRoutes.equipmentDetail(equipment.id),
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
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Não foi possível carregar os equipamentos.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () =>
                      ref.read(equipmentProvider.notifier).reload(),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
