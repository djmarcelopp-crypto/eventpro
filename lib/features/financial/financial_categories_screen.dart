import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import 'financial_feedback.dart';
import 'models/financial_category.dart';
import 'models/financial_flow_kind.dart';
import 'providers/financial_categories_provider.dart';
import 'widgets/financial_category_form_dialog.dart';

class FinancialCategoriesScreen extends ConsumerWidget {
  const FinancialCategoriesScreen({super.key});

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final draft = await showFinancialCategoryFormDialog(context: context);
    if (draft == null) {
      return;
    }
    final result = await ref
        .read(financialCategoriesProvider.notifier)
        .addCategory(draft);
    if (!result.isSuccess) {
      FinancialFeedbackPresenter.showError(
        FinancialFeedbackPresenter.categoryWriteError(result),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FinancialFeedbackPresenter.showSnackBar(FinancialFeedback.categoryCreated);
    });
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    FinancialCategory category,
  ) async {
    final draft = await showFinancialCategoryFormDialog(
      context: context,
      existing: category,
    );
    if (draft == null) {
      return;
    }
    final result = await ref
        .read(financialCategoriesProvider.notifier)
        .updateCategory(draft);
    if (!result.isSuccess) {
      FinancialFeedbackPresenter.showError(
        FinancialFeedbackPresenter.categoryWriteError(result),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FinancialFeedbackPresenter.showSnackBar(FinancialFeedback.categoryUpdated);
    });
  }

  Future<void> _toggleActive(
    WidgetRef ref,
    FinancialCategory category,
  ) async {
    final result = await ref
        .read(financialCategoriesProvider.notifier)
        .updateCategory(category.copyWith(active: !category.active));
    if (!result.isSuccess) {
      FinancialFeedbackPresenter.showError(
        FinancialFeedbackPresenter.categoryWriteError(result),
      );
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    FinancialCategory category,
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
              key: const Key('financial_category_delete_confirm_button'),
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
        .read(financialCategoriesProvider.notifier)
        .deleteCategory(category.id);
    if (!result.isDeleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FinancialFeedbackPresenter.showError(
          FinancialFeedbackPresenter.categoryDeleteError(result),
        );
      });
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FinancialFeedbackPresenter.showSnackBar(FinancialFeedback.categoryDeleted);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(financialCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Categorias',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('financial_category_new_button'),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Nenhuma categoria cadastrada',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    key: const Key('financial_category_empty_new'),
                    onPressed: () => _create(context, ref),
                    child: const Text('Nova categoria'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            key: const Key('financial_category_list'),
            padding: const EdgeInsets.all(24),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final category = categories[index];
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: AppCard(
                    key: Key('financial_category_item_${category.id}'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(category.name),
                      subtitle: Text(
                        '${category.kind.label}'
                        '${category.active ? '' : ' · Inativa'}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: category.kind.color,
                        ),
                      ),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            key: Key(
                              'financial_category_toggle_${category.id}',
                            ),
                            tooltip: category.active ? 'Desativar' : 'Ativar',
                            icon: Icon(
                              category.active
                                  ? Icons.toggle_on
                                  : Icons.toggle_off,
                              color: category.active
                                  ? AppColors.success
                                  : AppColors.mutedWhite,
                            ),
                            onPressed: () => _toggleActive(ref, category),
                          ),
                          IconButton(
                            key: Key(
                              'financial_category_edit_${category.id}',
                            ),
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _edit(context, ref, category),
                          ),
                          IconButton(
                            key: Key(
                              'financial_category_delete_${category.id}',
                            ),
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _delete(context, ref, category),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Não foi possível carregar as categorias.',
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () =>
                    ref.read(financialCategoriesProvider.notifier).reload(),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
