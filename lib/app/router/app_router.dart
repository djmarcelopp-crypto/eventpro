import 'package:go_router/go_router.dart';

import '../../features/catalog/catalog_item_detail_screen.dart';
import '../../features/catalog/catalog_screen.dart';
import '../../features/catalog/new_catalog_item_screen.dart';
import '../../features/clients/client_detail_screen.dart';
import '../../features/clients/clients_screen.dart';
import '../../features/clients/new_client_screen.dart';
import '../../features/quotes/new_quote_screen.dart';
import '../../features/quotes/quote_detail_screen.dart';
import '../../features/quotes/quotes_screen.dart';
import '../../features/settings/company_profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../splash_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const dashboard = '/dashboard';
  static const clients = '/clients';
  static const catalog = '/catalog';
  static const quotes = '/quotes';
  static const quotesNew = '/quotes/new';

  static String quotesDetail(String id) => '$quotes/$id';

  static String quotesEdit(String id) => '$quotes/$id/edit';
  static const catalogNew = '/catalog/new';

  static String catalogDetail(String id) => '$catalog/$id';

  static String catalogEdit(String id) => '$catalog/$id/edit';
  static const clientsNew = '/clients/new';

  static String clientsDetail(String id) => '$clients/$id';

  static String clientsEdit(String id) => '$clients/$id/edit';
  static const settings = '/settings';
  static const settingsCompany = '/settings/company';
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
          GoRoute(
            path: ':id',
            builder: (context, state) => CatalogItemDetailScreen(
              itemId: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => NewCatalogItemScreen(
                  itemId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.quotes,
        builder: (context, state) => const QuotesScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const NewQuoteScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => QuoteDetailScreen(
              quoteId: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => NewQuoteScreen(
                  quoteId: state.pathParameters['id'],
                ),
              ),
            ],
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
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'company',
            builder: (context, state) => const CompanyProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
