import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppBreadcrumbItem {
  const AppBreadcrumbItem({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;
}

/// Lightweight breadcrumb trail for nested module screens.
class AppBreadcrumb extends StatelessWidget {
  const AppBreadcrumb({super.key, required this.items});

  final List<AppBreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                '/',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.white.withValues(alpha: 0.45),
                ),
              ),
            ),
          if (items[index].onTap == null)
            Text(
              items[index].label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.white.withValues(alpha: 0.85),
              ),
            )
          else
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppColors.primary,
              ),
              onPressed: items[index].onTap,
              child: Text(
                items[index].label,
                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
              ),
            ),
        ],
      ],
    );
  }
}
