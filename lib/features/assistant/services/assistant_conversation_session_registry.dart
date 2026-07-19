import '../models/assistant_conversation_session.dart';

/// In-memory registry of conversation sessions — not a global singleton.
///
/// Inject one instance per composition root / test to isolate sessions.
class AssistantConversationSessionRegistry {
  AssistantConversationSessionRegistry({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final Map<String, AssistantConversationSession> _sessions = {};

  AssistantConversationSession getOrCreate(String sessionId) {
    final key = sessionId.trim();
    if (key.isEmpty) {
      throw ArgumentError('sessionId é obrigatório');
    }
    return _sessions.putIfAbsent(
      key,
      () => AssistantConversationSession(sessionId: key, clock: _clock),
    );
  }

  AssistantConversationSession? find(String sessionId) =>
      _sessions[sessionId.trim()];

  void reset(String sessionId) {
    _sessions[sessionId.trim()]?.reset();
  }

  void remove(String sessionId) {
    _sessions.remove(sessionId.trim());
  }

  int get sessionCount => _sessions.length;

  void clearAll() => _sessions.clear();
}
