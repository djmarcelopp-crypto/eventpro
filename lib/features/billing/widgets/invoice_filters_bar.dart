import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/invoice_filters.dart';
import '../models/invoice_status.dart';
import '../models/invoice_type.dart';

class InvoiceFiltersBar extends StatefulWidget {
  const InvoiceFiltersBar({
    super.key,
    required this.filters,
    required this.onStatusChanged,
    required this.onTypeChanged,
    required this.onNumberQueryChanged,
    required this.onClear,
  });

  final InvoiceFilters filters;
  final ValueChanged<InvoiceStatus?> onStatusChanged;
  final ValueChanged<InvoiceType?> onTypeChanged;
  final ValueChanged<String> onNumberQueryChanged;
  final VoidCallback onClear;

  @override
  State<InvoiceFiltersBar> createState() => _InvoiceFiltersBarState();
}

class _InvoiceFiltersBarState extends State<InvoiceFiltersBar> {
  late final TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController =
        TextEditingController(text: widget.filters.numberQuery);
  }

  @override
  void didUpdateWidget(covariant InvoiceFiltersBar oldWidget) {
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
          key: const Key('invoice_filter_number'),
          label: 'Buscar número / orçamento',
          controller: _queryController,
          onChanged: widget.onNumberQueryChanged,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<InvoiceStatus?>(
                key: const Key('invoice_filter_status'),
                initialValue: filters.status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: [
                  const DropdownMenuItem<InvoiceStatus?>(
                    value: null,
                    child: Text('Todos'),
                  ),
                  for (final status in InvoiceStatus.values)
                    DropdownMenuItem(
                      value: status,
                      child: Text(status.label),
                    ),
                ],
                onChanged: widget.onStatusChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<InvoiceType?>(
                key: const Key('invoice_filter_type'),
                initialValue: filters.type,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: [
                  const DropdownMenuItem<InvoiceType?>(
                    value: null,
                    child: Text('Todos'),
                  ),
                  for (final type in InvoiceType.values)
                    DropdownMenuItem(
                      value: type,
                      child: Text(type.label),
                    ),
                ],
                onChanged: widget.onTypeChanged,
              ),
            ),
          ],
        ),
        if (filters.hasActiveFilters) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              key: const Key('invoice_filters_clear'),
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
