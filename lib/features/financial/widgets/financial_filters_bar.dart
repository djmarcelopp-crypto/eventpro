import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/financial_entry_filters.dart';
import '../models/financial_entry_status.dart';
import '../models/financial_flow_kind.dart';
import '../utils/financial_display_formatter.dart';

class FinancialFiltersBar extends StatelessWidget {
  const FinancialFiltersBar({
    super.key,
    required this.filters,
    required this.onKindChanged,
    required this.onStatusChanged,
    required this.onPeriodStartTap,
    required this.onPeriodEndTap,
    required this.onClear,
  });

  final FinancialEntryFilters filters;
  final ValueChanged<FinancialFlowKind?> onKindChanged;
  final ValueChanged<FinancialEntryStatus?> onStatusChanged;
  final VoidCallback onPeriodStartTap;
  final VoidCallback onPeriodEndTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _FilterChipButton(
              key: const Key('financial_filter_period_start'),
              label: filters.periodStart == null
                  ? 'De'
                  : 'De ${FinancialDisplayFormatter.civilDate(filters.periodStart!)}',
              selected: filters.periodStart != null,
              onTap: onPeriodStartTap,
            ),
            _FilterChipButton(
              key: const Key('financial_filter_period_end'),
              label: filters.periodEnd == null
                  ? 'Até'
                  : 'Até ${FinancialDisplayFormatter.civilDate(filters.periodEnd!)}',
              selected: filters.periodEnd != null,
              onTap: onPeriodEndTap,
            ),
            DropdownButton<FinancialFlowKind?>(
              key: const Key('financial_filter_kind'),
              value: filters.kind,
              hint: Text(
                'Tipo',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mutedWhite,
                ),
              ),
              underline: const SizedBox.shrink(),
              dropdownColor: AppColors.surface,
              items: [
                const DropdownMenuItem<FinancialFlowKind?>(
                  value: null,
                  child: Text('Todos os tipos'),
                ),
                for (final kind in FinancialFlowKind.values)
                  DropdownMenuItem(
                    value: kind,
                    child: Text(kind.label),
                  ),
              ],
              onChanged: onKindChanged,
            ),
            DropdownButton<FinancialEntryStatus?>(
              key: const Key('financial_filter_status'),
              value: filters.status,
              hint: Text(
                'Status',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mutedWhite,
                ),
              ),
              underline: const SizedBox.shrink(),
              dropdownColor: AppColors.surface,
              items: [
                const DropdownMenuItem<FinancialEntryStatus?>(
                  value: null,
                  child: Text('Todos os status'),
                ),
                for (final status in FinancialEntryStatus.values)
                  DropdownMenuItem(
                    value: status,
                    child: Text(status.label),
                  ),
              ],
              onChanged: onStatusChanged,
            ),
            if (filters.hasActiveFilters)
              TextButton(
                key: const Key('financial_filter_clear'),
                onPressed: onClear,
                child: const Text('Limpar'),
              ),
          ],
        ),
      ],
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withValues(alpha: 0.3),
      checkmarkColor: AppColors.primary,
      labelStyle: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
    );
  }
}
