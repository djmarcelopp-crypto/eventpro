import 'assistant_confirmation_token.dart';
import 'pending_confirmation.dart';

/// Isolated in-memory confirmation session (no persistence, no globals).
class AssistantConfirmationSession {
  AssistantConfirmationSession({
    required this.sessionId,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final String sessionId;
  final DateTime Function() _clock;
  PendingConfirmation? _pending;

  PendingConfirmation? get pending => _pending;

  void reset() {
    _pending = null;
  }

  void store(PendingConfirmation pending) {
    _pending = pending;
  }

  /// Returns active pending, or marks/returns expired state without throwing.
  PendingConfirmation? activePending({DateTime? now}) {
    final current = _pending;
    if (current == null) return null;
    final at = (now ?? _clock()).toUtc();
    if (current.isExpiredAt(at)) {
      _pending = current.copyWith(resolved: true);
      return _pending;
    }
    return current;
  }

  PendingConfirmation? findByToken(AssistantConfirmationToken token) {
    final current = _pending;
    if (current == null) return null;
    if (current.token != token) return null;
    return current;
  }

  void markConfirmed() {
    final current = _pending;
    if (current == null) return;
    _pending = current.copyWith(
      resolved: true,
      confirmed: true,
      cancelled: false,
    );
  }

  void markCancelled() {
    final current = _pending;
    if (current == null) return;
    _pending = current.copyWith(
      resolved: true,
      cancelled: true,
      confirmed: false,
    );
  }

  /// Atomically consumes a confirmed pending for single-use execution.
  ///
  /// Returns `false` when the pending is missing, mismatched, cancelled,
  /// expired, not confirmed, or already consumed.
  bool tryConsume({
    AssistantConfirmationToken? token,
    DateTime? now,
  }) {
    final current = _pending;
    if (current == null) return false;
    if (token != null && current.token != token) return false;
    if (current.consumed) return false;
    if (current.cancelled) return false;
    if (!current.confirmed || !current.resolved) return false;
    final at = (now ?? _clock()).toUtc();
    if (current.isPastExpiresAt(at)) return false;
    _pending = current.copyWith(consumed: true);
    return true;
  }

  void clear() => reset();
}
