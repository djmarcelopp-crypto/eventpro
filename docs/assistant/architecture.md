# Assistente EventPRO — Arquitetura

Documentação mínima da fronteira do assistente (EPIC-001 / EPIC-002). Escopo restrito ao feature `lib/features/assistant/**` (adapters hexagonais podem viver no módulo ERP dono do recurso).

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
  → Read Intent Resolver + Read Planner (AI-009)
       → ReadQuery → Gateway → Quote Read Adapter → QuoteQueryService
       → ReadResult → Formatter → Presentation
  → AssistantResponse
       (moduleResults | readResult | readPresentation | writeResult)
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

O assistente **não** importa DAOs/Drift. Adapters vivem no módulo ERP e dependem dos contratos do assistente.

## Camadas

| Camada | Responsabilidade |
|--------|------------------|
| Models | DTOs (intent, plan, write, read, presentation) |
| Domain contracts | Gateways, Idempotency, Policy, Read Planner/Formatter |
| Services | Implementações locais determinísticas |
| Adapters | In-memory (AI-003) / Quote write (AI-006) / Quote read (AI-008) |

## Escrita vs leitura

| Sprint | Escopo |
|--------|--------|
| AI-003 | Leituras fixture via Module Consultant |
| AI-005…007 | Write hardening; única mutação = create quote draft |
| AI-008 | Structured ERP reads (query object + adapter) |
| AI-009 | **Conversational quote intelligence** — intents + planner + formatter |

Production write continua **default deny**. AI-009 não altera write coordinator, gateway, policies, idempotency ou audit.

## Defaults

- `localDefaults()` → sem executores
- `localReadIntegration()` → client/agenda in-memory
- `localStructuredQuoteRead()` → leitura estruturada/conversacional de orçamentos (opt-in)

## Dependência

Módulos ERP dependem dos contratos do assistente (ports), nunca o inverso para DAOs concretos.
