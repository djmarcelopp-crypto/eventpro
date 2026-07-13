import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import 'catalog_item_image_placeholder.dart';

class CatalogEmptyState extends StatelessWidget {
  const CatalogEmptyState({
    super.key,
    required this.onNewItem,
  });

  final VoidCallback onNewItem;

  static const _maxContentWidth = 480.0;
  static const _maxButtonWidth = 320.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CatalogItemImagePlaceholder(
                width: 200,
                height: 150,
              ),
              const SizedBox(height: 24),
              Text(
                'Nenhum item no catálogo',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Cadastre equipamentos e serviços para usar nos orçamentos',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxButtonWidth),
                child: PrimaryButton(
                  key: const Key('catalog_new_item_button'),
                  label: 'Novo item',
                  onPressed: onNewItem,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
