import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/company_profile.dart';
import '../models/company_profile_status.dart';
import '../utils/company_profile_completeness.dart';
import '../utils/company_profile_presenter.dart';
import 'company_logo_view.dart';
import 'company_profile_status_badge.dart';

class CompanyProfileSummaryCard extends ConsumerWidget {
  const CompanyProfileSummaryCard({
    super.key,
    required this.profile,
    required this.status,
    required this.onTap,
  });

  final CompanyProfile? profile;
  final CompanyProfileStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = profile == null
        ? null
        : CompanyProfilePresenter.formatPrimaryContact(profile!);
    final missing = profile == null
        ? const <String>[]
        : CompanyProfileCompleteness.missingRecommendations(profile!);

    return AppCard(
      child: InkWell(
        key: const Key('settings_company_profile_card'),
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompanyLogoView(
                key: ValueKey('settings_summary_logo_${profile?.logoReference}'),
                imageReference: profile?.logoReference,
                width: 72,
                height: 72,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Dados da empresa',
                            style: AppTextStyles.titleMedium,
                          ),
                        ),
                        CompanyProfileStatusBadge(status: status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      CompanyProfilePresenter.displayName(profile),
                      style: AppTextStyles.bodyLarge,
                    ),
                    if (contact != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        contact,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.mutedWhite,
                        ),
                      ),
                    ],
                    if (status == CompanyProfileStatus.incomplete &&
                        missing.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Falta configurar:',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (final item in missing)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '• $item',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      'Toque para editar os dados da empresa',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
