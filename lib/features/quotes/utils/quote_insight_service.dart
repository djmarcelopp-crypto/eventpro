import '../../assistant/models/assistant_insight.dart';
import '../../assistant/models/assistant_insight_dimension.dart';
import '../../assistant/models/assistant_insight_kind.dart';
import '../../assistant/models/assistant_insight_metric.dart';
import '../../assistant/models/assistant_insight_request.dart';
import '../../assistant/models/assistant_insight_summary.dart';
import '../../assistant/models/assistant_insight_warning.dart';
import '../../assistant/models/assistant_read_status_lexicon.dart';
import '../data/repositories/quote_repository.dart';
import '../models/quote.dart';
import '../models/quote_status.dart';

/// Deterministic aggregations over quotes (read-only, maxScan capped).
class QuoteInsightService {
  QuoteInsightService(
    this._repository, {
    this.maxScan = defaultMaxScan,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const int defaultMaxScan = 500;

  final QuoteRepository _repository;
  final int maxScan;
  final DateTime Function() _clock;

  Future<QuoteInsightComputation> compute(AssistantInsightRequest request) async {
    final all = await _repository.listAll();
    final scanCapped = all.length > maxScan;
    final scanned =
        scanCapped ? all.take(maxScan).toList(growable: false) : all;
    final warnings = <AssistantInsightWarning>[
      if (scanCapped)
        AssistantInsightWarning(
          code: AssistantInsightWarning.maxScanCode,
          message:
              'Os dados foram calculados sobre os primeiros $maxScan registros.',
        ),
    ];

    return switch (request.kind) {
      AssistantInsightKind.count => _count(request, scanned, warnings, scanCapped),
      AssistantInsightKind.distribution =>
        _distribution(request, scanned, warnings, scanCapped),
      AssistantInsightKind.topEntity =>
        _topEntity(request, scanned, warnings, scanCapped),
      AssistantInsightKind.lastCreated =>
        _lastCreated(request, scanned, warnings, scanCapped),
      AssistantInsightKind.createdThisMonth =>
        _createdThisMonth(request, scanned, warnings, scanCapped),
    };
  }

  QuoteInsightComputation _count(
    AssistantInsightRequest request,
    List<Quote> scanned,
    List<AssistantInsightWarning> warnings,
    bool scanCapped,
  ) {
    final filtered = _filterByStatusToken(scanned, request.statusToken);
    final count = filtered.length;
    final label = request.statusToken == null
        ? 'Existem $count orçamentos.'
        : _countLabel(request.statusToken!, count);

    return QuoteInsightComputation(
      scannedCount: scanned.length,
      maxScan: maxScan,
      scanCapped: scanCapped,
      warnings: warnings,
      summary: AssistantInsightSummary(text: label),
      metrics: [
        AssistantInsightMetric(
          name: 'count',
          value: count,
          unit: 'quotes',
          label: request.statusToken ?? 'total',
        ),
      ],
      insights: [
        AssistantInsight(
          id: '${request.id}-count',
          kind: AssistantInsightKind.count,
          title: 'Contagem de orçamentos',
          description: label,
          metrics: [
            AssistantInsightMetric(name: 'count', value: count, unit: 'quotes'),
          ],
          attributes: {
            if (request.statusToken != null) 'statusToken': request.statusToken,
          },
        ),
      ],
    );
  }

  QuoteInsightComputation _distribution(
    AssistantInsightRequest request,
    List<Quote> scanned,
    List<AssistantInsightWarning> warnings,
    bool scanCapped,
  ) {
    final counts = <QuoteStatus, int>{};
    for (final status in QuoteStatus.values) {
      counts[status] = 0;
    }
    for (final quote in scanned) {
      counts[quote.status] = (counts[quote.status] ?? 0) + 1;
    }

    final dimensions = QuoteStatus.values
        .map(
          (status) => AssistantInsightDimension(
            key: 'status',
            value: status.name,
            label: status.label,
            count: counts[status] ?? 0,
          ),
        )
        .toList(growable: false);

    final nonZero = dimensions.where((d) => d.count > 0).toList();
    final breakdown = nonZero.isEmpty
        ? 'Não há orçamentos para distribuir por status.'
        : 'Concentração por status: ${nonZero.map((d) => '${d.label}: ${d.count}').join('; ')}.';

    return QuoteInsightComputation(
      scannedCount: scanned.length,
      maxScan: maxScan,
      scanCapped: scanCapped,
      warnings: warnings,
      summary: AssistantInsightSummary(
        text: breakdown,
        highlights: nonZero.map((d) => '${d.value}:${d.count}').toList(),
      ),
      metrics: [
        AssistantInsightMetric(
          name: 'total',
          value: scanned.length,
          unit: 'quotes',
          label: 'total',
        ),
        ...nonZero.map(
          (d) => AssistantInsightMetric(
            name: 'status_${d.value}',
            value: d.count,
            unit: 'quotes',
            label: d.label,
          ),
        ),
      ],
      dimensions: dimensions,
      insights: [
        AssistantInsight(
          id: '${request.id}-distribution',
          kind: AssistantInsightKind.distribution,
          title: 'Distribuição por status',
          description: breakdown,
          metrics: [
            AssistantInsightMetric(
              name: 'total',
              value: scanned.length,
              unit: 'quotes',
            ),
          ],
          dimensions: dimensions,
        ),
      ],
    );
  }

  QuoteInsightComputation _topEntity(
    AssistantInsightRequest request,
    List<Quote> scanned,
    List<AssistantInsightWarning> warnings,
    bool scanCapped,
  ) {
    if (scanned.isEmpty) {
      return QuoteInsightComputation(
        scannedCount: 0,
        maxScan: maxScan,
        scanCapped: scanCapped,
        warnings: warnings,
        summary: const AssistantInsightSummary(
          text: 'Não há orçamentos para identificar o cliente com mais registros.',
        ),
        metrics: const [
          AssistantInsightMetric(name: 'topCount', value: 0, unit: 'quotes'),
        ],
        insights: [
          AssistantInsight(
            id: '${request.id}-top',
            kind: AssistantInsightKind.topEntity,
            title: 'Cliente com mais orçamentos',
            description:
                'Não há orçamentos para identificar o cliente com mais registros.',
          ),
        ],
      );
    }

    final counts = <String, int>{};
    for (final quote in scanned) {
      final name = quote.clientSnapshot.displayName.trim();
      if (name.isEmpty) continue;
      counts[name] = (counts[name] ?? 0) + 1;
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        if (byCount != 0) return byCount;
        return a.key.compareTo(b.key);
      });

    final top = sorted.first;
    final text = 'O cliente ${top.key} possui ${top.value} orçamentos.';

    return QuoteInsightComputation(
      scannedCount: scanned.length,
      maxScan: maxScan,
      scanCapped: scanCapped,
      warnings: warnings,
      summary: AssistantInsightSummary(text: text, highlights: [top.key]),
      metrics: [
        AssistantInsightMetric(
          name: 'topCount',
          value: top.value,
          unit: 'quotes',
          label: top.key,
        ),
      ],
      dimensions: sorted
          .take(5)
          .map(
            (e) => AssistantInsightDimension(
              key: 'client',
              value: e.key,
              label: e.key,
              count: e.value,
            ),
          )
          .toList(growable: false),
      insights: [
        AssistantInsight(
          id: '${request.id}-top',
          kind: AssistantInsightKind.topEntity,
          title: 'Cliente com mais orçamentos',
          description: text,
          metrics: [
            AssistantInsightMetric(
              name: 'topCount',
              value: top.value,
              unit: 'quotes',
              label: top.key,
            ),
          ],
          attributes: {
            'entityField': request.entityField ?? 'clientDisplayName',
            'entityValue': top.key,
          },
        ),
      ],
    );
  }

  QuoteInsightComputation _lastCreated(
    AssistantInsightRequest request,
    List<Quote> scanned,
    List<AssistantInsightWarning> warnings,
    bool scanCapped,
  ) {
    if (scanned.isEmpty) {
      return QuoteInsightComputation(
        scannedCount: 0,
        maxScan: maxScan,
        scanCapped: scanCapped,
        warnings: warnings,
        summary: const AssistantInsightSummary(
          text: 'Não há orçamentos cadastrados.',
        ),
        metrics: const [
          AssistantInsightMetric(name: 'count', value: 0, unit: 'quotes'),
        ],
        insights: [
          AssistantInsight(
            id: '${request.id}-last',
            kind: AssistantInsightKind.lastCreated,
            title: 'Último orçamento',
            description: 'Não há orçamentos cadastrados.',
          ),
        ],
      );
    }

    final sorted = [...scanned]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final last = sorted.first;
    final text =
        'O último orçamento é ${last.number} (cliente ${last.clientSnapshot.displayName}).';

    return QuoteInsightComputation(
      scannedCount: scanned.length,
      maxScan: maxScan,
      scanCapped: scanCapped,
      warnings: warnings,
      summary: AssistantInsightSummary(
        text: text,
        highlights: [last.number],
      ),
      metrics: const [
        AssistantInsightMetric(name: 'count', value: 1, unit: 'quotes'),
      ],
      insights: [
        AssistantInsight(
          id: '${request.id}-last',
          kind: AssistantInsightKind.lastCreated,
          title: 'Último orçamento',
          description: text,
          attributes: {
            'quoteId': last.id,
            'number': last.number,
            'clientDisplayName': last.clientSnapshot.displayName,
            'status': last.status.name,
            'createdAt': last.createdAt.toUtc().toIso8601String(),
          },
        ),
      ],
    );
  }

  QuoteInsightComputation _createdThisMonth(
    AssistantInsightRequest request,
    List<Quote> scanned,
    List<AssistantInsightWarning> warnings,
    bool scanCapped,
  ) {
    final anchor = (request.referenceTimestamp ?? _clock()).toUtc();
    final matched = scanned.where((q) {
      final created = q.createdAt.toUtc();
      return created.year == anchor.year && created.month == anchor.month;
    }).toList(growable: false);
    final count = matched.length;
    final text = count == 1
        ? 'Foi criado 1 orçamento este mês.'
        : 'Foram criados $count orçamentos este mês.';

    return QuoteInsightComputation(
      scannedCount: scanned.length,
      maxScan: maxScan,
      scanCapped: scanCapped,
      warnings: warnings,
      summary: AssistantInsightSummary(text: text),
      metrics: [
        AssistantInsightMetric(
          name: 'createdThisMonth',
          value: count,
          unit: 'quotes',
          label: '${anchor.year}-${anchor.month.toString().padLeft(2, '0')}',
        ),
      ],
      insights: [
        AssistantInsight(
          id: '${request.id}-month',
          kind: AssistantInsightKind.createdThisMonth,
          title: 'Orçamentos criados este mês',
          description: text,
          metrics: [
            AssistantInsightMetric(
              name: 'createdThisMonth',
              value: count,
              unit: 'quotes',
            ),
          ],
          attributes: {
            'year': anchor.year,
            'month': anchor.month,
          },
        ),
      ],
    );
  }

  static List<Quote> _filterByStatusToken(
    List<Quote> quotes,
    String? statusToken,
  ) {
    if (statusToken == null || statusToken.trim().isEmpty) return quotes;
    final resolved = AssistantReadStatusLexicon.resolveStatuses(statusToken);
    if (resolved == null || resolved.isEmpty) return quotes;
    final allowed = <QuoteStatus>{};
    for (final name in resolved) {
      for (final status in QuoteStatus.values) {
        if (status.name == name) allowed.add(status);
      }
    }
    if (allowed.isEmpty) return quotes;
    return quotes
        .where((q) => allowed.contains(q.status))
        .toList(growable: false);
  }

  static String _countLabel(String statusToken, int count) {
    final folded = AssistantReadStatusLexicon.fold(statusToken);
    if (folded == 'aberto' || folded == 'abertos' || folded == 'open') {
      return count == 1
          ? '1 orçamento está em aberto.'
          : '$count estão em aberto.';
    }
    if (folded == 'rascunho' || folded == 'draft') {
      return count == 1
          ? '1 orçamento está em rascunho.'
          : '$count estão em rascunho.';
    }
    return count == 1
        ? '1 orçamento corresponde ao filtro "$statusToken".'
        : '$count orçamentos correspondem ao filtro "$statusToken".';
  }
}

/// Intermediate computation payload before gateway metadata wrapping.
class QuoteInsightComputation {
  const QuoteInsightComputation({
    required this.scannedCount,
    required this.maxScan,
    required this.scanCapped,
    required this.warnings,
    required this.summary,
    required this.metrics,
    required this.insights,
    this.dimensions = const [],
  });

  final int scannedCount;
  final int maxScan;
  final bool scanCapped;
  final List<AssistantInsightWarning> warnings;
  final AssistantInsightSummary summary;
  final List<AssistantInsightMetric> metrics;
  final List<AssistantInsight> insights;
  final List<AssistantInsightDimension> dimensions;
}
