import '../models/assistant_read_filter.dart';
import '../models/assistant_read_pagination.dart';
import '../models/assistant_read_query.dart';
import '../models/assistant_read_sort.dart';
import '../models/assistant_request.dart';
import '../models/assistant_response.dart';
import 'assistant_capabilities.dart';

/// Builds an optional structured read query from the local pipeline.
///
/// Returns null when planning/execution capabilities are off or the text
/// does not signal a quote read. Never mutates the ERP.
class LocalAssistantReadQueryFactory {
  const LocalAssistantReadQueryFactory();

  AssistantReadQuery? fromPipeline({
    required AssistantRequest request,
    required AssistantResponse response,
    required AssistantCapabilities capabilities,
  }) {
    if (!capabilities.canPlanStructuredQuoteRead &&
        !capabilities.canExecuteStructuredQuoteRead) {
      return null;
    }

    final folded = _fold(request.rawText);
    if (!_looksLikeQuoteRead(folded)) {
      return null;
    }

    final filters = <AssistantReadFilter>[];
    final number = _extractQuoteNumber(request.rawText);
    if (number != null) {
      filters.add(
        AssistantReadFilter(field: 'number', operator: 'eq', value: number),
      );
    }
    final id = _extractId(folded);
    if (id != null) {
      filters.add(AssistantReadFilter(field: 'id', operator: 'eq', value: id));
    }
    final status = _extractStatus(folded);
    if (status != null) {
      filters.add(
        AssistantReadFilter(field: 'status', operator: 'eq', value: status),
      );
    }

    return AssistantReadQuery(
      id: 'rquery-${request.id}',
      requestId: request.id,
      module: AssistantReadModules.quote,
      filters: filters,
      sorting: const [
        AssistantReadSort(field: 'createdAt', ascending: false),
      ],
      pagination: const AssistantReadPagination(
        offset: 0,
        limit: AssistantReadPagination.defaultLimit,
      ),
      requiredCapabilities: const {
        AssistantReadCapabilities.structuredQuoteRead,
      },
    );
  }

  static bool _looksLikeQuoteRead(String folded) {
    final mentionsQuote =
        folded.contains('orcamento') || folded.contains('quote');
    if (!mentionsQuote) return false;
    const readVerbs = [
      'consultar',
      'listar',
      'buscar',
      'ultimos',
      'ultimo',
      'mostrar',
      'encontrar',
      'ver orcamento',
    ];
    if (readVerbs.any(folded.contains)) return true;
    if (RegExp(r'orc-\d{4}-\d{4}').hasMatch(folded)) return true;
    if (folded.contains('status') && mentionsQuote) return true;
    return false;
  }

  static String? _extractQuoteNumber(String raw) {
    final match = RegExp(
      r'ORC-\d{4}-\d{4}',
      caseSensitive: false,
    ).firstMatch(raw);
    return match?.group(0)?.toUpperCase();
  }

  static String? _extractId(String folded) {
    final match = RegExp(r'\bid[:=\s]+([a-z0-9\-_]{3,})\b').firstMatch(folded);
    return match?.group(1);
  }

  static String? _extractStatus(String folded) {
    const statuses = [
      'draft',
      'sent',
      'approved',
      'rejected',
      'cancelled',
      'rascunho',
      'enviado',
      'aprovado',
      'recusado',
      'cancelado',
    ];
    for (final status in statuses) {
      if (!folded.contains(status)) continue;
      return switch (status) {
        'rascunho' => 'draft',
        'enviado' => 'sent',
        'aprovado' => 'approved',
        'recusado' => 'rejected',
        'cancelado' => 'cancelled',
        _ => status,
      };
    }
    return null;
  }

  static String _fold(String input) {
    return input
        .toLowerCase()
        .replaceAll('ç', 'c')
        .replaceAll('ã', 'a')
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u');
  }
}
