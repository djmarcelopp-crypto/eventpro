import '../domain/tools/assistant_tool.dart';
import '../domain/tools/assistant_tool_port.dart';
import '../domain/tools/assistant_tool_request.dart';
import '../domain/tools/assistant_tool_types.dart';

/// Deterministic mock tool executor (AI-028 CP-6).
///
/// No DB, HTTP, APIs, or state mutation — returns structured facts only.
class LocalMockToolExecutor implements AssistantToolPort {
  LocalMockToolExecutor({
    this.engineId = defaultEngineId,
    AssistantToolObserver? observer,
    DateTime Function()? clock,
  })  : _observer = observer ?? const NoopAssistantToolObserver(),
        _clock = clock ?? DateTime.now;

  static const defaultEngineId = 'local.mock.tools';

  final String engineId;
  final AssistantToolObserver _observer;
  final DateTime Function() _clock;

  static final catalog = <AssistantTool>[
    AssistantTool(
      id: const AssistantToolId('findCustomer'),
      category: AssistantToolCategory.lookup,
      capabilities: const {AssistantToolCapability.findCustomer},
      parameters: const [
        AssistantToolParameter(name: 'query', type: 'string', required: true),
      ],
      metadata: const AssistantToolMetadata(
        label: 'Find Customer',
        description: 'Mock customer lookup',
        priority: 10,
        tags: ['customer', 'cliente'],
      ),
      policy: const AssistantToolPolicy(
        permissions: {AssistantToolPermission.read},
        risk: AssistantToolRisk.low,
      ),
    ),
    AssistantTool(
      id: const AssistantToolId('findEvent'),
      category: AssistantToolCategory.lookup,
      capabilities: const {AssistantToolCapability.findEvent},
      parameters: const [
        AssistantToolParameter(name: 'query', type: 'string', required: true),
      ],
      metadata: const AssistantToolMetadata(
        label: 'Find Event',
        priority: 9,
        tags: ['event', 'evento'],
      ),
      policy: const AssistantToolPolicy(
        permissions: {AssistantToolPermission.read},
        risk: AssistantToolRisk.low,
      ),
    ),
    AssistantTool(
      id: const AssistantToolId('findQuote'),
      category: AssistantToolCategory.lookup,
      capabilities: const {AssistantToolCapability.findQuote},
      parameters: const [
        AssistantToolParameter(name: 'query', type: 'string', required: true),
      ],
      metadata: const AssistantToolMetadata(
        label: 'Find Quote',
        priority: 8,
        tags: ['quote', 'orcamento'],
      ),
      policy: const AssistantToolPolicy(
        permissions: {AssistantToolPermission.read},
        risk: AssistantToolRisk.low,
      ),
    ),
    AssistantTool(
      id: const AssistantToolId('findContract'),
      category: AssistantToolCategory.lookup,
      capabilities: const {AssistantToolCapability.findContract},
      parameters: const [
        AssistantToolParameter(name: 'query', type: 'string', required: true),
      ],
      metadata: const AssistantToolMetadata(
        label: 'Find Contract',
        priority: 7,
        tags: ['contract', 'contrato'],
      ),
      policy: const AssistantToolPolicy(
        permissions: {AssistantToolPermission.read},
        risk: AssistantToolRisk.low,
      ),
    ),
    AssistantTool(
      id: const AssistantToolId('findSupplier'),
      category: AssistantToolCategory.lookup,
      capabilities: const {AssistantToolCapability.findSupplier},
      parameters: const [
        AssistantToolParameter(name: 'query', type: 'string', required: true),
      ],
      metadata: const AssistantToolMetadata(
        label: 'Find Supplier',
        priority: 6,
        tags: ['supplier', 'fornecedor'],
      ),
      policy: const AssistantToolPolicy(
        permissions: {AssistantToolPermission.read},
        risk: AssistantToolRisk.low,
      ),
    ),
    AssistantTool(
      id: const AssistantToolId('createReminder'),
      category: AssistantToolCategory.reminder,
      capabilities: const {AssistantToolCapability.createReminder},
      parameters: const [
        AssistantToolParameter(name: 'text', type: 'string', required: true),
      ],
      metadata: const AssistantToolMetadata(
        label: 'Create Reminder',
        priority: 5,
        tags: ['reminder'],
      ),
      policy: const AssistantToolPolicy(
        permissions: {AssistantToolPermission.write},
        risk: AssistantToolRisk.medium,
        requiresConfirmation: true,
      ),
    ),
    AssistantTool(
      id: const AssistantToolId('openWorkflow'),
      category: AssistantToolCategory.workflow,
      capabilities: const {AssistantToolCapability.openWorkflow},
      parameters: const [
        AssistantToolParameter(
          name: 'workflowId',
          type: 'string',
          required: true,
        ),
      ],
      metadata: const AssistantToolMetadata(
        label: 'Open Workflow',
        priority: 4,
        tags: ['workflow'],
      ),
      policy: const AssistantToolPolicy(
        permissions: {AssistantToolPermission.write},
        risk: AssistantToolRisk.medium,
        requiresConfirmation: true,
      ),
    ),
  ];

  final _byId = {
    for (final t in catalog) t.id.value: t,
  };

  @override
  bool supports(AssistantToolCapability capability) {
    return catalog.any((t) => t.capabilities.contains(capability));
  }

  @override
  AssistantTool? describe(AssistantToolId toolId) => _byId[toolId.value];

  @override
  Future<AssistantToolHealth> health() async {
    return AssistantToolHealth(
      status: AssistantToolHealthStatus.healthy,
      checkedAt: _clock().toUtc(),
      message: 'local.mock.tools ready',
    );
  }

  @override
  Future<AssistantToolError?> validate(AssistantToolRequest request) async {
    final tool = _byId[request.toolId.value];
    if (tool == null) {
      return AssistantToolError(
        code: AssistantToolErrorCode.unknownTool,
        message: 'Unknown tool: ${request.toolId.value}',
      );
    }
    for (final p in tool.parameters.where((p) => p.required)) {
      final v = request.arguments[p.name];
      if (v == null || v.trim().isEmpty) {
        return AssistantToolError(
          code: AssistantToolErrorCode.invalidParameters,
          message: 'Missing required parameter: ${p.name}',
        );
      }
    }
    if (tool.policy.permissions.contains(AssistantToolPermission.dangerous)) {
      return const AssistantToolError(
        code: AssistantToolErrorCode.permissionDenied,
        message: 'Dangerous tools are not allowed in mock executor',
      );
    }
    return null;
  }

  @override
  Future<AssistantToolResponse> execute(AssistantToolRequest request) async {
    final started = _clock().toUtc();
    final validationError = await validate(request);
    if (validationError != null) {
      final result = AssistantToolResult(
        toolId: request.toolId,
        status: validationError.code == AssistantToolErrorCode.permissionDenied
            ? AssistantToolExecutionStatus.denied
            : AssistantToolExecutionStatus.failed,
        error: validationError,
        confidence: 0,
      );
      final response = AssistantToolResponse(
        request: request,
        result: result,
        metadata: AssistantToolExecutionMetadata(
          startedAt: started,
          finishedAt: _clock().toUtc(),
          latencyMs: 0,
          engineId: engineId,
        ),
      );
      _observe(request, result, started);
      return response;
    }

    final tool = _byId[request.toolId.value]!;
    final query = request.arguments['query'] ??
        request.arguments['text'] ??
        request.arguments['workflowId'] ??
        '';
    final result = _deterministicResult(tool, query);
    final finished = _clock().toUtc();
    final response = AssistantToolResponse(
      request: request,
      result: result,
      metadata: AssistantToolExecutionMetadata(
        startedAt: started,
        finishedAt: finished,
        latencyMs: finished.difference(started).inMilliseconds,
        engineId: engineId,
        permission: tool.policy.permissions.first,
      ),
    );
    _observe(request, result, started);
    return response;
  }

  AssistantToolResult _deterministicResult(AssistantTool tool, String query) {
    final id = tool.id.value;
    switch (id) {
      case 'findCustomer':
        return AssistantToolResult(
          toolId: tool.id,
          status: AssistantToolExecutionStatus.succeeded,
          message: 'mock:customer:$query',
          data: {
            'customerId': 'cust-mock-1',
            'name': query.isEmpty ? 'Cliente Mock' : query,
          },
          references: [
            AssistantToolReference(
              key: 'customer',
              value: 'cust-mock-1',
              kind: 'customer',
            ),
          ],
        );
      case 'findEvent':
        return AssistantToolResult(
          toolId: tool.id,
          status: AssistantToolExecutionStatus.succeeded,
          message: 'mock:event:$query',
          data: {'eventId': 'evt-mock-1', 'title': query},
          references: const [
            AssistantToolReference(
              key: 'event',
              value: 'evt-mock-1',
              kind: 'event',
            ),
          ],
        );
      case 'findQuote':
        return AssistantToolResult(
          toolId: tool.id,
          status: AssistantToolExecutionStatus.succeeded,
          message: 'mock:quote:$query',
          data: {'quoteId': 'q-mock-1'},
          references: const [
            AssistantToolReference(
              key: 'quote',
              value: 'q-mock-1',
              kind: 'quote',
            ),
          ],
        );
      case 'findContract':
        return AssistantToolResult(
          toolId: tool.id,
          status: AssistantToolExecutionStatus.succeeded,
          message: 'mock:contract:$query',
          data: {'contractId': 'c-mock-1'},
          references: const [
            AssistantToolReference(
              key: 'contract',
              value: 'c-mock-1',
              kind: 'contract',
            ),
          ],
        );
      case 'findSupplier':
        return AssistantToolResult(
          toolId: tool.id,
          status: AssistantToolExecutionStatus.succeeded,
          message: 'mock:supplier:$query',
          data: {'supplierId': 'sup-mock-1'},
          references: const [
            AssistantToolReference(
              key: 'supplier',
              value: 'sup-mock-1',
              kind: 'supplier',
            ),
          ],
        );
      case 'createReminder':
        return AssistantToolResult(
          toolId: tool.id,
          status: AssistantToolExecutionStatus.succeeded,
          message: 'mock:reminder:planned:$query',
          data: {'reminderId': 'rem-mock-1', 'planned': 'true'},
          confidence: 0.9,
        );
      case 'openWorkflow':
        return AssistantToolResult(
          toolId: tool.id,
          status: AssistantToolExecutionStatus.succeeded,
          message: 'mock:workflow:open:$query',
          data: {'workflowId': query.isEmpty ? 'wf-mock-1' : query},
          confidence: 0.9,
        );
      default:
        return AssistantToolResult(
          toolId: tool.id,
          status: AssistantToolExecutionStatus.failed,
          error: AssistantToolError(
            code: AssistantToolErrorCode.unknownTool,
            message: 'No mock handler for $id',
          ),
          confidence: 0,
        );
    }
  }

  void _observe(
    AssistantToolRequest request,
    AssistantToolResult result,
    DateTime started,
  ) {
    final finished = _clock().toUtc();
    _observer.record(
      AssistantToolExecution(
        toolId: request.toolId,
        status: result.status,
        timestamp: finished,
        correlationId: request.context.correlationId,
        latencyMs: finished.difference(started).inMilliseconds,
        errorCode: result.error?.code.name,
        permission: describe(request.toolId)?.policy.permissions.first,
        confidence: result.confidence,
      ),
    );
  }
}
