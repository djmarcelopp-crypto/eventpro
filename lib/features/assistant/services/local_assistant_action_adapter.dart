import '../domain/action/assistant_action_adapter.dart';
import '../models/assistant_action_kind.dart';
import '../models/assistant_action_metadata.dart';
import '../models/assistant_action_request.dart';
import '../models/assistant_action_result.dart';
import '../models/assistant_action_warning.dart';
import '../models/assistant_nav_action.dart';

/// Local in-memory adapter: emits navigation directives without mutating ERP.
///
/// Does not call GoRouter / Flutter. UI consumes [AssistantActionResult]
/// structured payload to navigate. Repeated identical requests are idempotent.
class LocalAssistantActionAdapter implements AssistantActionAdapter {
  LocalAssistantActionAdapter({
    DateTime Function()? clock,
    Set<String>? knownEntityIds,
  })  : _clock = clock ?? DateTime.now,
        _knownEntityIds = knownEntityIds ?? {};

  final DateTime Function() _clock;
  final Set<String> _knownEntityIds;
  final Map<String, AssistantActionResult> _executed = {};

  /// Registers known entity ids for focus validation (tests / composition).
  void registerKnownEntity(String entityId) {
    final id = entityId.trim();
    if (id.isNotEmpty) _knownEntityIds.add(id);
  }

  void clearIdempotencyCache() => _executed.clear();

  @override
  String get name => 'LocalActionAdapter';

  @override
  bool supports(AssistantActionRequest request) =>
      request.kind != AssistantActionKind.unknown &&
      request.requiredCapabilities
          .contains(AssistantActionCapabilities.smartActions);

  @override
  Future<AssistantActionResult> execute(AssistantActionRequest request) async {
    final started = _clock();
    final key = request.idempotencyKey;

    final previous = _executed[key];
    if (previous != null && previous.valid && previous.executed) {
      final finished = _clock();
      return AssistantActionResult(
        requestId: request.requestId,
        actions: previous.actions,
        executed: true,
        valid: true,
        summary: previous.summary,
        warnings: [
          ...previous.warnings,
          const AssistantActionWarning(
            code: AssistantActionWarning.idempotentReplay,
            message: 'Ação já aplicada — resultado reutilizado (idempotente).',
          ),
        ],
        metadata: AssistantActionMetadata(
          timestamp: finished.toUtc(),
          kind: request.kind.name,
          executionTimeMs: _elapsed(started, finished),
          idempotentReplay: true,
          sessionId: request.sessionId,
        ),
      );
    }

    if (request.kind == AssistantActionKind.unknown) {
      return _failure(
        request: request,
        started: started,
        message: 'Ação desconhecida.',
        warning: const AssistantActionWarning(
          code: AssistantActionWarning.unknownAction,
          message: 'Ação desconhecida não pode ser executada.',
        ),
      );
    }

    final needsEntity = request.kind == AssistantActionKind.openClient ||
        request.kind == AssistantActionKind.openLastQuote;
    final entityId = request.target.entityId?.trim();
    if (needsEntity && (entityId == null || entityId.isEmpty)) {
      return _failure(
        request: request,
        started: started,
        message: 'Alvo inexistente: nenhum registro conhecido para esta ação.',
        warning: const AssistantActionWarning(
          code: AssistantActionWarning.missingTarget,
          message: 'Alvo inexistente — informe um cliente/orçamento conhecido.',
        ),
      );
    }

    if (needsEntity &&
        entityId != null &&
        _knownEntityIds.isNotEmpty &&
        !_knownEntityIds.contains(entityId)) {
      return _failure(
        request: request,
        started: started,
        message: 'Alvo inexistente: registro "$entityId" não encontrado.',
        warning: AssistantActionWarning(
          code: AssistantActionWarning.missingTarget,
          message: 'Alvo inexistente: registro "$entityId" não encontrado.',
        ),
      );
    }

    final finished = _clock();
    final summary = _summaryFor(request);
    final action = AssistantNavAction(
      id: request.id,
      kind: request.kind,
      target: request.target,
      title: request.target.label,
      description: summary,
    );
    final result = AssistantActionResult(
      requestId: request.requestId,
      actions: [action],
      executed: true,
      valid: true,
      summary: summary,
      warnings: const [],
      metadata: AssistantActionMetadata(
        timestamp: finished.toUtc(),
        kind: request.kind.name,
        executionTimeMs: _elapsed(started, finished),
        sessionId: request.sessionId,
      ),
    );
    _executed[key] = result;
    return result;
  }

  AssistantActionResult _failure({
    required AssistantActionRequest request,
    required DateTime started,
    required String message,
    required AssistantActionWarning warning,
  }) {
    final finished = _clock();
    return AssistantActionResult(
      requestId: request.requestId,
      actions: const [],
      executed: false,
      valid: false,
      failureMessage: message,
      summary: message,
      warnings: [warning],
      metadata: AssistantActionMetadata(
        timestamp: finished.toUtc(),
        kind: request.kind.name,
        executionTimeMs: _elapsed(started, finished),
        sessionId: request.sessionId,
      ),
    );
  }

  static String _summaryFor(AssistantActionRequest request) {
    return switch (request.kind) {
      AssistantActionKind.openQuotes => 'Abri a tela de Orçamentos.',
      AssistantActionKind.openDashboard => 'Abri o Dashboard.',
      AssistantActionKind.openSettings => 'Abri a tela de Configurações.',
      AssistantActionKind.openLastQuote => 'Abri o último orçamento.',
      AssistantActionKind.openClient => request.target.entityId == null
          ? 'Abri a tela de Clientes.'
          : 'Abri o cliente.',
      AssistantActionKind.unknown => 'Ação desconhecida.',
    };
  }

  static int _elapsed(DateTime start, DateTime end) {
    final ms = end.difference(start).inMilliseconds;
    return ms < 0 ? 0 : ms;
  }
}
