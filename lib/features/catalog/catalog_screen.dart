import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'catalog_list_feedback.dart';
import 'providers/catalog_provider.dart';
import 'widgets/catalog_empty_state.dart';
import 'widgets/catalog_list_item.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  static const _maxContentWidth = 960.0;

  Future<void> _openNewItem() async {
    final created = await context.push<bool>(AppRoutes.catalogNew);

    if (created == true && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          CatalogListFeedbackPresenter.showSnackBar(
            CatalogListFeedback.created,
          );
        }
      });
    }
  }

  int _crossAxisCount(double width) {
    if (width < 520) {
      return 1;
    }
    if (width < 800) {
      return 2;
    }
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(catalogProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Catálogo',
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          if (items.isNotEmpty)
            IconButton(
              key: const Key('catalog_app_bar_new_button'),
              icon: const Icon(Icons.add),
              tooltip: 'Novo item',
              onPressed: _openNewItem,
            ),
        ],
      ),
      body: items.isEmpty
          ? CatalogEmptyState(
              onNewItem: _openNewItem,
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = _crossAxisCount(constraints.maxWidth);
                final horizontalPadding = 24.0;
                final spacing = 16.0;
                final availableWidth = constraints.maxWidth -
                    (horizontalPadding * 2) -
                    (spacing * (crossAxisCount - 1));
                final itemWidth = availableWidth / crossAxisCount;
                final childAspectRatio = itemWidth / 280;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _maxContentWidth,
                    ),
                    child: GridView.builder(
                      key: const Key('catalog_items_grid'),
                      padding: EdgeInsets.all(horizontalPadding),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return CatalogListItem(item: items[index]);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
