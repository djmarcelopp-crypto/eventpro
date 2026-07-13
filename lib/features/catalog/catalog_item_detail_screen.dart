import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import 'models/catalog_item.dart';
import 'providers/catalog_provider.dart';
import 'utils/catalog_detail_presenter.dart';
import 'widgets/catalog_detail_row.dart';
import 'widgets/catalog_item_image_placeholder.dart';

class CatalogItemDetailScreen extends ConsumerWidget {
  const CatalogItemDetailScreen({
    super.key,
    required this.itemId,
  });

  final String itemId;

  Future<void> _confirmToggleActive(
    BuildContext context,
    WidgetRef ref,
    CatalogItem item,
  ) async {
    final activating = !item.active;
    final actionLabel = activating ? 'ativar' : 'desativar';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(activating ? 'Ativar item' : 'Desativar item'),
          content: Text(
            'Deseja $actionLabel "${CatalogDetailPresenter.displayTitle(item)}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(activating ? 'Ativar' : 'Desativar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    ref.read(catalogProvider.notifier).updateItem(
          item.copyWith(active: activating),
        );

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          activating
              ? 'Item ativado com sucesso'
              : 'Item desativado com sucesso',
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(catalogProvider);
    CatalogItem? item;
    for (final current in items) {
      if (current.id == itemId) {
        item = current;
        break;
      }
    }

    if (item == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Voltar',
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Item',
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
          ),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Item não encontrado',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final resolvedItem = item;
    final detailItems = CatalogDetailPresenter.detailItems(resolvedItem);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
        ),
        title: Text(
          CatalogDetailPresenter.displayTitle(resolvedItem),
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('catalog_edit_button'),
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar',
            onPressed: () => context.push(
              AppRoutes.catalogEdit(itemId),
              extra: resolvedItem,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: CatalogItemImagePlaceholder(
                              width: 200,
                              height: 150,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            resolvedItem.name,
                            style: AppTextStyles.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          for (final detail in detailItems)
                            CatalogDetailRow(
                              label: detail.label,
                              value: detail.value,
                              valueColor: detail.label == 'Status' &&
                                      !resolvedItem.active
                                  ? AppColors.warning
                                  : null,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      key: Key(
                        resolvedItem.active
                            ? 'catalog_deactivate_button'
                            : 'catalog_activate_button',
                      ),
                      label: resolvedItem.active
                          ? 'Desativar item'
                          : 'Ativar item',
                      onPressed: () =>
                          _confirmToggleActive(context, ref, resolvedItem),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
