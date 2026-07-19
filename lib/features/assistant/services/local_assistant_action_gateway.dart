import '../domain/action/assistant_action_adapter.dart';
import '../domain/action/assistant_action_gateway.dart';
import '../models/assistant_action_metadata.dart';
import '../models/assistant_action_request.dart';
import '../models/assistant_action_result.dart';
import '../models/assistant_action_warning.dart';
import 'local_assistant_action_adapter.dart';

/// Local composition root for smart actions.
class LocalAssistantActionGateway implements AssistantActionGateway {
  LocalAssistantActionGateway({
    AssistantActionAdapter? adapter,
    DateTime Function()? clock,
  })  : _adapter = adapter ?? LocalAssistantActionAdapter(clock: clock),
        _clock = clock ?? DateTime.now;

  final AssistantActionAdapter _adapter;
  final DateTime Function() _clock;

  @override
  bool get isAvailable => true;

  @override
  AssistantActionAdapter get adapter => _adapter;

  @override
  Future<AssistantActionResult> execute(AssistantActionRequest request) async {
    final started = _clock();
    if (!_adapter.supports(request)) {
      final finished = _clock();
      return AssistantActionResult(
        requestId: request.requestId,
        actions: const [],
        executed: false,
        valid: false,
        failureMessage: 'Adapter ${_adapter.name} não suporta a ação.',
        warnings: const [
          AssistantActionWarning(
            code: AssistantActionWarning.unknownAction,
            message: 'Ação não suportada pelo adapter local.',
          ),
        ],
        metadata: AssistantActionMetadata(
          timestamp: finished.toUtc(),
          kind: request.kind.name,
          executionTimeMs: _elapsed(started, finished),
          sessionId: request.sessionId,
        ),
      );
    }
    return _adapter.execute(request);
  }

  static int _elapsed(DateTime start, DateTime end) {
    final ms = end.difference(start).inMilliseconds;
    return ms < 0 ? 0 : ms;
  }
}
