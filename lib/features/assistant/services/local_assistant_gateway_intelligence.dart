import '../domain/gateway/assistant_gateway.dart';
import '../domain/gateway_intelligence/assistant_gateway_intelligence.dart';
import '../domain/gateway_intelligence/gateway_entity_kind.dart';
import '../domain/gateway_intelligence/gateway_entity_reference.dart';
import '../domain/gateway_intelligence/gateway_match.dart';
import '../domain/gateway_intelligence/gateway_query.dart';
import '../domain/gateway_intelligence/gateway_query_result.dart';
import '../models/assistant_module_capability.dart';
import '../models/assistant_module_request.dart';
import '../utils/assistant_text_normalizer.dart';

/// Local catalog entry for deterministic resolution (no ERP / no HTTP).
class LocalGatewayCatalogEntry {
  const LocalGatewayCatalogEntry({
    required this.reference,
    this.aliases = const [],
  });

  final GatewayEntityReference reference;
  final List<String> aliases;
}

/// Composes existing module gateways + optional local catalog (AI-022).
///
/// No business rules beyond deterministic string matching / ranking.
class LocalAssistantGatewayIntelligence implements AssistantGatewayIntelligence {
  LocalAssistantGatewayIntelligence({
    AssistantGateway? gateway,
    List<LocalGatewayCatalogEntry> catalog = const [],
  })  : _gateway = gateway,
        _catalog = List.unmodifiable(
          catalog.isEmpty ? _defaultCatalog() : catalog,
        );

  final AssistantGateway? _gateway;
  final List<LocalGatewayCatalogEntry> _catalog;

  static List<LocalGatewayCatalogEntry> _defaultCatalog() => const [
        LocalGatewayCatalogEntry(
          reference: GatewayEntityReference(
            id: 'client-joao-silva',
            kind: GatewayEntityKind.client,
            label: 'João Silva',
            aliases: ['joao', 'joão silva'],
          ),
          aliases: ['joao', 'joão'],
        ),
        LocalGatewayCatalogEntry(
          reference: GatewayEntityReference(
            id: 'client-joao-pereira',
            kind: GatewayEntityKind.client,
            label: 'João Pereira',
            aliases: ['joao pereira'],
          ),
          aliases: ['joao', 'joão'],
        ),
        LocalGatewayCatalogEntry(
          reference: GatewayEntityReference(
            id: 'client-joao-eventos',
            kind: GatewayEntityKind.client,
            label: 'João Eventos',
            aliases: ['joao eventos'],
          ),
          aliases: ['joao', 'joão', 'eventos'],
        ),
        LocalGatewayCatalogEntry(
          reference: GatewayEntityReference(
            id: 'event-casamento-ana',
            kind: GatewayEntityKind.event,
            label: 'Casamento Ana',
          ),
        ),
        LocalGatewayCatalogEntry(
          reference: GatewayEntityReference(
            id: 'quote-2026-001',
            kind: GatewayEntityKind.quote,
            label: 'Orçamento 2026-001',
            aliases: ['orcamento 2026', 'orçamento 2026-001'],
          ),
        ),
        LocalGatewayCatalogEntry(
          reference: GatewayEntityReference(
            id: 'contract-c-100',
            kind: GatewayEntityKind.contract,
            label: 'Contrato C-100',
          ),
        ),
        LocalGatewayCatalogEntry(
          reference: GatewayEntityReference(
            id: 'supplier-luz-pro',
            kind: GatewayEntityKind.supplier,
            label: 'Luz Pro',
            aliases: ['luz'],
          ),
        ),
        LocalGatewayCatalogEntry(
          reference: GatewayEntityReference(
            id: 'product-kit-som',
            kind: GatewayEntityKind.product,
            label: 'Kit Som',
          ),
        ),
        LocalGatewayCatalogEntry(
          reference: GatewayEntityReference(
            id: 'resource-salao-a',
            kind: GatewayEntityKind.resource,
            label: 'Salão A',
            aliases: ['salao'],
          ),
        ),
      ];

  @override
  Future<GatewayQueryResult> search(GatewayQuery query) async {
    final matches = await listCandidates(query);
    return _toResult(query, matches);
  }

  @override
  Future<GatewayQueryResult> findBestMatch(GatewayQuery query) async {
    final matches = await listCandidates(query);
    if (matches.isEmpty) {
      return _toResult(query, matches);
    }
    if (matches.length >= 2 &&
        (matches[0].confidence - matches[1].confidence).abs() < 0.08) {
      return GatewayQueryResult(
        requestId: query.requestId,
        query: query,
        status: GatewayQueryStatus.ambiguous,
        matches: matches,
        bestMatch: null,
        suggestions: matches,
        messages: const [
          GatewayQueryMessage(
            code: GatewayQueryMessage.ambiguous,
            message: 'Múltiplos candidatos com confiança semelhante.',
          ),
        ],
      );
    }
    return GatewayQueryResult(
      requestId: query.requestId,
      query: query,
      status: GatewayQueryStatus.matched,
      matches: matches,
      bestMatch: matches.first,
      suggestions: matches.length > 1 ? matches.sublist(1) : const [],
    );
  }

  @override
  Future<GatewayEntityReference?> resolveReference({
    required GatewayEntityKind kind,
    required String raw,
    String? requestId,
  }) async {
    final result = await findBestMatch(
      GatewayQuery(
        requestId: requestId ?? 'resolve',
        rawText: raw,
        kinds: [kind],
      ),
    );
    return result.bestMatch?.reference;
  }

  @override
  Future<List<GatewayMatch>> listCandidates(GatewayQuery query) async {
    final text = query.effectiveText;
    if (text.isEmpty) return const [];

    final kinds = query.kinds.isEmpty
        ? GatewayEntityKind.values
        : query.kinds;
    final fromCatalog = _matchCatalog(text, kinds);
    final fromGateway = await _matchModuleGateways(query, kinds);

    final byId = <String, GatewayMatch>{};
    for (final m in [...fromCatalog, ...fromGateway]) {
      final key = '${m.reference.kind.name}:${m.reference.id}';
      final existing = byId[key];
      if (existing == null || m.confidence > existing.confidence) {
        byId[key] = m;
      }
    }

    final sorted = byId.values.toList()
      ..sort((a, b) {
        final byConf = b.confidence.compareTo(a.confidence);
        if (byConf != 0) return byConf;
        return (a.reference.label ?? a.reference.id)
            .compareTo(b.reference.label ?? b.reference.id);
      });

    final max = query.metadata.maxCandidates;
    final min = query.metadata.minConfidence;
    return sorted
        .where((m) => m.confidence >= min)
        .take(max)
        .toList(growable: false);
  }

  @override
  Future<List<GatewayMatch>> suggestEntities(GatewayQuery query) async {
    final result = await findBestMatch(query);
    if (result.isAmbiguous) return result.suggestions;
    if (result.bestMatch != null) {
      return [result.bestMatch!, ...result.suggestions];
    }
    return result.matches;
  }

  List<GatewayMatch> _matchCatalog(
    String text,
    List<GatewayEntityKind> kinds,
  ) {
    final folded = _fold(text);
    final out = <GatewayMatch>[];
    for (final entry in _catalog) {
      if (!kinds.contains(entry.reference.kind)) continue;
      final scored = _score(folded, entry);
      if (scored == null) continue;
      out.add(scored);
    }
    return out;
  }

  Future<List<GatewayMatch>> _matchModuleGateways(
    GatewayQuery query,
    List<GatewayEntityKind> kinds,
  ) async {
    final gateway = _gateway;
    if (gateway == null) return const [];

    final out = <GatewayMatch>[];
    if (kinds.contains(GatewayEntityKind.client) &&
        gateway.isRegistered(AssistantModuleCapability.searchClient) &&
        gateway.clients != null) {
      final response = gateway.clients!.searchClient(
        AssistantModuleRequest(
          id: 'gi-client-${query.requestId}',
          requestId: query.requestId,
          capability: AssistantModuleCapability.searchClient,
          query: query.effectiveText,
        ),
      );
      final result = response.result;
      if (result != null && result.found) {
        out.add(
          GatewayMatch(
            reference: GatewayEntityReference(
              id: result.identifier ?? result.id,
              kind: GatewayEntityKind.client,
              label: result.displayName,
            ),
            confidence: (result.confidence ?? 0.7).clamp(0.0, 1.0),
            reason: 'module_gateway.searchClient',
          ),
        );
      }
    }

    if (kinds.contains(GatewayEntityKind.quote) &&
        gateway.isRegistered(AssistantModuleCapability.lookupQuote) &&
        gateway.quotes != null) {
      final response = gateway.quotes!.lookupQuote(
        AssistantModuleRequest(
          id: 'gi-quote-${query.requestId}',
          requestId: query.requestId,
          capability: AssistantModuleCapability.lookupQuote,
          query: query.effectiveText,
        ),
      );
      final result = response.result;
      if (result != null && result.found) {
        out.add(
          GatewayMatch(
            reference: GatewayEntityReference(
              id: result.identifier ?? result.id,
              kind: GatewayEntityKind.quote,
              label: result.displayName,
            ),
            confidence: (result.confidence ?? 0.7).clamp(0.0, 1.0),
            reason: 'module_gateway.lookupQuote',
          ),
        );
      }
    }

    if (kinds.contains(GatewayEntityKind.product) &&
        gateway.isRegistered(AssistantModuleCapability.searchInventory) &&
        gateway.inventory != null) {
      final response = gateway.inventory!.searchInventory(
        AssistantModuleRequest(
          id: 'gi-inv-${query.requestId}',
          requestId: query.requestId,
          capability: AssistantModuleCapability.searchInventory,
          query: query.effectiveText,
        ),
      );
      final result = response.result;
      if (result != null && result.found) {
        out.add(
          GatewayMatch(
            reference: GatewayEntityReference(
              id: result.identifier ?? result.id,
              kind: GatewayEntityKind.product,
              label: result.displayName,
            ),
            confidence: (result.confidence ?? 0.65).clamp(0.0, 1.0),
            reason: 'module_gateway.searchInventory',
          ),
        );
      }
    }

    if (kinds.contains(GatewayEntityKind.resource) &&
        gateway.isRegistered(AssistantModuleCapability.searchTeam) &&
        gateway.team != null) {
      final response = gateway.team!.searchTeam(
        AssistantModuleRequest(
          id: 'gi-team-${query.requestId}',
          requestId: query.requestId,
          capability: AssistantModuleCapability.searchTeam,
          query: query.effectiveText,
        ),
      );
      final result = response.result;
      if (result != null && result.found) {
        out.add(
          GatewayMatch(
            reference: GatewayEntityReference(
              id: result.identifier ?? result.id,
              kind: GatewayEntityKind.resource,
              label: result.displayName,
            ),
            confidence: (result.confidence ?? 0.65).clamp(0.0, 1.0),
            reason: 'module_gateway.searchTeam',
          ),
        );
      }
    }

    return out;
  }

  GatewayMatch? _score(String foldedQuery, LocalGatewayCatalogEntry entry) {
    final label = entry.reference.label ?? entry.reference.id;
    final labelFolded = _fold(label);
    final aliasFolds = [
      ...entry.aliases.map(_fold),
      ...entry.reference.aliases.map(_fold),
    ];

    if (labelFolded == foldedQuery) {
      return GatewayMatch(
        reference: entry.reference,
        confidence: 0.98,
        reason: 'exact_label',
        scoreDetails: const ['exact'],
      );
    }
    for (final alias in aliasFolds) {
      if (alias == foldedQuery) {
        return GatewayMatch(
          reference: entry.reference,
          confidence: 0.9,
          reason: 'exact_alias',
          scoreDetails: const ['alias_exact'],
        );
      }
    }
    if (labelFolded.contains(foldedQuery) || foldedQuery.contains(labelFolded)) {
      return GatewayMatch(
        reference: entry.reference,
        confidence: 0.78,
        reason: 'partial_label',
        scoreDetails: const ['partial'],
      );
    }
    for (final alias in aliasFolds) {
      if (alias.contains(foldedQuery) || foldedQuery.contains(alias)) {
        return GatewayMatch(
          reference: entry.reference,
          confidence: 0.72,
          reason: 'partial_alias',
          scoreDetails: const ['alias_partial'],
        );
      }
    }
    return null;
  }

  GatewayQueryResult _toResult(GatewayQuery query, List<GatewayMatch> matches) {
    if (matches.isEmpty) {
      return GatewayQueryResult(
        requestId: query.requestId,
        query: query,
        status: GatewayQueryStatus.empty,
        messages: const [
          GatewayQueryMessage(
            code: GatewayQueryMessage.empty,
            message: 'Nenhum candidato encontrado.',
          ),
        ],
      );
    }
    if (matches.length >= 2 &&
        (matches[0].confidence - matches[1].confidence).abs() < 0.08) {
      return GatewayQueryResult(
        requestId: query.requestId,
        query: query,
        status: GatewayQueryStatus.ambiguous,
        matches: matches,
        suggestions: matches,
        messages: const [
          GatewayQueryMessage(
            code: GatewayQueryMessage.ambiguous,
            message: 'Múltiplos candidatos — sugestões ordenadas disponíveis.',
          ),
        ],
      );
    }
    return GatewayQueryResult(
      requestId: query.requestId,
      query: query,
      status: GatewayQueryStatus.matched,
      matches: matches,
      bestMatch: matches.first,
      suggestions: matches.length > 1 ? matches.sublist(1) : const [],
    );
  }

  static String _fold(String input) =>
      AssistantTextNormalizer.fold(AssistantTextNormalizer.normalize(input));
}
