import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/dashboard_alert.dart';

/// Reusable alerts panel for operational dashboards.
class DashboardAlertsCard extends StatelessWidget {
  const DashboardAlertsCard({super.key, required this.alerts});

  final List<DashboardAlert> alerts;

  Color _colorFor(DashboardAlertSeverity severity) {
    return switch (severity) {
      DashboardAlertSeverity.info => AppColors.primary,
      DashboardAlertSeverity.warning => AppColors.warning,
      DashboardAlertSeverity.error => AppColors.error,
    };
  }

  IconData _iconFor(DashboardAlertSeverity severity) {
    return switch (severity) {
      DashboardAlertSeverity.info => Icons.info_outline,
      DashboardAlertSeverity.warning => Icons.warning_amber_outlined,
      DashboardAlertSeverity.error => Icons.error_outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: const Key('dashboard_alerts_card'),
      padding: const EdgeInsets.all(16),
      child: alerts.isEmpty
          ? Text(
              'Nenhum alerta operacional no momento.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            )
          : Column(
              children: [
                for (var index = 0; index < alerts.length; index++) ...[
                  if (index > 0) const SizedBox(height: 10),
                  InkWell(
                    key: Key('dashboard_alert_${alerts[index].id}'),
                    onTap: alerts[index].route == null
                        ? null
                        : () => context.push(alerts[index].route!),
                    child: Row(
                      children: [
                        Icon(
                          _iconFor(alerts[index].severity),
                          color: _colorFor(alerts[index].severity),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            alerts[index].message,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
