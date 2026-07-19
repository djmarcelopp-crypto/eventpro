import '../domain/read/assistant_read_gateway.dart';
import '../domain/read/assistant_read_validator.dart';
import '../models/assistant_module_data_source.dart';
import '../models/assistant_read_metadata.dart';
import '../models/assistant_read_query.dart';
import '../models/assistant_read_result.dart';
import 'assistant_capabilities.dart';
import 'local_assistant_read_validator.dart';

/// Validates and dispatches structured reads — never mutates the ERP.
class LocalAssistantReadCoordinator {
  LocalAssistantReadCoordinator({
    AssistantReadValidator? validator,
    DateTime Function()? clock,
  })  : _validator = validator ?? const LocalAssistantReadValidator(),
        _clock = clock ?? DateTime.now;

  final AssistantReadValidator _validator;
  final DateTime Function() _clock;

  Future<AssistantReadResult> execute({
    required AssistantReadQuery query,
    required AssistantCapabilities capabilities,
    AssistantReadGateway? gateway,
  }) async {
    final started = _clock();
    final validation = _validator.validate(query);

    if (!validation.valid) {
      final finished = _clock();
      return AssistantReadResult(
        queryId: query.id,
        module: query.module,
        records: const [],
        valid: false,
        failureMessage: validation.errors.first,
        metadata: AssistantReadMetadata(
          timestamp: finished.toUtc(),
          source: AssistantModuleDataSource.test,
          appliedFilters: query.filters,
          pagination: query.pagination.clampToMax(),
          executionTimeMs: _elapsed(started, finished),
          warnings: [...validation.warnings, ...validation.errors],
        ),
      );
    }

    if (!_capabilityAllows(query, capabilities)) {
      final finished = _clock();
      return AssistantReadResult(
        queryId: query.id,
        module: query.module,
        records: const [],
        valid: false,
        failureMessage: 'Capability de leitura estruturada não habilitada',
        metadata: AssistantReadMetadata(
          timestamp: finished.toUtc(),
          source: AssistantModuleDataSource.test,
          appliedFilters: query.filters,
          pagination: query.pagination.clampToMax(),
          executionTimeMs: _elapsed(started, finished),
          warnings: const ['structuredQuoteRead desabilitado'],
        ),
      );
    }

    if (gateway == null || !gateway.isAvailable) {
      final finished = _clock();
      return AssistantReadResult(
        queryId: query.id,
        module: query.module,
        records: const [],
        valid: false,
        failureMessage: 'Read gateway indisponível',
        metadata: AssistantReadMetadata(
          timestamp: finished.toUtc(),
          source: AssistantModuleDataSource.test,
          appliedFilters: query.filters,
          pagination: query.pagination.clampToMax(),
          executionTimeMs: _elapsed(started, finished),
          warnings: [...validation.warnings, 'Read gateway ausente'],
        ),
      );
    }

    final result = await gateway.execute(query);
    if (validation.warnings.isEmpty) return result;

    return AssistantReadResult(
      queryId: result.queryId,
      module: result.module,
      records: result.records,
      valid: result.valid,
      failureMessage: result.failureMessage,
      metadata: AssistantReadMetadata(
        timestamp: result.metadata.timestamp,
        source: result.metadata.source,
        appliedFilters: result.metadata.appliedFilters,
        pagination: result.metadata.pagination,
        executionTimeMs: result.metadata.executionTimeMs,
        totalMatched: result.metadata.totalMatched,
        warnings: [...validation.warnings, ...result.metadata.warnings],
      ),
    );
  }

  static bool _capabilityAllows(
    AssistantReadQuery query,
    AssistantCapabilities capabilities,
  ) {
    if (query.module == AssistantReadModules.quote) {
      return capabilities.canExecuteStructuredQuoteRead;
    }
    return false;
  }

  static int _elapsed(DateTime start, DateTime end) {
    final ms = end.difference(start).inMilliseconds;
    return ms < 0 ? 0 : ms;
  }
}
