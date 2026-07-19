# Assistente EventPRO — Arquitetura

Documentação mínima da fronteira do assistente (EPIC-001 / EPIC-002). Escopo restrito ao feature `lib/features/assistant/**` (adapters hexagonais podem viver no módulo ERP dono do recurso).

## Pipeline

```
Texto
  → Parser
  → Intent
  → Drafts (event/quote)
  → ResponseBuilder
  → Execution Planner
  → Module Consultant (leituras AI-003 / fixtures)
  → Gateway (contratos) / Adapter (leitura simulada)
  → Execution Validator
  → Confirmation Engine
  → Execution Dispatcher (dryRun / simulation)
  → WriteIntentFactory + Write Coordinator (AI-005…007, isolado)
  → ReadQueryFactory + Read Coordinator (AI-008, somente leitura)
       → Read Gateway → Quote Read Adapter → QuoteQueryService
  → AssistantResponse
       (moduleResults | readResult | writeResult)
```

Ver também:

- [controlled-execution.md](controlled-execution.md)
- [module-integration.md](module-integration.md)
- [write-pipeline.md](write-pipeline.md)
- [write-integration.md](write-integration.md)
- [idempotency.md](idempotency.md)
- [observability.md](observability.md)
- [structured-reads.md](structured-reads.md)

O assistente **não** importa DAOs/Drift. Adapters de leitura/escrita vivem no módulo ERP e dependem dos contratos do assistente.

## Camadas

| Camada | Responsabilidade |
|--------|------------------|
| Models | DTOs imutáveis (intent, plan, write, read, audit, observation) |
| Domain contracts | Parser, Classifier, Planner, Gateways, Idempotency, Policy, Read |
| Services | Implementações locais determinísticas |
| Policies | Production write (AI-007) — isoladas da leitura |
| Adapters | In-memory (AI-003) / Quote write (AI-006) / Quote read (AI-008) |

## Escrita vs leitura

| Sprint | Escopo |
|--------|--------|
| AI-003 | Leituras fixture via Module Consultant |
| AI-005…007 | Preparação + write hardening; única mutação = create quote draft |
| AI-008 | **Structured ERP reads** — contratos genéricos + Quote adapter; **zero escrita** |

Production write continua **default deny** (única policy ativa: Quote Draft). AI-008 não altera write coordinator, gateway, policies, idempotency ou audit.

## Defaults

- `localDefaults()` → sem executores de leitura/escrita.
- `localReadIntegration()` → client/agenda in-memory (AI-003).
- `localStructuredQuoteRead()` → leitura estruturada de orçamentos (AI-008).

## Dependência

Módulos ERP dependem dos contratos do assistente (ports), nunca o inverso para DAOs concretos.
