import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'providers/catalog_provider.dart';
import 'widgets/catalog_empty_state.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  static const _maxContentWidth = 720.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              icon: const Icon(Icons.add),
              tooltip: 'Novo item',
              onPressed: () {},
            ),
        ],
      ),
      body: items.isEmpty
          ? CatalogEmptyState(
              onNewItem: () {},
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _maxContentWidth,
                        ),
                        child: Text(
                          item.name,
                          style: AppTextStyles.titleSmall,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
