import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'company_logo_view.dart';

class CompanyLogoFormSection extends StatelessWidget {
  const CompanyLogoFormSection({
    super.key,
    required this.previewReference,
    required this.onSelectLogo,
    required this.onReplaceLogo,
    required this.onRemoveLogo,
    this.isBusy = false,
  });

  final String? previewReference;
  final VoidCallback onSelectLogo;
  final VoidCallback onReplaceLogo;
  final VoidCallback onRemoveLogo;
  final bool isBusy;

  bool get _hasPreview => previewReference != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CompanyLogoView(
            key: ValueKey('company_form_logo_$previewReference'),
            imageReference: previewReference,
            width: 120,
            height: 120,
          ),
        ),
        const SizedBox(height: 12),
        if (!_hasPreview)
          OutlinedButton.icon(
            key: const Key('company_select_logo_button'),
            onPressed: isBusy ? null : onSelectLogo,
            icon: const Icon(Icons.image_outlined),
            label: const Text('Selecionar logotipo'),
          )
        else ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                key: const Key('company_replace_logo_button'),
                onPressed: isBusy ? null : onReplaceLogo,
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Trocar logotipo'),
              ),
              OutlinedButton.icon(
                key: const Key('company_remove_logo_button'),
                onPressed: isBusy ? null : onRemoveLogo,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remover logotipo'),
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
