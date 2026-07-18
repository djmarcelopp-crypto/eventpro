import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

enum AppStatusBannerTone { success, warning, info, error }

/// Inline status banner for success/warning/info/error feedback.
class AppStatusBanner extends StatelessWidget {
  const AppStatusBanner({
    super.key,
    required this.message,
    required this.tone,
  });

  final String message;
  final AppStatusBannerTone tone;

  Color get _color => switch (tone) {
        AppStatusBannerTone.success => AppColors.success,
        AppStatusBannerTone.warning => AppColors.warning,
        AppStatusBannerTone.info => AppColors.primary,
        AppStatusBannerTone.error => AppColors.error,
      };

  IconData get _icon => switch (tone) {
        AppStatusBannerTone.success => Icons.check_circle_outline,
        AppStatusBannerTone.warning => Icons.warning_amber_outlined,
        AppStatusBannerTone.info => Icons.info_outline,
        AppStatusBannerTone.error => Icons.error_outline,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(_icon, color: _color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
