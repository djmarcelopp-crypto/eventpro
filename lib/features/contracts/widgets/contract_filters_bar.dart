import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/contract_filters.dart';
import '../models/contract_status.dart';

class ContractFiltersBar extends StatefulWidget {
  const ContractFiltersBar({
    super.key,
    required this.filters,
    required this.onStatusChanged,
    required this.onNumberQueryChanged,
    required this.onClear,
  });

  final ContractFilters filters;
  final ValueChanged<ContractStatus?> onStatusChanged;
  final ValueChanged<String> onNumberQueryChanged;
  final VoidCallback onClear;

  @override
  State<ContractFiltersBar> createState() => _ContractFiltersBarState();
}

class _ContractFiltersBarState extends State<ContractFiltersBar> {
  late final TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController =
        TextEditingController(text: widget.filters.numberQuery);
  }

  @override
  void didUpdateWidget(covariant ContractFiltersBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filters.numberQuery != _queryController.text &&
        widget.filters.numberQuery != oldWidget.filters.numberQuery) {
      _queryController.text = widget.filters.numberQuery;
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = widget.filters;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: const Key('contract_filter_number'),
          label: 'Buscar número ou orçamento',
          controller: _queryController,
          onChanged: widget.onNumberQueryChanged,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<ContractStatus?>(
          key: const Key('contract_filter_status'),
          initialValue: filters.status,
          decoration: const InputDecoration(labelText: 'Status', filled: true),
          items: [
            const DropdownMenuItem<ContractStatus?>(
              value: null,
              child: Text('Todos'),
            ),
            for (final status in ContractStatus.values)
              DropdownMenuItem(
                value: status,
                child: Text(status.label),
              ),
          ],
          onChanged: widget.onStatusChanged,
        ),
        if (filters.hasActiveFilters) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              key: const Key('contract_filters_clear'),
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
