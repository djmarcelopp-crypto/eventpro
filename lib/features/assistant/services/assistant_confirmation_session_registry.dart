import '../models/assistant_confirmation_session.dart';

/// In-memory registry of confirmation sessions — injectable, not a singleton.
class AssistantConfirmationSessionRegistry {
  AssistantConfirmationSessionRegistry({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final Map<String, AssistantConfirmationSession> _sessions = {};

  AssistantConfirmationSession getOrCreate(String sessionId) {
    final key = sessionId.trim();
    if (key.isEmpty) {
      throw ArgumentError('sessionId é obrigatório');
    }
    return _sessions.putIfAbsent(
      key,
      () => AssistantConfirmationSession(sessionId: key, clock: _clock),
    );
  }

  AssistantConfirmationSession? find(String sessionId) =>
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
