import '../domain/read/assistant_read_formatter.dart';
import '../models/assistant_read_intent.dart';
import '../models/assistant_read_presentation.dart';
import '../models/assistant_read_result.dart';

/// Deterministic NL + structured formatting for read results.
class LocalAssistantReadFormatter implements AssistantReadFormatter {
  const LocalAssistantReadFormatter();

  @override
  AssistantReadPresentation format({
    required AssistantReadResult result,
    AssistantReadIntent? intent,
  }) {
    final warnings = result.metadata.warnings;
    final scanLimited = warnings.any((w) => w.contains('Varredura limitada'));
    final page = result.metadata.pagination;
    final total = result.metadata.totalMatched;
    final count = result.records.length;

    final nl = _naturalLanguage(
      result: result,
      intent: intent,
      count: count,
      total: total,
      scanLimited: scanLimited,
      pageLimit: page.limit,
    );

    final structured = <String, Object?>{
      'kind': intent?.kind ?? 'read',
      'module': result.module,
      'valid': result.valid,
      'count': count,
      'totalMatched': total,
      'isEmpty': result.isEmpty,
      'isSingle': result.isSingle,
      'isMultiple': result.isMultiple,
      'pagination': page.toDeterministicMap(),
      'scanLimited': scanLimited,
      'warnings': [...warnings]..sort(),
      'recordIds': result.records.map((r) => r.id).toList(growable: false),
      'displayNames':
          result.records.map((r) => r.displayName).toList(growable: false),
      if (result.failureMessage != null) 'failureMessage': result.failureMessage,
    };

    return AssistantReadPresentation(
      naturalLanguage: nl,
      structured: structured,
    );
  }

  static String _naturalLanguage({
    required AssistantReadResult result,
    required AssistantReadIntent? intent,
    required int count,
    required int total,
    required bool scanLimited,
    required int pageLimit,
  }) {
    if (!result.valid) {
      return result.failureMessage ??
          'Não foi possível concluir a consulta de orçamentos.';
    }

    if (result.isEmpty) {
      return 'Não encontrei resultados.';
    }

    final suffix = <String>[];
    if (total > count) {
      suffix.add('Exibindo $count de $total.');
    } else if (count == pageLimit && intent is! ReadQuoteByIdIntent) {
      suffix.add('Limite de $pageLimit atingido nesta página.');
    }
    if (scanLimited) {
      suffix.add('A varredura foi limitada por segurança.');
    }

    String body;
    if (intent is ReadQuoteSummaryIntent) {
      body = total == 1
          ? 'Encontrei 1 orçamento.'
          : 'Encontrei $total orçamentos.';
    } else if (result.isSingle) {
      final record = result.records.single;
      final status = record.attributes['status'];
      final number = record.displayName.isNotEmpty
          ? record.displayName
          : record.attributes['number'] ?? record.id;
      if (status != null && status.isNotEmpty) {
        body = 'O orçamento $number está ${_statusLabel(status)}.';
      } else {
        body = 'Encontrei o orçamento $number.';
      }
    } else {
      body = count == 1
          ? 'Encontrei 1 orçamento.'
          : 'Encontrei $count orçamentos.';
      if (intent is ReadRecentQuotesIntent || intent is ReadQuotesIntent) {
        final names = result.records
            .map((r) => r.displayName.isEmpty ? r.id : r.displayName)
            .take(5)
            .join(', ');
        if (names.isNotEmpty) {
          body = '$body Principais: $names.';
        }
      }
    }

    if (suffix.isEmpty) return body;
    return '$body ${suffix.join(' ')}';
  }

  static String _statusLabel(String status) {
    return switch (status) {
      'draft' => 'em rascunho (aberto)',
      'sent' => 'enviado (aberto)',
      'approved' => 'aprovado',
      'rejected' => 'recusado',
      'cancelled' => 'cancelado',
      _ => status,
    };
  }
}
