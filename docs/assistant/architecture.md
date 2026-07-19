# Assistente EventPRO — Arquitetura

Documentação mínima da fronteira do assistente (EPIC-001 / EPIC-002 / EPIC-003). Escopo restrito ao feature `lib/features/assistant/**` (adapters hexagonais podem viver no módulo ERP dono do recurso).

## Pipeline

```
Texto
  → Parser
    → Intent (negócio / classificação)
    → Drafts (event/quote)
    → ResponseBuilder
    → Execution Planner
    → Module Consultant (leituras AI-003 / fixtures)
    → Execution Validator / Confirmation / Dispatcher
    → WriteIntentFactory + Write Coordinator (AI-005…007, isolado)
    → Insight Intent Resolver + Planner (AI-011, isolado)
         → InsightRequest → Gateway → Quote Insight Adapter → QuoteInsightService
         → InsightResult → Formatter → insightPresentation
    → Conversation Planner (AI-010) + Read Intent Resolver / Read Planner (AI-009)
         → (session context) → ReadQuery → Gateway → Quote Read Adapter → QuoteQueryService
         → ReadResult → Formatter → Presentation / Conversation Presentation
         (pulado quando o turno já foi atendido por insights)
  → AssistantResponse
       (moduleResults | readResult | readPresentation |
        conversationPresentation | insightResult | insightPresentation | writeResult)
```

Ver também:

- [controlled-execution.md](controlled-execution.md)
- [module-integration.md](module-integration.md)
- [write-pipeline.md](write-pipeline.md)
- [write-integration.md](write-integration.md)
- [idempotency.md](idempotency.md)
- [observability.md](observability.md)
- [structured-reads.md](structured-reads.md)
- [conversational-reads.md](conversational-reads.md)
- [conversation-context.md](conversation-context.md)
- [insights.md](insights.md)

O assistente **não** importa DAOs/Drift. Adapters vivem no módulo ERP e dependem dos contratos do assistente.

## Camadas

| Camada | Responsabilidade |
|--------|------------------|
| Models | DTOs (intent, plan, write, read, presentation, conversation, insight) |
| Domain contracts | Gateways, Idempotency, Policy, Read/Insight Planner/Formatter, Conversation Planner |
| Services | Implementações locais determinísticas |
| Adapters | In-memory (AI-003) / Quote write (AI-006) / Quote read (AI-008) / Quote insight (AI-011) |

## Escrita vs leitura vs insights

| Sprint | Escopo |
|--------|--------|
| AI-003 | Leituras fixture via Module Consultant |
| AI-005…007 | Write hardening; única mutação = create quote draft |
| AI-008 | Structured ERP reads (query object + adapter) |
| AI-009 | **Conversational quote intelligence** — intents + planner + formatter |
| AI-010 | **Conversation context engine** — sessão in-memory + follow-ups determinísticos |
| AI-011 | **Quote insights engine** — agregações determinísticas (count/distribution/top/last/month) |

Production write continua **default deny**. AI-009…011 não alteram write coordinator, gateway, policies, idempotency ou audit.

## Defaults

- `localDefaults()` → sem executores
- `localReadIntegration()` → client/agenda in-memory
- `localStructuredQuoteRead()` → leitura estruturada/conversacional de orçamentos (opt-in)
- `localQuoteInsights()` → insights + reads estruturados (opt-in)

## Dependência

Módulos ERP dependem dos contratos do assistente (ports), nunca o inverso para DAOs concretos.
