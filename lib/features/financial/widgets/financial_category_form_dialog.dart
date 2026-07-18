import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/financial_category.dart';
import '../models/financial_flow_kind.dart';

Future<FinancialCategory?> showFinancialCategoryFormDialog({
  required BuildContext context,
  FinancialCategory? existing,
}) {
  return showDialog<FinancialCategory>(
    context: context,
    builder: (context) => FinancialCategoryFormDialog(existing: existing),
  );
}

class FinancialCategoryFormDialog extends StatefulWidget {
  const FinancialCategoryFormDialog({super.key, this.existing});

  final FinancialCategory? existing;

  @override
  State<FinancialCategoryFormDialog> createState() =>
      _FinancialCategoryFormDialogState();
}

class _FinancialCategoryFormDialogState
    extends State<FinancialCategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late FinancialFlowKind _kind;
  late bool _active;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _kind = existing?.kind ?? FinancialFlowKind.expense;
    _active = existing?.active ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final now = DateTime.now();
    final existing = widget.existing;
    Navigator.of(context).pop(
      FinancialCategory(
        id: existing?.id ?? '',
        name: _nameController.text.trim(),
        kind: _kind,
        active: _active,
        createdAt: existing?.createdAt ?? now,
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
              key: const Key('financial_category_name'),
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
            KeyedSubtree(
              key: const Key('financial_category_kind'),
              child: DropdownButtonFormField<FinancialFlowKind>(
                key: ValueKey('financial_category_kind_${_kind.name}'),
                initialValue: _kind,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: [
                  for (final kind in FinancialFlowKind.values)
                    DropdownMenuItem(value: kind, child: Text(kind.label)),
                ],
                onChanged: isEditing
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _kind = value);
                        }
                      },
              ),
            ),
            SwitchListTile(
              key: const Key('financial_category_active'),
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
          key: const Key('financial_category_save_button'),
          onPressed: _submit,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
