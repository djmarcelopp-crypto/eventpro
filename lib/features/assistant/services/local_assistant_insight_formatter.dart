import '../domain/insight/assistant_insight_formatter.dart';
import '../models/assistant_insight_kind.dart';
import '../models/assistant_insight_presentation.dart';
import '../models/assistant_insight_result.dart';
import '../models/assistant_insight_warning.dart';

/// Deterministic NL + structured formatter for insight results.
class LocalAssistantInsightFormatter implements AssistantInsightFormatter {
  const LocalAssistantInsightFormatter();

  @override
  AssistantInsightPresentation format(AssistantInsightResult result) {
    final naturalLanguage = _buildNaturalLanguage(result);
    return AssistantInsightPresentation.fromResult(
      result,
      naturalLanguage: naturalLanguage,
    );
  }

  String _buildNaturalLanguage(AssistantInsightResult result) {
    if (!result.valid) {
      return result.failureMessage ??
          'Não foi possível calcular o insight solicitado.';
    }

    final parts = <String>[];
    if (result.summary != null && result.summary!.text.isNotEmpty) {
      parts.add(result.summary!.text);
    } else if (result.insights.isNotEmpty) {
      for (final insight in result.insights) {
        final desc = insight.description ?? insight.title;
        if (desc.isNotEmpty) parts.add(desc);
      }
    } else {
      parts.add(_fallbackFromMetrics(result));
    }

    for (final warning in result.warnings) {
      if (warning.code == AssistantInsightWarning.maxScanCode ||
          result.metadata.scanCapped) {
        parts.add(warning.message);
      } else {
        parts.add(warning.message);
      }
    }

    if (result.metadata.scanCapped &&
        !result.warnings.any((w) => w.code == AssistantInsightWarning.maxScanCode)) {
      parts.add(
        'Os dados foram calculados sobre os primeiros '
        '${result.metadata.maxScan} registros.',
      );
    }

    return parts.where((p) => p.trim().isNotEmpty).join('\n\n');
  }

  String _fallbackFromMetrics(AssistantInsightResult result) {
    if (result.metrics.isEmpty) {
      return 'Nenhum insight disponível para os dados atuais.';
    }
    final kind = result.metadata.kind;
    if (kind == AssistantInsightKind.count.name ||
        kind == AssistantInsightKind.createdThisMonth.name) {
      final value = result.metrics.first.value;
      return 'Existem $value orçamentos.';
    }
    return result.metrics
        .map((m) => '${m.label ?? m.name}: ${m.value}')
        .join(' ');
  }
}
