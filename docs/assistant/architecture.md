# Assistente EventPRO — Arquitetura

Documentação mínima da fronteira do assistente (EPIC-001). Escopo restrito ao feature `lib/features/assistant/**`.

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
  → WriteIntentFactory (intenções de escrita)
  → Write Coordinator (Validator + Authorizer + ExecutionContext)
  → Write Gateway / Quote Draft Adapter (AI-006, production restrita)
  → AssistantResponse enriquecida
```

Ver também: [controlled-execution.md](controlled-execution.md), [module-integration.md](module-integration.md), [write-pipeline.md](write-pipeline.md), [write-integration.md](write-integration.md).

O assistente **nunca** importa repositories, DAOs, Drift ou services concretos dos módulos ERP (exceto via adapter hexagonal no módulo quotes).

## Camadas

| Camada | Responsabilidade |
|--------|------------------|
| Models | DTOs imutáveis (intent, plan, module result, data source) |
| Domain contracts | Parser, Classifier, Planner, Gateways |
| Services | Implementações locais determinísticas |
| Adapters | Fixtures in-memory (AI-003) / futuros adapters ERP |

## Planning vs Execution

- **Planning (`canPlan*`)** — o passo pode aparecer no `ExecutionPlan`.
- **Execution (`canExecute*`)** — um executor registrado **pode ser invocado** na configuração atual.

`canExecuteClientSearch` / `canExecuteScheduleRead` / `canExecuteAvailabilityRead` **não** significam, sozinhas:

- acesso ao banco do ERP;
- dado produtivo;
- integração real aprovada;
- resultado confiável para operação.

O nível de confiança/ambiente é dado por:

- `AssistantCapabilities.integrationMode` (`none` | `inMemory` | `erp`);
- `AssistantModuleDataSource` em cada resultado (`inMemory`, `demo`, `test`, `erp`, `remote`).

## Defaults

- `localDefaults()` → `integrationMode=none`, nenhuma leitura/escrita executável.
- `localReadIntegration()` → `integrationMode=inMemory`, leituras de cliente/agenda opt-in; writes `false`.

## Escrita

AI-005 modela a **Write Pipeline** (intenção → validator → authorizer → coordinator → `WriteResult`).

AI-006 habilita **somente** `create quote draft` em `production` restrita, via `QuoteAssistantWriteAdapter` + `QuoteDraftCreationService`.

- `canExecuteCreateQuote` **não** significa acesso irrestrito ao ERP.
- A única escrita real permitida: **create quote draft**.
- Detalhes: [write-pipeline.md](write-pipeline.md), [write-integration.md](write-integration.md).

## Dependência

Módulos ERP futuros devem **depender dos contratos do assistente** (ou de ports compartilhados), nunca o inverso: o assistente não aponta para implementações concretas do ERP.
