import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'dashboard_modules.dart';
import 'widgets/dashboard_shortcut_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _maxContentWidth = 1200.0;
  static const _horizontalPadding = 24.0;
  static const _sectionSpacing = 32.0;
  static const _gridSpacing = 16.0;

  int _columnCountForWidth(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 2;
    return 1;
  }

  double _contentWidthFor(double bodyWidth) {
    return (bodyWidth - (_horizontalPadding * 2)).clamp(0, _maxContentWidth);
  }

  double _cardWidthFor(double bodyWidth, int columnCount) {
    final contentWidth = _contentWidthFor(bodyWidth);
    final totalSpacing = _gridSpacing * (columnCount - 1);
    return (contentWidth - totalSpacing) / columnCount;
  }

  void _onModuleTap(BuildContext context, DashboardModuleId id) {
    switch (id) {
      case DashboardModuleId.clients:
        context.push(AppRoutes.clients);
      case DashboardModuleId.catalog:
        context.push(AppRoutes.catalog);
      case DashboardModuleId.quotes:
        context.push(AppRoutes.quotes);
      case DashboardModuleId.settings:
        break;
    }
  }

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columnCount = _columnCountForWidth(constraints.maxWidth);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(_horizontalPadding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: _maxContentWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bem-vindo ao EventPro',
                      style: AppTextStyles.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'DJ Marcelo PP Festas e Eventos',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.mutedWhite,
                      ),
                    ),
                    const SizedBox(height: _sectionSpacing),
                    Text(
                      'Módulos',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: _gridSpacing),
                    Wrap(
                      spacing: _gridSpacing,
                      runSpacing: _gridSpacing,
                      children: [
                        for (final module in dashboardModules)
                          SizedBox(
                            width: _cardWidthFor(
                              constraints.maxWidth,
                              columnCount,
                            ),
                            child: DashboardShortcutCard(
                              module: module,
                              onTap: () => _onModuleTap(context, module.id),
                            ),
                          ),
                      ],
                    ),
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
