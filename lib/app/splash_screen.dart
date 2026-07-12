import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/primary_button.dart';
import 'router/app_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'EVENTPRO',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'DJ Marcelo PP Festas e Eventos',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Entrar',
                    onPressed: () => context.go(AppRoutes.dashboard),
                  ),
                ],
              ),
              Text(
                'Versão 0.1.0',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
