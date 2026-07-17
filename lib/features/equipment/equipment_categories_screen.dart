import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import 'equipment_feedback.dart';
import 'models/equipment_category.dart';
import 'providers/equipment_category_provider.dart';
import 'widgets/equipment_category_form_dialog.dart';

class EquipmentCategoriesScreen extends ConsumerWidget {
  const EquipmentCategoriesScreen({super.key});

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final draft = await showEquipmentCategoryFormDialog(context: context);
    if (draft == null) {
      return;
    }
    final result = await ref
        .read(equipmentCategoryProvider.notifier)
        .addCategory(draft);
    if (!result.isSuccess) {
      EquipmentFeedbackPresenter.showError(
        EquipmentFeedbackPresenter.categoryWriteError(result),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EquipmentFeedbackPresenter.showSnackBar(
        EquipmentFeedback.categoryCreated,
      );
    });
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    EquipmentCategory category,
  ) async {
    final draft = await showEquipmentCategoryFormDialog(
      context: context,
      existing: category,
    );
    if (draft == null) {
      return;
    }
    final result = await ref
        .read(equipmentCategoryProvider.notifier)
        .updateCategory(draft);
    if (!result.isSuccess) {
      EquipmentFeedbackPresenter.showError(
        EquipmentFeedbackPresenter.categoryWriteError(result),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EquipmentFeedbackPresenter.showSnackBar(
        EquipmentFeedback.categoryUpdated,
      );
    });
  }

  Future<void> _toggleActive(
    WidgetRef ref,
    EquipmentCategory category,
  ) async {
    final result = await ref
        .read(equipmentCategoryProvider.notifier)
        .updateCategory(category.copyWith(active: !category.active));
    if (!result.isSuccess) {
      EquipmentFeedbackPresenter.showError(
        EquipmentFeedbackPresenter.categoryWriteError(result),
      );
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    EquipmentCategory category,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir categoria'),
          content: Text('Excluir "${category.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: const Key('equipment_category_delete_confirm_button'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }

    final result = await ref
        .read(equipmentCategoryProvider.notifier)
        .deleteCategory(category.id);
    if (!result.isDeleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        EquipmentFeedbackPresenter.showError(
          EquipmentFeedbackPresenter.categoryDeleteError(result),
        );
      });
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EquipmentFeedbackPresenter.showSnackBar(
        EquipmentFeedback.categoryDeleted,
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(equipmentCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Categorias de equipamento',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('equipment_category_new_button'),
            icon: const Icon(Icons.add),
            tooltip: 'Nova categoria',
            onPressed: () => _create(context, ref),
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Nenhuma categoria cadastrada.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            key: const Key('equipment_category_list'),
            padding: const EdgeInsets.all(24),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final category = categories[index];
              return AppCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category.name, style: AppTextStyles.titleMedium),
                          if (category.description != null &&
                              category.description!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              category.description!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            category.active ? 'Ativa' : 'Inativa',
                            style: AppTextStyles.caption.copyWith(
                              color: category.active
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      key: Key('equipment_category_edit_${category.id}'),
                      tooltip: 'Editar',
                      onPressed: () => _edit(context, ref, category),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      key: Key('equipment_category_toggle_${category.id}'),
                      tooltip: category.active ? 'Desativar' : 'Ativar',
                      onPressed: () => _toggleActive(ref, category),
                      icon: Icon(
                        category.active
                            ? Icons.toggle_on
                            : Icons.toggle_off_outlined,
                        color: category.active
                            ? AppColors.success
                            : AppColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    IconButton(
                      key: Key('equipment_category_delete_${category.id}'),
                      tooltip: 'Excluir',
                      onPressed: () => _delete(context, ref, category),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Não foi possível carregar as categorias.',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ),
    );
  }
}
