import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class CatalogDetailRow extends StatelessWidget {
  const CatalogDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
