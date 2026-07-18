import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/equipment_category.dart';

Future<EquipmentCategory?> showEquipmentCategoryFormDialog({
  required BuildContext context,
  EquipmentCategory? existing,
}) {
  return showDialog<EquipmentCategory>(
    context: context,
    builder: (context) => EquipmentCategoryFormDialog(existing: existing),
  );
}

class EquipmentCategoryFormDialog extends StatefulWidget {
  const EquipmentCategoryFormDialog({super.key, this.existing});

  final EquipmentCategory? existing;

  @override
  State<EquipmentCategoryFormDialog> createState() =>
      _EquipmentCategoryFormDialogState();
}

class _EquipmentCategoryFormDialogState
    extends State<EquipmentCategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late bool _active;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _descriptionController = TextEditingController(
      text: existing?.description ?? '',
    );
    _active = existing?.active ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final now = DateTime.now();
    final existing = widget.existing;
    final description = _descriptionController.text.trim();
    Navigator.of(context).pop(
      EquipmentCategory(
        id: existing?.id ?? '',
        name: _nameController.text.trim(),
        description: description.isEmpty ? null : description,
        active: _active,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(isEditing ? 'Editar categoria' : 'Nova categoria'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              key: const Key('equipment_category_name'),
              label: 'Nome',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe o nome.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            AppTextField(
              key: const Key('equipment_category_description'),
              label: 'Descrição (opcional)',
              controller: _descriptionController,
            ),
            SwitchListTile(
              key: const Key('equipment_category_active'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Ativa'),
              value: _active,
              onChanged: (value) => setState(() => _active = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          key: const Key('equipment_category_save_button'),
          onPressed: _submit,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
