import 'package:go_router/go_router.dart';

import '../../features/dashboard/dashboard_screen.dart';
import '../splash_screen.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const dashboard = '/dashboard';
}

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
