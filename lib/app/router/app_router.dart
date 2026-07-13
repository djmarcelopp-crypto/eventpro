import 'package:go_router/go_router.dart';

import '../../features/clients/clients_screen.dart';
import '../../features/clients/new_client_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../splash_screen.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const dashboard = '/dashboard';
  static const clients = '/clients';
  static const clientsNew = '/clients/new';
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
      GoRoute(
        path: AppRoutes.clients,
        builder: (context, state) => const ClientsScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const NewClientScreen(),
          ),
        ],
      ),
    ],
  );
}
