import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/vehicle_filters.dart';
import '../models/vehicle_status.dart';
import '../models/vehicle_type.dart';

class VehicleFiltersBar extends StatefulWidget {
  const VehicleFiltersBar({
    super.key,
    required this.filters,
    required this.types,
    required this.onTypeChanged,
    required this.onStatusChanged,
    required this.onPlateQueryChanged,
    required this.onClear,
  });

  final VehicleFilters filters;
  final List<VehicleType> types;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<VehicleStatus?> onStatusChanged;
  final ValueChanged<String> onPlateQueryChanged;
  final VoidCallback onClear;

  @override
  State<VehicleFiltersBar> createState() => _VehicleFiltersBarState();
}

class _VehicleFiltersBarState extends State<VehicleFiltersBar> {
  late final TextEditingController _plateController;

  @override
  void initState() {
    super.initState();
    _plateController = TextEditingController(text: widget.filters.plateQuery);
  }

  @override
  void didUpdateWidget(covariant VehicleFiltersBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filters.plateQuery != _plateController.text &&
        widget.filters.plateQuery != oldWidget.filters.plateQuery) {
      _plateController.text = widget.filters.plateQuery;
    }
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = widget.filters;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: const Key('vehicle_filter_plate'),
          label: 'Buscar placa ou descrição',
          controller: _plateController,
          onChanged: widget.onPlateQueryChanged,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String?>(
                key: const Key('vehicle_filter_type'),
                initialValue: filters.vehicleTypeId,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  filled: true,
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Todos'),
                  ),
                  for (final type in widget.types)
                    DropdownMenuItem(
                      value: type.id,
                      child: Text(type.name),
                    ),
                ],
                onChanged: widget.onTypeChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<VehicleStatus?>(
                key: const Key('vehicle_filter_status'),
                initialValue: filters.status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  filled: true,
                ),
                items: [
                  const DropdownMenuItem<VehicleStatus?>(
                    value: null,
                    child: Text('Todos'),
                  ),
                  for (final status in VehicleStatus.values)
                    DropdownMenuItem(
                      value: status,
                      child: Text(status.label),
                    ),
                ],
                onChanged: widget.onStatusChanged,
              ),
            ),
          ],
        ),
        if (filters.hasActiveFilters) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              key: const Key('vehicle_filters_clear'),
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
    );
  }
}
