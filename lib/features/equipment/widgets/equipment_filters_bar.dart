import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/equipment_category.dart';
import '../models/equipment_filters.dart';
import '../models/equipment_status.dart';

class EquipmentFiltersBar extends StatefulWidget {
  const EquipmentFiltersBar({
    super.key,
    required this.filters,
    required this.categories,
    required this.onCategoryChanged,
    required this.onStatusChanged,
    required this.onNameQueryChanged,
    required this.onClear,
  });

  final EquipmentFilters filters;
  final List<EquipmentCategory> categories;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<EquipmentStatus?> onStatusChanged;
  final ValueChanged<String> onNameQueryChanged;
  final VoidCallback onClear;

  @override
  State<EquipmentFiltersBar> createState() => _EquipmentFiltersBarState();
}

class _EquipmentFiltersBarState extends State<EquipmentFiltersBar> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.filters.nameQuery);
  }

  @override
  void didUpdateWidget(covariant EquipmentFiltersBar oldWidget) {
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
            key: const Key('equipment_filter_name'),
            label: 'Buscar por nome',
            controller: _nameController,
            onChanged: widget.onNameQueryChanged,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            key: const Key('equipment_filter_category'),
            initialValue: filters.categoryId,
            decoration: const InputDecoration(labelText: 'Categoria'),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Todas'),
              ),
              for (final category in widget.categories)
                DropdownMenuItem<String?>(
                  value: category.id,
                  child: Text(category.name),
                ),
            ],
            onChanged: widget.onCategoryChanged,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<EquipmentStatus?>(
            key: const Key('equipment_filter_status'),
            initialValue: filters.status,
            decoration: const InputDecoration(labelText: 'Status'),
            items: [
              const DropdownMenuItem<EquipmentStatus?>(
                value: null,
                child: Text('Todos'),
              ),
              for (final status in EquipmentStatus.values)
                DropdownMenuItem<EquipmentStatus?>(
                  value: status,
                  child: Text(status.label),
                ),
            ],
            onChanged: widget.onStatusChanged,
          ),
          if (filters.hasActiveFilters) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const Key('equipment_filters_clear_button'),
                onPressed: widget.onClear,
                child: const Text('Limpar filtros'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
