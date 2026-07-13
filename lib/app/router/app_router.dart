import 'package:go_router/go_router.dart';

import '../../features/catalog/catalog_screen.dart';
import '../../features/catalog/new_catalog_item_screen.dart';
import '../../features/clients/client_detail_screen.dart';
import '../../features/clients/clients_screen.dart';
import '../../features/clients/new_client_screen.dart';
import '../splash_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const dashboard = '/dashboard';
  static const clients = '/clients';
  static const catalog = '/catalog';
  static const catalogNew = '/catalog/new';
  static const clientsNew = '/clients/new';

  static String clientsDetail(String id) => '$clients/$id';

  static String clientsEdit(String id) => '$clients/$id/edit';
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
        path: AppRoutes.catalog,
        builder: (context, state) => const CatalogScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const NewCatalogItemScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.clients,
        builder: (context, state) => const ClientsScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const NewClientScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => ClientDetailScreen(
              clientId: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => NewClientScreen(
                  clientId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
