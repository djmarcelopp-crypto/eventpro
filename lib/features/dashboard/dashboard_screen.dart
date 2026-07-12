import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo ao EventPro',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Text(
                'Dashboard provisório — MVP em construção',
                style: AppTextStyles.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
