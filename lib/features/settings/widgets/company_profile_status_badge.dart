import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/company_profile_status.dart';

class CompanyProfileStatusBadge extends StatelessWidget {
  const CompanyProfileStatusBadge({
    super.key,
    required this.status,
  });

  final CompanyProfileStatus status;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (status) {
      CompanyProfileStatus.notConfigured => (
          AppColors.surfaceVariant,
          AppColors.secondaryText,
        ),
      CompanyProfileStatus.incomplete => (
          AppColors.warning.withValues(alpha: 0.2),
          AppColors.warning,
        ),
      CompanyProfileStatus.configured => (
          AppColors.success.withValues(alpha: 0.2),
          AppColors.success,
        ),
    };

    return Container(
      key: Key('settings_status_badge_${status.name}'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: foreground.withValues(alpha: 0.4)),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.caption.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
