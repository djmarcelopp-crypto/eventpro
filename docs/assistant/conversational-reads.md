# Conversational Quote Reads (AI-009)

## Objetivo

Experiência conversacional **determinística** sobre a infraestrutura de leitura AI-008.

**Somente READ.** Nenhuma escrita, confirmação, policy ou LLM.

## Fluxo

```
Pergunta
  → LocalAssistantReadIntentResolver (AssistantReadIntent)
  → AssistantReadPlanner → AssistantReadQuery
  → AssistantReadGateway → QuoteAssistantReadAdapter → QuoteQueryService
  → AssistantReadResult
  → AssistantReadFormatter → AssistantReadPresentation
  → AssistantResponse (readResult + readPresentation + friendlyMessage)
```

O pipeline de escrita permanece isolado.

## Intents

| Intent | Exemplo |
|--------|---------|
| `ReadQuotesIntent` | Listar orçamentos em rascunho |
| `ReadQuoteByIdIntent` | id=q-123 |
| `ReadQuoteByNumberIntent` | ORC-2026-0001 / número 1523 |
| `ReadRecentQuotesIntent` | Últimos / cinco últimos |
| `ReadQuoteSummaryIntent` | Quantos estão em aberto? |
| `ReadQuoteByCustomerIntent` | Orçamento para João |

Intents não executam consultas — apenas descrevem intenção de negócio.

## Planner

`LocalAssistantReadPlanner` é a **única** fonte de montagem de `AssistantReadQuery`.

`LocalAssistantReadQueryFactory` (AI-008) virou wrapper fino: resolve intent → chama planner.

### Lexicon de status

Centralizado em `AssistantReadStatusLexicon`:

| Token | Status canônico |
|-------|-----------------|
| rascunho / draft | `draft` |
| enviado / sent | `sent` |
| aprovado / approved | `approved` |
| aberto / abertos / open | `draft` + `sent` (`operator=in`) |

## Formatter

`LocalAssistantReadFormatter` produz:

- **naturalLanguage** — resposta em português
- **structured** — payload tipado para futura UI (`count`, `recordIds`, `scanLimited`, …)

Casos: vazio, único, múltiplo, paginação, limite de página, warning de `maxScan`.

## Capabilities

Continuam opt-in (`canPlan/ExecuteStructuredQuoteRead`). Default off.

## Limitações

- Sem LLM / NLP probabilístico
- Apenas módulo quote
- Cliente filtrado por `clientDisplayName` (contains), sem módulo Clientes
- `listAll` + `maxScan=500` permanece (AI-008)
- Número solto (`1523`) usa `contains` no campo number

## Expansão futura

Novos módulos: novas intents + regras no planner/resolver, sem mudar contratos genéricos de query.
