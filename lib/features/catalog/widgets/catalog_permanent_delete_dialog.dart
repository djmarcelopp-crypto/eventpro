import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';

class CatalogPermanentDeleteDialog extends StatefulWidget {
  const CatalogPermanentDeleteDialog({
    super.key,
    required this.itemName,
  });

  final String itemName;

  @override
  State<CatalogPermanentDeleteDialog> createState() =>
      _CatalogPermanentDeleteDialogState();
}

class _CatalogPermanentDeleteDialogState
    extends State<CatalogPermanentDeleteDialog> {
  final _nameController = TextEditingController();
  var _isSubmitting = false;

  bool get _canConfirm {
    return !_isSubmitting &&
        _nameController.text.trim() == widget.itemName.trim();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_canConfirm || _isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key('catalog_permanent_delete_dialog'),
      title: const Text('Excluir definitivamente'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Esta ação é irreversível. O item será removido permanentemente '
            'do catálogo.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Para confirmar, digite o nome exato do item:',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.itemName,
            style: AppTextStyles.titleSmall,
          ),
          const SizedBox(height: 16),
          AppTextField(
            key: const Key('catalog_delete_confirm_name_field'),
            label: 'Nome do item',
            controller: _nameController,
            enabled: !_isSubmitting,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: const Key('catalog_delete_cancel_button'),
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          key: const Key('catalog_delete_confirm_button'),
          onPressed: _canConfirm ? _submit : null,
          child: Text(
            'Excluir definitivamente',
            style: TextStyle(
              color: _canConfirm ? AppColors.error : AppColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}

Future<bool> showCatalogPermanentDeleteDialog({
  required BuildContext context,
  required String itemName,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return CatalogPermanentDeleteDialog(itemName: itemName);
    },
  ).then((value) => value ?? false);
}
