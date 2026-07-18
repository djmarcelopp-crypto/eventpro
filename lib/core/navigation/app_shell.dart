import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_shell_destination.dart';

/// Persistent desktop/mobile navigation shell for the product experience.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _railBreakpoint = 900.0;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = appShellSelectedIndex(location);

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= _railBreakpoint;
        if (useRail) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  key: const Key('app_shell_rail'),
                  backgroundColor: AppColors.surface,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) {
                    context.go(appShellDestinations[index].route);
                  },
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(
                    color: AppColors.primary,
                  ),
                  selectedLabelTextStyle: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                  unselectedIconTheme: IconThemeData(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                  unselectedLabelTextStyle: AppTextStyles.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                  destinations: [
                    for (final destination in appShellDestinations)
                      NavigationRailDestination(
                        icon: Icon(destination.icon),
                        label: Text(destination.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1, color: AppColors.border),
                Expanded(child: child),
              ],
            ),
          );
        }

        return Scaffold(
          key: const Key('app_shell_scaffold'),
          drawer: Drawer(
            key: const Key('app_shell_drawer'),
            backgroundColor: AppColors.surface,
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Text(
                      'EVENTPRO',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  for (var index = 0;
                      index < appShellDestinations.length;
                      index++)
                    ListTile(
                      leading: Icon(
                        appShellDestinations[index].icon,
                        color: index == selectedIndex
                            ? AppColors.primary
                            : AppColors.white.withValues(alpha: 0.75),
                      ),
                      title: Text(
                        appShellDestinations[index].label,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: index == selectedIndex
                              ? AppColors.primary
                              : AppColors.white,
                        ),
                      ),
                      selected: index == selectedIndex,
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go(appShellDestinations[index].route);
                      },
                    ),
                ],
              ),
            ),
          ),
          body: child,
        );
      },
    );
  }
}
