import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/team_member.dart';

class QuoteTeamAddDraft {
  const QuoteTeamAddDraft({
    required this.teamMemberId,
    this.notes,
  });

  final String teamMemberId;
  final String? notes;
}

Future<QuoteTeamAddDraft?> showQuoteTeamAddDialog({
  required BuildContext context,
  required List<TeamMember> members,
  required Set<String> excludeMemberIds,
}) {
  final available = members
      .where(
        (member) =>
            member.isActive && !excludeMemberIds.contains(member.id),
      )
      .toList(growable: false);

  return showDialog<QuoteTeamAddDraft>(
    context: context,
    builder: (context) => QuoteTeamAddDialog(members: available),
  );
}

class QuoteTeamAddDialog extends StatefulWidget {
  const QuoteTeamAddDialog({super.key, required this.members});

  final List<TeamMember> members;

  @override
  State<QuoteTeamAddDialog> createState() => _QuoteTeamAddDialogState();
}

class _QuoteTeamAddDialogState extends State<QuoteTeamAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  String? _memberId;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_memberId == null) {
      return;
    }
    final notes = _notesController.text.trim();
    Navigator.of(context).pop(
      QuoteTeamAddDraft(
        teamMemberId: _memberId!,
        notes: notes.isEmpty ? null : notes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Adicionar colaborador'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              key: const Key('quote_team_add_member'),
              initialValue: _memberId,
              decoration: const InputDecoration(labelText: 'Colaborador'),
              items: [
                for (final member in widget.members)
                  DropdownMenuItem(
                    value: member.id,
                    child: Text(member.name),
                  ),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecione um colaborador.';
                }
                return null;
              },
              onChanged: (value) => setState(() => _memberId = value),
            ),
            const SizedBox(height: 12),
            AppTextField(
              key: const Key('quote_team_add_notes'),
              label: 'Observações (opcional)',
              controller: _notesController,
              maxLines: 2,
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
          key: const Key('quote_team_add_save_button'),
          onPressed: _submit,
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
