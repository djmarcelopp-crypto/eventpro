# Assistente EventPRO — Arquitetura

Documentação mínima da fronteira do assistente (EPIC-001…005). Escopo restrito ao feature `lib/features/assistant/**` (adapters hexagonais podem viver no módulo ERP dono do recurso).

## Pipeline

Ordem **real** em `LocalAssistantOrchestrator.handle()` (AR-002):

```
Request
  → [opt] Multimodal Input Pipeline (AI-020)
  → [opt] Context Engine (AI-021) — hints / memory (sem inventar sessionId)
  → effectiveRequest  (única instância lógica daqui em diante)
  → Parser
  → [opt] Gateway Intelligence (AI-022) — entity candidates → hints
  → Intent → Drafts → ResponseBuilder
  → Execution Planner → Module Consultant → Dispatcher
  → WriteIntentFactory (prepare)
  → Workflow Engine (AI-016…019)
       → ExecutionPlan → Workflow (+ planner metadata no context)
       → Step Registry → Business Bridge → Gateway
  → Transaction Execution (AI-014) — Create Quote Draft
  → Safe Confirmation (AI-013)
  → Audit Query (AI-015)
  → Smart Action (AI-012)
  → Insight (AI-011)
  → Conversation AI-010 + Read (AI-009)
  → AssistantResponse
```

`effectiveRequest` é a única fonte consumida por specialty paths (AR-002 / C1).
Identidade conversacional: `AssistantTurnIdentity` (sessionId / conversationId /
correlationId) — AR-002 / C2–C3.

Pipelines posteriores são pulados quando um anterior já atendeu o turno
(workflow → transaction execution → confirmation → audit → action → insight → conversation/read).

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
- [actions.md](actions.md)
- [confirmation.md](confirmation.md)
- [execution.md](execution.md)
- [audit.md](audit.md)
- [workflow.md](workflow.md)
- [business_workflows.md](business_workflows.md)
- [business_capabilities.md](business_capabilities.md)
- [business_commands.md](business_commands.md)
- [multimodal_inputs.md](multimodal_inputs.md)
- [context_engine.md](context_engine.md)
- [gateway_intelligence.md](gateway_intelligence.md)

O assistente **não** importa DAOs/Drift. Adapters vivem no módulo ERP e dependem dos contratos do assistente.

## Camadas

| Camada | Responsabilidade |
|--------|------------------|
| Models | DTOs (… audit, workflow) |
| Domain contracts | … Audit, Workflow |
| Services | Implementações locais determinísticas |
| Adapters | In-memory / Quote write / Quote read / Quote insight / Local action |

## Sprints

| Sprint | Escopo |
|--------|--------|
| AI-003 | Leituras fixture via Module Consultant |
| AI-004 | Controlled execution + step confirmation gate |
| AI-005…007 | Write hardening; única mutação = create quote draft |
| AI-008…010 | Structured / conversational reads + conversation context |
| AI-011 | Quote insights engine |
| AI-012 | Smart action engine (navegação) |
| AI-013 | Safe confirmation engine — sessão/preview/confirm/cancel/expire (sem escrita) |
| AI-014 | Transaction execution engine — confirmação → Create Quote Draft |
| AI-015 | Transaction audit trail — append-only in-memory |
| AI-016 | Workflow engine — composição determinística de pipelines |
| AI-017 | Business workflow integration — bridge/registry/gateway + entity refs |
| AI-018 | Business capability engine — registry/resolver + planner integration |
| AI-019 | **Business command engine** — registry/resolver + planner integration |
| AI-020 | **Multimodal input engine** — contracts/normalizer/pipeline (sem OCR/STT) |
| AI-021 | **Context engine** — conversation memory + execution context (sem LLM/Drift) |
| AR-002 | **Stabilization** — effectiveRequest, TurnIdentity, plan metadata, DIP ports |
| AI-022 | **Gateway intelligence** — entity discovery via gateway composition (sem LLM/HTTP) |

Production write continua **default deny**. AI-016…019 não duplicam pipelines
nem regras de módulo; commands/capabilities são declarativos e o Gateway só entra na execução.
AI-020 adiciona intake multimodal opt-in sem motores reais de mídia.
AI-021 adiciona contexto conversacional in-memory opt-in, sem memória permanente.
AR-002 estabiliza wiring do orchestrator sem novas funcionalidades.
AI-022 adiciona descoberta de entidades opt-in sobre gateways locais.

## Defaults

- `localDefaults()` → sem executores
- `localReadIntegration()` → client/agenda in-memory
- `localStructuredQuoteRead()` / `localQuoteInsights()` / `localSmartActions()` /
  `localSafeConfirmation()` / `localTransactionExecution()` /
  `localAuditTrail()` / `localWorkflow()` / `localBusinessWorkflow()` → opt-in progressivo

## Dependência

Módulos ERP dependem dos contratos do assistente (ports), nunca o inverso para DAOs concretos.
