# Assistente EventPRO — Arquitetura

Documentação mínima da fronteira do assistente (EPIC-001). Escopo restrito ao feature `lib/features/assistant/**` (adapters hexagonais podem viver no módulo ERP dono do recurso).

## Pipeline

```
Texto
  → Parser
  → Intent
  → Drafts (event/quote)
  → ResponseBuilder
  → Execution Planner
  → Module Consultant
  → Gateway (contratos) / Adapter (leitura simulada)
  → Execution Validator
  → Confirmation Engine
  → Execution Dispatcher (dryRun / simulation)
  → WriteIntentFactory
  → Write Coordinator
       → Validator / Authorizer
       → Production Write Policy Registry (default deny)
       → Idempotency Service
       → Write Gateway → Quote Adapter → QuoteDraftCreationService
  → Audit + Observation
  → AssistantResponse
```

Ver também:

- [controlled-execution.md](controlled-execution.md)
- [module-integration.md](module-integration.md)
- [write-pipeline.md](write-pipeline.md)
- [write-integration.md](write-integration.md)
- [idempotency.md](idempotency.md)
- [observability.md](observability.md)

O assistente **não** importa DAOs/Drift. O adapter de escrita vive em `lib/features/quotes/assistant/` e depende dos contratos do assistente.

## Camadas

| Camada | Responsabilidade |
|--------|------------------|
| Models | DTOs imutáveis (intent, plan, write, idempotency, audit, observation) |
| Domain contracts | Parser, Classifier, Planner, Gateways, Idempotency, Policy, Observer |
| Services | Implementações locais determinísticas |
| Policies | `QuoteDraftProductionPolicy` (única ativa) + placeholders bloqueados |
| Adapters | Fixtures in-memory (AI-003) / Quote write adapter (AI-006) |

## Planning vs Execution

- **Planning (`canPlan*`)** — o passo pode aparecer no `ExecutionPlan`.
- **Execution (`canExecute*`)** — um executor registrado **pode ser invocado** na configuração atual.
- **Capabilities ≠ permissão de production** — production exige policy explícita + gates.

## Escrita

| Sprint | Escopo |
|--------|--------|
| AI-005 | Preparação segura (sem mutação) |
| AI-006 | Única escrita real: **create quote draft** |
| AI-007 | Hardening: idempotência, observabilidade, policies, audit — **sem novos casos de uso** |

Placeholders `EventProductionPolicy` / `CustomerProductionPolicy` **não** representam funcionalidade disponível (`isActive=false`).

## Defaults

- `localDefaults()` → `integrationMode=none`, nenhuma leitura/escrita executável.
- Production: **default deny** via registry; única policy ativa = Quote Draft.
- Relógios e geradores de ID injetáveis nos serviços de escrita/audit.

## Dependência

Módulos ERP dependem dos contratos do assistente (ports), nunca o inverso para DAOs concretos.
