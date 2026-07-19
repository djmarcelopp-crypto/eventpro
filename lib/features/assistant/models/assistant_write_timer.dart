/// Injectable elapsed-time helper for deterministic write observability.
class AssistantWriteTimer {
  AssistantWriteTimer({
    DateTime Function()? clock,
    DateTime? startedAt,
  })  : _clock = clock ?? DateTime.now,
        _startedAt = startedAt ?? (clock ?? DateTime.now)();

  final DateTime Function() _clock;
  final DateTime _startedAt;

  DateTime get startedAt => _startedAt;

  /// Elapsed milliseconds since start; never negative.
  int elapsedMs({DateTime? finishedAt}) {
    final end = finishedAt ?? _clock();
    final ms = end.difference(_startedAt).inMilliseconds;
    return ms < 0 ? 0 : ms;
  }

  DateTime stop() => _clock();
}
