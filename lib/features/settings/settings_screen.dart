import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_page_header.dart';
import 'providers/company_profile_provider.dart';
import 'utils/company_profile_completeness.dart';
import 'utils/settings_navigation.dart';
import 'widgets/company_profile_summary_card.dart';
import 'widgets/demo_environment_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _maxContentWidth = 720.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(companyProfileProvider);
    final status = CompanyProfileCompleteness.status(profile);

    return Scaffold(
      appBar: AppPageHeader(
        title: 'Configurações',
        forceBack: true,
        onBack: () => SettingsNavigation.leaveSettings(context),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            key: const Key('settings_scroll'),
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Empresa',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    CompanyProfileSummaryCard(
                      profile: profile,
                      status: status,
                      onTap: () => context.push(AppRoutes.settingsCompany),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Demonstração',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    const DemoEnvironmentCard(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
