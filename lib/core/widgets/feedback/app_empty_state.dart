import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../primary_button.dart';
import '../secondary_button.dart';

/// Shared empty state that orients the user toward the next action.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.primaryActionKey,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final Key? primaryActionKey;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 48, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.75),
                  ),
                ),
                if (primaryActionLabel != null && onPrimaryAction != null) ...[
                  const SizedBox(height: 24),
                  PrimaryButton(
                    key: primaryActionKey,
                    label: primaryActionLabel!,
                    onPressed: onPrimaryAction,
                  ),
                ],
                if (secondaryActionLabel != null &&
                    onSecondaryAction != null) ...[
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: secondaryActionLabel!,
                    onPressed: onSecondaryAction,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
