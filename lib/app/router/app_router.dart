import 'package:go_router/go_router.dart';

import '../../features/agenda/agenda_block_detail_screen.dart';
import '../../features/agenda/agenda_screen.dart';
import '../../features/agenda/new_agenda_block_screen.dart';
import '../../features/catalog/catalog_item_detail_screen.dart';
import '../../features/catalog/catalog_screen.dart';
import '../../features/catalog/new_catalog_item_screen.dart';
import '../../features/clients/client_detail_screen.dart';
import '../../features/clients/clients_screen.dart';
import '../../features/clients/new_client_screen.dart';
import '../../features/equipment/equipment_categories_screen.dart';
import '../../features/equipment/equipment_detail_screen.dart';
import '../../features/equipment/equipment_screen.dart';
import '../../features/equipment/new_equipment_screen.dart';
import '../../features/equipment/quote_equipment_screen.dart';
import '../../features/team/new_team_member_screen.dart';
import '../../features/team/quote_team_screen.dart';
import '../../features/team/team_member_detail_screen.dart';
import '../../features/team/team_roles_screen.dart';
import '../../features/team/team_screen.dart';
import '../../features/logistics/new_vehicle_screen.dart';
import '../../features/logistics/quote_vehicles_screen.dart';
import '../../features/logistics/vehicle_detail_screen.dart';
import '../../features/logistics/vehicle_types_screen.dart';
import '../../features/logistics/vehicles_screen.dart';
import '../../features/billing/invoice_detail_screen.dart';
import '../../features/billing/invoices_screen.dart';
import '../../features/billing/new_invoice_screen.dart';
import '../../features/billing/quote_invoices_screen.dart';
import '../../features/contracts/contract_detail_screen.dart';
import '../../features/contracts/contract_templates_screen.dart';
import '../../features/contracts/contracts_screen.dart';
import '../../features/contracts/quote_contracts_screen.dart';
import '../../features/financial/financial_categories_screen.dart';
import '../../features/financial/financial_entry_detail_screen.dart';
import '../../features/financial/financial_screen.dart';
import '../../features/financial/new_financial_entry_screen.dart';
import '../../features/quotes/pdf/quote_pdf_preview_screen.dart';
import '../../features/quotes/new_quote_screen.dart';
import '../../features/quotes/quote_detail_screen.dart';
import '../../features/quotes/quotes_screen.dart';
import '../../features/settings/company_profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../splash_screen.dart';
import '../../core/navigation/app_shell.dart';
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

  static String quotesPdf(String id) => '$quotes/$id/pdf';

  static String quotesEquipment(String id) => '$quotes/$id/equipment';

  static String quotesTeam(String id) => '$quotes/$id/team';

  static String quotesVehicles(String id) => '$quotes/$id/vehicles';

  static String quotesContracts(String id) => '$quotes/$id/contracts';

  static String quotesInvoices(String id) => '$quotes/$id/invoices';
  static const catalogNew = '/catalog/new';

  static String catalogDetail(String id) => '$catalog/$id';

  static String catalogEdit(String id) => '$catalog/$id/edit';
  static const clientsNew = '/clients/new';

  static String clientsDetail(String id) => '$clients/$id';

  static String clientsEdit(String id) => '$clients/$id/edit';
  static const settings = '/settings';
  static const settingsCompany = '/settings/company';

  static const agenda = '/agenda';
  static const agendaNew = '/agenda/new';

  static String agendaDetail(String id) => '$agenda/$id';

  static String agendaEdit(String id) => '$agenda/$id/edit';

  static const financial = '/financial';
  static const financialNew = '/financial/new';
  static const financialCategories = '/financial/categories';

  static String financialDetail(String id) => '$financial/$id';

  static String financialEdit(String id) => '$financial/$id/edit';

  static const equipment = '/equipment';
  static const equipmentNew = '/equipment/new';
  static const equipmentCategories = '/equipment/categories';

  static String equipmentDetail(String id) => '$equipment/$id';

  static String equipmentEdit(String id) => '$equipment/$id/edit';

  static const team = '/team';
  static const teamNew = '/team/new';
  static const teamRoles = '/team/roles';

  static String teamDetail(String id) => '$team/$id';

  static String teamEdit(String id) => '$team/$id/edit';

  static const vehicles = '/vehicles';
  static const vehiclesNew = '/vehicles/new';
  static const vehicleTypes = '/vehicles/types';

  static String vehicleDetail(String id) => '$vehicles/$id';

  static String vehicleEdit(String id) => '$vehicles/$id/edit';

  static const contracts = '/contracts';
  static const contractTemplates = '/contracts/templates';

  static String contractDetail(String id) => '$contracts/$id';

  static const invoices = '/invoices';
  static const invoicesNew = '/invoices/new';

  static String invoiceDetail(String id) => '$invoices/$id';
}

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
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
                GoRoute(
                  path: 'pdf',
                  builder: (context, state) => QuotePdfPreviewScreen(
                    quoteId: state.pathParameters['id']!,
                  ),
                ),
                GoRoute(
                  path: 'equipment',
                  builder: (context, state) => QuoteEquipmentScreen(
                    quoteId: state.pathParameters['id']!,
                  ),
                ),
                GoRoute(
                  path: 'team',
                  builder: (context, state) => QuoteTeamScreen(
                    quoteId: state.pathParameters['id']!,
                  ),
                ),
                GoRoute(
                  path: 'vehicles',
                  builder: (context, state) => QuoteVehiclesScreen(
                    quoteId: state.pathParameters['id']!,
                  ),
                ),
                GoRoute(
                  path: 'contracts',
                  builder: (context, state) => QuoteContractsScreen(
                    quoteId: state.pathParameters['id']!,
                  ),
                ),
                GoRoute(
                  path: 'invoices',
                  builder: (context, state) => QuoteInvoicesScreen(
                    quoteId: state.pathParameters['id']!,
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
        GoRoute(
          path: AppRoutes.agenda,
          builder: (context, state) => const AgendaScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const NewAgendaBlockScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => AgendaBlockDetailScreen(
                blockId: state.pathParameters['id']!,
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => NewAgendaBlockScreen(
                    blockId: state.pathParameters['id'],
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.financial,
          builder: (context, state) => const FinancialScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const NewFinancialEntryScreen(),
            ),
            GoRoute(
              path: 'categories',
              builder: (context, state) => const FinancialCategoriesScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => FinancialEntryDetailScreen(
                entryId: state.pathParameters['id']!,
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => NewFinancialEntryScreen(
                    entryId: state.pathParameters['id'],
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.equipment,
          builder: (context, state) => const EquipmentScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const NewEquipmentScreen(),
            ),
            GoRoute(
              path: 'categories',
              builder: (context, state) => const EquipmentCategoriesScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => EquipmentDetailScreen(
                equipmentId: state.pathParameters['id']!,
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => NewEquipmentScreen(
                    equipmentId: state.pathParameters['id'],
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.team,
          builder: (context, state) => const TeamScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const NewTeamMemberScreen(),
            ),
            GoRoute(
              path: 'roles',
              builder: (context, state) => const TeamRolesScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => TeamMemberDetailScreen(
                memberId: state.pathParameters['id']!,
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => NewTeamMemberScreen(
                    memberId: state.pathParameters['id'],
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.vehicles,
          builder: (context, state) => const VehiclesScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const NewVehicleScreen(),
            ),
            GoRoute(
              path: 'types',
              builder: (context, state) => const VehicleTypesScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => VehicleDetailScreen(
                vehicleId: state.pathParameters['id']!,
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => NewVehicleScreen(
                    vehicleId: state.pathParameters['id'],
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.contracts,
          builder: (context, state) => const ContractsScreen(),
          routes: [
            GoRoute(
              path: 'templates',
              builder: (context, state) => const ContractTemplatesScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => ContractDetailScreen(
                contractId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.invoices,
          builder: (context, state) => const InvoicesScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) {
                final quoteId = state.uri.queryParameters['quoteId'];
                return NewInvoiceScreen(initialQuoteId: quoteId);
              },
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => InvoiceDetailScreen(
                invoiceId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        ],
      ),
    ],
  );
}
