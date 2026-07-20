import '../domain/confirmation/assistant_confirmation_planner.dart';
import '../models/assistant_confirmation_metadata.dart';
import '../models/assistant_confirmation_operation_kind.dart';
import '../models/assistant_confirmation_outcome.dart';
import '../models/assistant_confirmation_request.dart';
import '../models/assistant_confirmation_result.dart';
import '../models/assistant_confirmation_session.dart';
import '../models/assistant_confirmation_token.dart';
import '../models/assistant_confirmation_warning.dart';
import '../models/assistant_safe_confirmation_intent.dart';
import '../models/pending_confirmation.dart';

/// Safe confirmation planner — preview / validate only, never executes ERP writes.
class LocalAssistantConfirmationPlanner implements AssistantConfirmationPlanner {
  LocalAssistantConfirmationPlanner({
    DateTime Function()? clock,
    Duration ttl = AssistantConfirmationDefaults.ttl,
    String Function()? tokenFactory,
  })  : _clock = clock ?? DateTime.now,
        _ttl = ttl,
        _tokenFactory = tokenFactory;

  final DateTime Function() _clock;
  final Duration _ttl;
  final String Function()? _tokenFactory;
  int _tokenSeq = 0;

  @override
  AssistantConfirmationRequest planRequest(
    AssistantSafeConfirmationIntent intent, {
    required String requestId,
    String? sessionId,
  }) {
    final id = 'conf-$requestId';
    return switch (intent) {
      CreateConfirmationIntent(:final operationKind) =>
        AssistantConfirmationRequest(
          id: id,
          requestId: requestId,
          intentKind: AssistantConfirmationIntentKinds.create,
          sessionId: sessionId,
          operationKind: operationKind,
          ttl: _ttl,
        ),
      ConfirmPendingIntent(:final token) => AssistantConfirmationRequest(
          id: id,
          requestId: requestId,
          intentKind: AssistantConfirmationIntentKinds.confirm,
          sessionId: sessionId,
          token: token,
        ),
      CancelPendingIntent(:final token) => AssistantConfirmationRequest(
          id: id,
          requestId: requestId,
          intentKind: AssistantConfirmationIntentKinds.cancel,
          sessionId: sessionId,
          token: token,
        ),
      StatusPendingIntent() => AssistantConfirmationRequest(
          id: id,
          requestId: requestId,
          intentKind: AssistantConfirmationIntentKinds.status,
          sessionId: sessionId,
        ),
    };
  }

  @override
  AssistantConfirmationResult process({
    required AssistantConfirmationRequest request,
    required AssistantConfirmationSession? session,
  }) {
    final now = _clock().toUtc();
    if (session == null) {
      return _result(
        request: request,
        outcome: AssistantConfirmationOutcome.invalid,
        valid: false,
        summary: 'É necessário um sessionId para usar o motor de confirmação.',
        warnings: const [
          AssistantConfirmationWarning(
            code: AssistantConfirmationWarning.missingSession,
            message: 'Sessão ausente — informe context.sessionId.',
          ),
        ],
        now: now,
      );
    }

    return switch (request.intentKind) {
      AssistantConfirmationIntentKinds.create =>
        _create(request: request, session: session, now: now),
      AssistantConfirmationIntentKinds.confirm =>
        _confirm(request: request, session: session, now: now),
      AssistantConfirmationIntentKinds.cancel =>
        _cancel(request: request, session: session, now: now),
      AssistantConfirmationIntentKinds.status =>
        _status(request: request, session: session, now: now),
      _ => _result(
          request: request,
          outcome: AssistantConfirmationOutcome.invalid,
          valid: false,
          summary: 'Intenção de confirmação desconhecida.',
          now: now,
          sessionId: session.sessionId,
        ),
    };
  }

  AssistantConfirmationResult _create({
    required AssistantConfirmationRequest request,
    required AssistantConfirmationSession session,
    required DateTime now,
  }) {
    final kind = request.operationKind ??
        AssistantConfirmationOperationKind.createQuoteDraft;
    final preview = _previewFor(kind);
    final token = AssistantConfirmationToken(
      _tokenFactory?.call() ?? 'tok-${session.sessionId}-${++_tokenSeq}',
    );
    final ttl = request.ttl ?? _ttl;
    final pending = PendingConfirmation(
      token: token,
      sessionId: session.sessionId,
      operationKind: kind,
      preview: preview,
      createdAt: now,
      expiresAt: now.add(ttl),
    );
    session.store(pending);
    return _result(
      request: request,
      outcome: AssistantConfirmationOutcome.previewCreated,
      summary: 'Confirmação criada. Revise o preview e confirme ou cancele.',
      preview: preview,
      pending: pending,
      now: now,
      sessionId: session.sessionId,
      token: token.value,
      expiresAt: pending.expiresAt,
    );
  }

  AssistantConfirmationResult _confirm({
    required AssistantConfirmationRequest request,
    required AssistantConfirmationSession session,
    required DateTime now,
  }) {
    final pending = session.pending;
    if (pending == null) {
      return _missing(request, session.sessionId, now);
    }
    if (request.token != null && pending.token != request.token) {
      return _tokenMismatch(request, session.sessionId, now);
    }
    if (pending.isExpiredAt(now)) {
      session.store(pending.copyWith(resolved: true));
      return _expired(request, session.sessionId, pending, now);
    }
    if (pending.resolved) {
      return _missing(request, session.sessionId, now);
    }

    session.markConfirmed();
    final confirmed = session.pending!;
    return _result(
      request: request,
      outcome: AssistantConfirmationOutcome.confirmed,
      summary:
          'Confirmação aceita. Nenhuma escrita foi executada nesta sprint.',
      preview: confirmed.preview,
      pending: confirmed,
      now: now,
      sessionId: session.sessionId,
      token: confirmed.token.value,
      expiresAt: confirmed.expiresAt,
    );
  }

  AssistantConfirmationResult _cancel({
    required AssistantConfirmationRequest request,
    required AssistantConfirmationSession session,
    required DateTime now,
  }) {
    final pending = session.pending;
    if (pending == null) {
      return _missing(request, session.sessionId, now);
    }
    if (request.token != null && pending.token != request.token) {
      return _tokenMismatch(request, session.sessionId, now);
    }
    if (pending.isExpiredAt(now)) {
      session.store(pending.copyWith(resolved: true));
      return _expired(request, session.sessionId, pending, now);
    }
    if (pending.resolved) {
      return _missing(request, session.sessionId, now);
    }

    session.markCancelled();
    final cancelled = session.pending!;
    return _result(
      request: request,
      outcome: AssistantConfirmationOutcome.cancelled,
      summary: 'Confirmação cancelada.',
      preview: cancelled.preview,
      pending: cancelled,
      now: now,
      sessionId: session.sessionId,
      token: cancelled.token.value,
      expiresAt: cancelled.expiresAt,
    );
  }

  AssistantConfirmationResult _status({
    required AssistantConfirmationRequest request,
    required AssistantConfirmationSession session,
    required DateTime now,
  }) {
    final pending = session.pending;
    if (pending == null) {
      return _missing(request, session.sessionId, now);
    }
    if (pending.isExpiredAt(now)) {
      session.store(pending.copyWith(resolved: true));
      return _expired(request, session.sessionId, pending, now);
    }
    if (pending.resolved) {
      return _missing(request, session.sessionId, now);
    }
    return _result(
      request: request,
      outcome: AssistantConfirmationOutcome.previewCreated,
      summary: 'Há uma confirmação pendente.',
      preview: pending.preview,
      pending: pending,
      now: now,
      sessionId: session.sessionId,
      token: pending.token.value,
      expiresAt: pending.expiresAt,
    );
  }

  AssistantConfirmationResult _missing(
    AssistantConfirmationRequest request,
    String sessionId,
    DateTime now,
  ) {
    return _result(
      request: request,
      outcome: AssistantConfirmationOutcome.missing,
      valid: false,
      summary: 'Não há confirmação pendente nesta sessão.',
      warnings: const [
        AssistantConfirmationWarning(
          code: AssistantConfirmationWarning.missingPending,
          message: 'Confirmação inexistente.',
        ),
      ],
      now: now,
      sessionId: sessionId,
    );
  }

  AssistantConfirmationResult _expired(
    AssistantConfirmationRequest request,
    String sessionId,
    PendingConfirmation pending,
    DateTime now,
  ) {
    return _result(
      request: request,
      outcome: AssistantConfirmationOutcome.expired,
      valid: false,
      summary: 'A confirmação expirou.',
      pending: pending.copyWith(resolved: true),
      warnings: const [
        AssistantConfirmationWarning(
          code: AssistantConfirmationWarning.expired,
          message: 'A confirmação pendente expirou.',
        ),
      ],
      now: now,
      sessionId: sessionId,
      token: pending.token.value,
      expiresAt: pending.expiresAt,
    );
  }

  AssistantConfirmationResult _tokenMismatch(
    AssistantConfirmationRequest request,
    String sessionId,
    DateTime now,
  ) {
    return _result(
      request: request,
      outcome: AssistantConfirmationOutcome.invalid,
      valid: false,
      summary: 'Token de confirmação não corresponde ao pendente.',
      warnings: const [
        AssistantConfirmationWarning(
          code: AssistantConfirmationWarning.tokenMismatch,
          message: 'Token de confirmação inválido.',
        ),
      ],
      now: now,
      sessionId: sessionId,
    );
  }

  static String _previewFor(AssistantConfirmationOperationKind kind) {
    return switch (kind) {
      AssistantConfirmationOperationKind.createQuoteDraft =>
        'Preview: criar orçamento em Draft. '
            'Nenhuma alteração será feita até uma escrita futura autorizada.',
      AssistantConfirmationOperationKind.genericSensitive =>
        'Preview: operação sensível. Nenhuma alteração será executada agora.',
    };
  }

  AssistantConfirmationResult _result({
    required AssistantConfirmationRequest request,
    required AssistantConfirmationOutcome outcome,
    required DateTime now,
    required String summary,
    bool valid = true,
    String? preview,
    PendingConfirmation? pending,
    List<AssistantConfirmationWarning> warnings = const [],
    String? sessionId,
    String? token,
    DateTime? expiresAt,
  }) {
    return AssistantConfirmationResult(
      requestId: request.requestId,
      outcome: outcome,
      valid: valid,
      summary: summary,
      preview: preview,
      pending: pending,
      warnings: warnings,
      metadata: AssistantConfirmationMetadata(
        timestamp: now,
        outcome: outcome.name,
        sessionId: sessionId ?? request.sessionId,
        token: token,
        expiresAt: expiresAt,
      ),
    );
  }
}
