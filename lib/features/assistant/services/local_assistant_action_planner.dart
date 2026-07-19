import '../domain/action/assistant_action_planner.dart';
import '../models/assistant_action_intent.dart';
import '../models/assistant_action_kind.dart';
import '../models/assistant_action_request.dart';
import '../models/assistant_action_target.dart';
import '../models/assistant_request.dart';

/// Builds [AssistantActionRequest] from intents — never navigates.
class LocalAssistantActionPlanner implements AssistantActionPlanner {
  const LocalAssistantActionPlanner();

  /// Canonical route paths (string catalog — no Flutter/GoRouter import).
  static const quotesPath = '/quotes';
  static const clientsPath = '/clients';
  static const dashboardPath = '/dashboard';
  static const settingsPath = '/settings';

  @override
  AssistantActionRequest plan(
    AssistantActionIntent intent, {
    required AssistantRequest request,
    String? actionId,
  }) {
    final id = actionId ?? 'action-${request.id}';
    final sessionId = request.context?.sessionId;

    return switch (intent) {
      OpenQuotesActionIntent() => AssistantActionRequest(
          id: id,
          requestId: request.id,
          kind: AssistantActionKind.openQuotes,
          sessionId: sessionId,
          target: const AssistantActionTarget(
            module: AssistantActionModules.quotes,
            routePath: quotesPath,
            screenId: 'quotes_list',
            label: 'Orçamentos',
          ),
          requiredCapabilities: const {
            AssistantActionCapabilities.smartActions,
          },
        ),
      OpenClientActionIntent(:final clientId, :final clientLabel) =>
        AssistantActionRequest(
          id: id,
          requestId: request.id,
          kind: AssistantActionKind.openClient,
          sessionId: sessionId,
          target: AssistantActionTarget(
            module: AssistantActionModules.clients,
            routePath: clientId == null || clientId.isEmpty
                ? clientsPath
                : '$clientsPath/$clientId',
            screenId: clientId == null || clientId.isEmpty
                ? 'clients_list'
                : 'client_detail',
            entityType: 'client',
            entityId: clientId,
            label: clientLabel ?? 'Cliente',
          ),
          requiredCapabilities: const {
            AssistantActionCapabilities.smartActions,
          },
        ),
      OpenLastQuoteActionIntent(:final quoteId, :final quoteLabel) =>
        AssistantActionRequest(
          id: id,
          requestId: request.id,
          kind: AssistantActionKind.openLastQuote,
          sessionId: sessionId,
          target: AssistantActionTarget(
            module: AssistantActionModules.quotes,
            routePath: quoteId == null || quoteId.isEmpty
                ? quotesPath
                : '$quotesPath/$quoteId',
            screenId: quoteId == null || quoteId.isEmpty
                ? 'quotes_list'
                : 'quote_detail',
            entityType: 'quote',
            entityId: quoteId,
            label: quoteLabel ?? 'Último orçamento',
          ),
          requiredCapabilities: const {
            AssistantActionCapabilities.smartActions,
          },
        ),
      OpenDashboardActionIntent() => AssistantActionRequest(
          id: id,
          requestId: request.id,
          kind: AssistantActionKind.openDashboard,
          sessionId: sessionId,
          target: const AssistantActionTarget(
            module: AssistantActionModules.dashboard,
            routePath: dashboardPath,
            screenId: 'dashboard',
            label: 'Dashboard',
          ),
          requiredCapabilities: const {
            AssistantActionCapabilities.smartActions,
          },
        ),
      OpenSettingsActionIntent() => AssistantActionRequest(
          id: id,
          requestId: request.id,
          kind: AssistantActionKind.openSettings,
          sessionId: sessionId,
          target: const AssistantActionTarget(
            module: AssistantActionModules.settings,
            routePath: settingsPath,
            screenId: 'settings',
            label: 'Configurações',
          ),
          requiredCapabilities: const {
            AssistantActionCapabilities.smartActions,
          },
        ),
    };
  }
}
