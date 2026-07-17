import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/team_role.dart';

Future<TeamRole?> showTeamRoleFormDialog({
  required BuildContext context,
  TeamRole? existing,
}) {
  return showDialog<TeamRole>(
    context: context,
    builder: (context) => TeamRoleFormDialog(existing: existing),
  );
}

class TeamRoleFormDialog extends StatefulWidget {
  const TeamRoleFormDialog({super.key, this.existing});

  final TeamRole? existing;

  @override
  State<TeamRoleFormDialog> createState() => _TeamRoleFormDialogState();
}

class _TeamRoleFormDialogState extends State<TeamRoleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late bool _active;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _descriptionController =
        TextEditingController(text: existing?.description ?? '');
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
    final now = DateTime(2020);
    final description = _descriptionController.text.trim();
    final draft = TeamRole(
      id: widget.existing?.id ?? '',
      name: _nameController.text.trim(),
      description: description.isEmpty ? null : description,
      active: _active,
      createdAt: widget.existing?.createdAt ?? now,
      updatedAt: widget.existing?.updatedAt ?? now,
    );
    Navigator.of(context).pop(draft);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(_isEditing ? 'Editar função' : 'Nova função'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              key: const Key('team_role_form_name'),
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
              key: const Key('team_role_form_description'),
              label: 'Descrição',
              controller: _descriptionController,
              maxLines: 2,
            ),
            SwitchListTile(
              key: const Key('team_role_form_active'),
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
          key: const Key('team_role_form_save'),
          onPressed: _submit,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
