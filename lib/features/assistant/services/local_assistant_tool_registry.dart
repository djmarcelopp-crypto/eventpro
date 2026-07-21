import '../domain/tools/assistant_tool.dart';
import '../domain/tools/assistant_tool_port.dart';
import '../domain/tools/assistant_tool_request.dart';
import '../domain/tools/assistant_tool_types.dart';
import 'local_mock_tool_executor.dart';

/// In-process tool registry (AI-028). No real ERP side effects.
class LocalAssistantToolRegistry implements AssistantToolRegistry {
  LocalAssistantToolRegistry({
    List<AssistantTool>? seed,
    AssistantToolPort? defaultPort,
  }) : _defaultPort = defaultPort {
    for (final tool in seed ?? const <AssistantTool>[]) {
      register(tool);
    }
  }

  final Map<String, AssistantTool> _tools = {};
  final Map<String, AssistantToolPort> _ports = {};
  final AssistantToolPort? _defaultPort;

  factory LocalAssistantToolRegistry.withMockDefaults({
    DateTime Function()? clock,
    AssistantToolObserver? observer,
  }) {
    final port = LocalMockToolExecutor(clock: clock, observer: observer);
    return LocalAssistantToolRegistry(
      seed: LocalMockToolExecutor.catalog,
      defaultPort: port,
    ).._bindAllTo(port);
  }

  void _bindAllTo(AssistantToolPort port) {
    for (final id in _tools.keys) {
      _ports[id] = port;
    }
  }

  @override
  void register(AssistantTool tool, {AssistantToolPort? port}) {
    _tools[tool.id.value] = tool;
    if (port != null) {
      _ports[tool.id.value] = port;
    } else if (_defaultPort != null) {
      _ports[tool.id.value] = _defaultPort;
    }
  }

  @override
  void unregister(AssistantToolId toolId) {
    _tools.remove(toolId.value);
    _ports.remove(toolId.value);
  }

  @override
  AssistantTool? find(AssistantToolId toolId) => _tools[toolId.value];

  @override
  AssistantToolPort? findPort(AssistantToolId toolId) => _ports[toolId.value];

  @override
  List<AssistantTool> findByCapability(AssistantToolCapability capability) {
    return _tools.values
        .where((t) => t.capabilities.contains(capability))
        .toList(growable: false);
  }

  @override
  List<AssistantTool> list() =>
      List.unmodifiable(_tools.values.toList(growable: false));

  @override
  List<AssistantTool> defaultTools() => LocalMockToolExecutor.catalog;

  void clear() {
    _tools.clear();
    _ports.clear();
  }
}
