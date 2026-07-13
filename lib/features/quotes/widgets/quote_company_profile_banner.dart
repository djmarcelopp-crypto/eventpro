import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../settings/models/company_profile.dart';
import '../../settings/models/company_profile_status.dart';
import '../../settings/utils/company_profile_completeness.dart';

class QuoteCompanyProfileBanner extends StatelessWidget {
  const QuoteCompanyProfileBanner({
    super.key,
    required this.profile,
    required this.onConfigureCompany,
  });

  final CompanyProfile? profile;
  final VoidCallback onConfigureCompany;

  @override
  Widget build(BuildContext context) {
    final status = CompanyProfileCompleteness.status(profile);
    if (status == CompanyProfileStatus.configured) {
      return const SizedBox.shrink();
    }

    final missing = profile == null
        ? const <String>[]
        : CompanyProfileCompleteness.missingRecommendations(profile!);

    return AppCard(
      key: const Key('quote_company_profile_banner'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (status == CompanyProfileStatus.notConfigured)
                      Text(
                        'Configure os dados da empresa para emitir documentos '
                        'profissionais.',
                        style: AppTextStyles.bodyMedium,
                      ),
                    if (status == CompanyProfileStatus.incomplete) ...[
                      Text(
                        'Dados profissionais incompletos:',
                        style: AppTextStyles.bodyMedium.copyWith(
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              key: const Key('quote_configure_company_button'),
              onPressed: onConfigureCompany,
              child: const Text('Configurar empresa'),
            ),
          ),
        ],
      ),
    );
  }
}
