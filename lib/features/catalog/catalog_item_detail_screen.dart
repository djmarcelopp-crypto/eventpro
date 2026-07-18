import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import 'catalog_list_feedback.dart';
import 'models/catalog_delete_result.dart';
import 'models/catalog_item.dart';
import 'providers/catalog_image_services_provider.dart';
import 'providers/catalog_provider.dart';
import 'utils/catalog_detail_presenter.dart';
import 'utils/catalog_item_deletion_coordinator.dart';
import 'utils/catalog_navigation.dart';
import 'utils/catalog_package_dependency_checker.dart';
import 'widgets/catalog_detail_row.dart';
import 'widgets/catalog_item_image_view.dart';
import 'widgets/catalog_package_detail_components.dart';
import 'widgets/catalog_permanent_delete_dialog.dart';

class CatalogItemDetailScreen extends ConsumerStatefulWidget {
  const CatalogItemDetailScreen({
    super.key,
    required this.itemId,
  });

  final String itemId;

  @override
  ConsumerState<CatalogItemDetailScreen> createState() =>
      _CatalogItemDetailScreenState();
}

class _CatalogItemDetailScreenState
    extends ConsumerState<CatalogItemDetailScreen> {
  var _isDeleting = false;
  String? _packageBlockMessage;

  Future<void> _confirmToggleActive(CatalogItem item) async {
    if (_isDeleting) {
      return;
    }

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

    if (confirmed != true || !mounted) {
      return;
    }

    final updated = await ref
        .read(catalogProvider.notifier)
        .updateItem(item.copyWith(active: activating));

    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    if (!updated) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text(
            'Não foi possível salvar. Tente novamente.',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

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

  String _packageBlockMessageFor(CatalogItem item, List<CatalogItem> items) {
    final packageNames = CatalogPackageDependencyChecker.dependentPackageNames(
      catalogItemId: item.id,
      items: items,
    );

    if (packageNames.isEmpty) {
      return '';
    }

    final joinedNames = packageNames.join(', ');
    return 'Este item faz parte dos pacotes: $joinedNames. '
        'Remova-o dos pacotes antes de excluir.';
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: isError ? AppColors.error : AppColors.warning,
        ),
      );
  }

  Future<void> _handlePermanentDelete(CatalogItem item) async {
    if (_isDeleting) {
      return;
    }

    final currentItems = ref.read(catalogProvider);
    final blockMessage = _packageBlockMessageFor(item, currentItems);
    if (blockMessage.isNotEmpty) {
      setState(() => _packageBlockMessage = blockMessage);
      _showSnackBar(blockMessage, isError: true);
      return;
    }

    final confirmed = await showCatalogPermanentDeleteDialog(
      context: context,
      itemName: item.name,
    );

    if (!confirmed || !mounted) {
      return;
    }

    setState(() {
      _isDeleting = true;
      _packageBlockMessage = null;
    });

    CatalogListFeedback? deleteFeedback;
    try {
      final result = await CatalogItemDeletionCoordinator.deletePermanently(
        itemId: item.id,
        notifier: ref.read(catalogProvider.notifier),
        imageStorage: ref.read(catalogImageStorageProvider),
        currentItems: ref.read(catalogProvider),
      );

      if (!mounted) {
        return;
      }

      switch (result.status) {
        case CatalogDeleteStatus.deleted:
          deleteFeedback = CatalogListFeedback.deleted;
        case CatalogDeleteStatus.deletedWithImageCleanupWarning:
          deleteFeedback = CatalogListFeedback.deletedWithImageCleanupWarning;
        case CatalogDeleteStatus.blockedByPackages:
          final message = _packageBlockMessageFor(
            item,
            ref.read(catalogProvider),
          );
          setState(() => _packageBlockMessage = message);
          _showSnackBar(
            message.isEmpty
                ? 'Não foi possível excluir o item porque ele está em uso por pacotes.'
                : message,
            isError: true,
          );
          return;
        case CatalogDeleteStatus.notFound:
          _showSnackBar('Item não encontrado.', isError: true);
          return;
        case CatalogDeleteStatus.failure:
          _showSnackBar(
            'Não foi possível excluir o item. Tente novamente.',
            isError: true,
          );
          return;
      }

      CatalogNavigation.popToCatalogList(
        context,
        deleteFeedback: deleteFeedback,
      );
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(catalogProvider);
    CatalogItem? item;
    for (final current in items) {
      if (current.id == widget.itemId) {
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
            onPressed: _isDeleting ? null : () => context.pop(),
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
    final packageBlockMessage =
        _packageBlockMessage ?? _packageBlockMessageFor(resolvedItem, items);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: _isDeleting ? null : () => context.pop(),
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
            onPressed: _isDeleting
                ? null
                : () => context.push(AppRoutes.catalogEdit(widget.itemId)),
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
                          Center(
                            child: CatalogItemImageView(
                              imageReference: resolvedItem.imageReference,
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
                          if (resolvedItem.isPackage) ...[
                            const SizedBox(height: 16),
                            CatalogPackageDetailComponents(
                              components: resolvedItem.components,
                            ),
                          ],
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
                      onPressed: _isDeleting
                          ? null
                          : () => _confirmToggleActive(resolvedItem),
                    ),
                    const SizedBox(height: 32),
                    AppCard(
                      key: const Key('catalog_destructive_delete_section'),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Exclusão definitiva',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Use a exclusão apenas para cadastros incorretos ou '
                            'duplicados. Para itens que não são mais oferecidos, '
                            'prefira desativar.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                          if (packageBlockMessage.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              packageBlockMessage,
                              key: const Key('catalog_delete_package_block'),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              key: const Key('catalog_permanent_delete_button'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: AppColors.white,
                                disabledBackgroundColor:
                                    AppColors.surfaceVariant,
                                disabledForegroundColor:
                                    AppColors.secondaryText,
                              ),
                              onPressed: _isDeleting
                                  ? null
                                  : () =>
                                      _handlePermanentDelete(resolvedItem),
                              child: Text(
                                _isDeleting
                                    ? 'Excluindo...'
                                    : 'Excluir definitivamente',
                              ),
                            ),
                          ),
                        ],
                      ),
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
