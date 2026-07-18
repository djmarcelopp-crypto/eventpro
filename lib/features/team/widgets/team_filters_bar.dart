import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/team_filters.dart';
import '../models/team_member_status.dart';
import '../models/team_role.dart';

class TeamFiltersBar extends StatefulWidget {
  const TeamFiltersBar({
    super.key,
    required this.filters,
    required this.roles,
    required this.onRoleChanged,
    required this.onStatusChanged,
    required this.onNameQueryChanged,
    required this.onClear,
  });

  final TeamFilters filters;
  final List<TeamRole> roles;
  final ValueChanged<String?> onRoleChanged;
  final ValueChanged<TeamMemberStatus?> onStatusChanged;
  final ValueChanged<String> onNameQueryChanged;
  final VoidCallback onClear;

  @override
  State<TeamFiltersBar> createState() => _TeamFiltersBarState();
}

class _TeamFiltersBarState extends State<TeamFiltersBar> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.filters.nameQuery);
  }

  @override
  void didUpdateWidget(covariant TeamFiltersBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filters.nameQuery != _nameController.text &&
        widget.filters.nameQuery != oldWidget.filters.nameQuery) {
      _nameController.text = widget.filters.nameQuery;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = widget.filters;
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Filtros', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('team_filter_search'),
            label: 'Buscar colaborador',
            controller: _nameController,
            onChanged: widget.onNameQueryChanged,
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 560;
              final roleDropdown = DropdownButtonFormField<String?>(
                key: const Key('team_filter_role'),
                initialValue: filters.roleId,
                decoration: const InputDecoration(labelText: 'Função'),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Todas'),
                  ),
                  for (final role in widget.roles)
                    DropdownMenuItem(value: role.id, child: Text(role.name)),
                ],
                onChanged: widget.onRoleChanged,
              );
              final statusDropdown =
                  DropdownButtonFormField<TeamMemberStatus?>(
                key: const Key('team_filter_status'),
                initialValue: filters.status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: [
                  const DropdownMenuItem<TeamMemberStatus?>(
                    value: null,
                    child: Text('Todos'),
                  ),
                  for (final status in TeamMemberStatus.values)
                    DropdownMenuItem(
                      value: status,
                      child: Text(status.label),
                    ),
                ],
                onChanged: widget.onStatusChanged,
              );
              if (stacked) {
                return Column(
                  children: [
                    roleDropdown,
                    const SizedBox(height: 12),
                    statusDropdown,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: roleDropdown),
                  const SizedBox(width: 12),
                  Expanded(child: statusDropdown),
                ],
              );
            },
          ),
          if (filters.hasActiveFilters) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const Key('team_filter_clear'),
                onPressed: widget.onClear,
                child: Text(
                  'Limpar filtros',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
