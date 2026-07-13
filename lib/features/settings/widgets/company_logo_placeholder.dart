import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CompanyLogoPlaceholder extends StatelessWidget {
  const CompanyLogoPlaceholder({
    super.key,
    this.width = 120,
    this.height = 120,
    this.borderRadius = 12,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('company_logo_placeholder'),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: Icon(
          Icons.business_outlined,
          size: 40,
          color: AppColors.secondaryText,
        ),
      ),
    );
  }
}
