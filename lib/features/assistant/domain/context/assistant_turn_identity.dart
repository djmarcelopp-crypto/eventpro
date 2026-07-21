import '../../models/assistant_request.dart';

/// Single conversational identity for one orchestrator turn (AR-002).
///
/// Ownership:
/// - [sessionId] — from [AssistantRequest.context.sessionId] only (never invented).
/// - [conversationId] — equals [sessionId] when present; otherwise `req:{requestId}`
///   for AI-021 memory scoping without forcing an AI-010 session.
/// - [correlationId] — equals [AssistantRequest.id].
class AssistantTurnIdentity {
  const AssistantTurnIdentity({
    required this.requestId,
    required this.correlationId,
    required this.conversationId,
    this.sessionId,
  });

  final String requestId;
  final String correlationId;
  final String conversationId;
  final String? sessionId;

  bool get hasSession => sessionId != null && sessionId!.isNotEmpty;

  factory AssistantTurnIdentity.resolve(AssistantRequest request) {
    final raw = request.context?.sessionId?.trim();
    final sessionId = (raw != null && raw.isNotEmpty) ? raw : null;
    return AssistantTurnIdentity(
      requestId: request.id,
      correlationId: request.id,
      sessionId: sessionId,
      conversationId: sessionId ?? 'req:${request.id}',
    );
  }

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'correlationId': correlationId,
        'conversationId': conversationId,
        'sessionId': sessionId,
      };
}
