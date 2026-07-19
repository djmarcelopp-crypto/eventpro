# Assistente EventPRO — Quote Insights Engine (AI-011)

Pipeline determinístico de insights analíticos sobre orçamentos. Sem LLM, embeddings, persistência, dashboards ou escrita.

## Arquitetura

```
Pergunta
  → Insight Intent Resolver
  → AssistantInsightPlanner
  → AssistantInsightRequest
  → AssistantInsightGateway
  → QuoteInsightAdapter
  → QuoteInsightService
  → AssistantInsightResult
  → AssistantInsightFormatter
  → AssistantResponse (insightResult / insightPresentation)
```

Totalmente **independente** de:

- Read Pipeline (AI-008/AI-009)
- Conversation Pipeline (AI-010)
- Write Pipeline (AI-005…007)

## Contratos (genéricos)

| Tipo | Papel |
|------|--------|
| `AssistantInsightRequest` | Pedido planejado (sem I/O) |
| `AssistantInsightResult` | Resultado agregado |
| `AssistantInsight` | Unidade explicativa |
| `AssistantInsightMetric` | Métrica numérica |
| `AssistantInsightDimension` | Bucket categórico |
| `AssistantInsightSummary` | Resumo textual |
| `AssistantInsightWarning` | Aviso (ex.: maxScan) |
| `AssistantInsightMetadata` | Timestamp, scan, source, kind |

Imutáveis, sem dependência de Quotes/Flutter/Drift nos modelos do assistente.

## Kinds suportados

| Kind | Exemplos |
|------|----------|
| `COUNT` | “Quantos orçamentos existem?”, “Quantos estão em aberto?” |
| `DISTRIBUTION` | “Existe concentração por status?” |
| `TOP_ENTITY` | “Qual cliente possui mais orçamentos?” |
| `LAST_CREATED` | “Qual foi o último orçamento?” |
| `CREATED_THIS_MONTH` | “Quantos foram criados este mês?” |

## Warnings e metadata

- Varredura limitada a `maxScan = 500`.
- Truncamento **sempre** gera `AssistantInsightWarning(code: maxScan)`.
- `metadata.scanCapped` / `scannedCount` / `maxScan` são expostos no payload estruturado.
- Nunca ocultar truncamento na linguagem natural.

## Capabilities

Opt-in:

- `canPlanQuoteInsights`
- `canExecuteQuoteInsights`

Factory: `AssistantCapabilities.localQuoteInsights()` (também habilita reads estruturados para compatibilidade conversacional).

## Limitações

- Sem IA generativa / LLM / embeddings.
- Sem persistência, cache, gráficos ou dashboards.
- Sem escrita; sem módulos de eventos/financeiro/clientes.
- Agregações sobre no máximo 500 registros (`listAll` capped).
- Somente módulo Quotes nesta sprint.

## Expansão futura

- Novos kinds (ticket médio, taxa de aprovação).
- Adapters para outros módulos via o mesmo gateway.
- Dimensões adicionais (período customizado) sem alterar contratos genéricos.
