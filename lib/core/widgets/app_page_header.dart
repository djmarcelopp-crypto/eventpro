import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Standardized app bar for module screens.
///
/// Prefer stack pop when available. For shallow `go()` module switches, show
/// back to the operations dashboard. On the dashboard itself, show the shell
/// menu affordance for compact layouts.
class AppPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.actions,
    this.forceBack = false,
    this.onBack,
    this.bottom,
  });

  final String title;
  final List<Widget>? actions;
  final bool forceBack;
  final VoidCallback? onBack;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  bool _isOperationsRoot(String location) {
    return location == AppRoutes.dashboard ||
        location == AppRoutes.splash ||
        location == '/';
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.maybeOf(context);
    final location = router == null
        ? AppRoutes.dashboard
        : GoRouterState.of(context).uri.path;
    final stackCanPop = router != null && context.canPop();
    final canPop = forceBack || stackCanPop;
    final showBackToDashboard =
        router != null && !canPop && !_isOperationsRoot(location);

    return AppBar(
      leading: canPop || showBackToDashboard
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Voltar',
              onPressed: onBack ??
                  () {
                    // Prefer a real stack pop; dashboard is only a no-stack fallback.
                    if (router != null && context.canPop()) {
                      context.pop();
                      return;
                    }
                    if (router != null) {
                      context.go(AppRoutes.dashboard);
                    }
                  },
            )
          : IconButton(
              key: const Key('app_page_menu_button'),
              icon: const Icon(Icons.menu),
              tooltip: 'Menu',
              onPressed: () => Scaffold.maybeOf(context)?.openDrawer(),
            ),
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
      ),
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.white,
      elevation: 0,
      actions: actions,
      bottom: bottom,
    );
  }
}
