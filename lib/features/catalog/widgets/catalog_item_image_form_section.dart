import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'catalog_item_image_view.dart';

class CatalogItemImageFormSection extends StatelessWidget {
  const CatalogItemImageFormSection({
    super.key,
    required this.previewReference,
    required this.onSelectPhoto,
    required this.onReplacePhoto,
    required this.onRemovePhoto,
    this.isBusy = false,
  });

  final String? previewReference;
  final VoidCallback onSelectPhoto;
  final VoidCallback onReplacePhoto;
  final VoidCallback onRemovePhoto;
  final bool isBusy;

  bool get _hasPreview => previewReference != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CatalogItemImageView(
            key: ValueKey('catalog_form_image_$previewReference'),
            imageReference: previewReference,
            width: 160,
            height: 120,
          ),
        ),
        const SizedBox(height: 12),
        if (!_hasPreview)
          OutlinedButton.icon(
            key: const Key('catalog_select_photo_button'),
            onPressed: isBusy ? null : onSelectPhoto,
            icon: const Icon(Icons.photo_outlined),
            label: const Text('Selecionar foto'),
          )
        else ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                key: const Key('catalog_replace_photo_button'),
                onPressed: isBusy ? null : onReplacePhoto,
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Trocar foto'),
              ),
              OutlinedButton.icon(
                key: const Key('catalog_remove_photo_button'),
                onPressed: isBusy ? null : onRemovePhoto,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remover foto'),
              ),
            ],
          ),
        ],
        const SizedBox(height: 4),
        Text(
          'Formatos aceitos: JPG e PNG. Tamanho máximo: 10 MB.',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}
