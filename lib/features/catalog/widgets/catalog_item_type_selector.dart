import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../catalog_item_type.dart';

class CatalogItemTypeSelector extends StatelessWidget {
  const CatalogItemTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    this.disabledTypes = const {},
  });

  static const _compactBreakpoint = 480.0;

  final CatalogItemType selected;
  final ValueChanged<CatalogItemType> onChanged;
  final Set<CatalogItemType> disabledTypes;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _compactBreakpoint) {
          return _CompactTypeDropdown(
            selected: selected,
            onChanged: onChanged,
            disabledTypes: disabledTypes,
          );
        }

        return SegmentedButton<CatalogItemType>(
          key: const Key('catalog_type_segmented'),
          segments: [
            ButtonSegment(
              value: CatalogItemType.equipment,
              label: const Text('Equipamento'),
              enabled: !disabledTypes.contains(CatalogItemType.equipment),
            ),
            ButtonSegment(
              value: CatalogItemType.service,
              label: const Text('Serviço'),
              enabled: !disabledTypes.contains(CatalogItemType.service),
            ),
            ButtonSegment(
              value: CatalogItemType.package,
              label: const Text('Pacote'),
              enabled: !disabledTypes.contains(CatalogItemType.package),
            ),
          ],
          selected: {selected},
          onSelectionChanged: (selection) {
            final next = selection.first;
            if (!disabledTypes.contains(next)) {
              onChanged(next);
            }
          },
        );
      },
    );
  }
}

class _CompactTypeDropdown extends StatelessWidget {
  const _CompactTypeDropdown({
    required this.selected,
    required this.onChanged,
    required this.disabledTypes,
  });

  final CatalogItemType selected;
  final ValueChanged<CatalogItemType> onChanged;
  final Set<CatalogItemType> disabledTypes;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CatalogItemType>(
      key: const Key('catalog_type_dropdown'),
      initialValue: selected,
      decoration: InputDecoration(
        labelText: 'Tipo',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      items: [
        for (final type in CatalogItemType.values)
          DropdownMenuItem(
            value: type,
            enabled: !disabledTypes.contains(type),
            child: Text(
              type.label,
              style: AppTextStyles.bodyMedium,
            ),
          ),
      ],
      onChanged: (value) {
        if (value != null && !disabledTypes.contains(value)) {
          onChanged(value);
        }
      },
    );
  }
}
