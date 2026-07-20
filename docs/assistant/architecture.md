# Assistente EventPRO — Arquitetura

Documentação mínima da fronteira do assistente (EPIC-001…005). Escopo restrito ao feature `lib/features/assistant/**` (adapters hexagonais podem viver no módulo ERP dono do recurso).

## Pipeline

```
Texto
  → Parser
    → Intent (negócio / classificação)
    → Drafts (event/quote)
    → ResponseBuilder
    → Execution Planner
    → Module Consultant (leituras AI-003 / fixtures)
    → Execution Validator / Confirmation Gate AI-004 / Dispatcher
    → WriteIntentFactory + Write Coordinator (AI-005…007, isolado)
    → Workflow Engine (AI-016…019) — Command(operationCode) → CommandResolver→Capability → ExecutionPlan
         → Step Registry → Business Bridge → Gateway (stubs)
    → Transaction Execution Planner/Gateway (AI-014 — Create Quote Draft only)
         → valida confirmação → consome token → Write Pipeline → Result
         → Orchestrator emite audit (AI-015)
    → Safe Confirmation Planner (AI-013, isolado — lifecycle only)
         → ConfirmationRequest → Session → Pending → Result → Formatter
         → Orchestrator emite audit (AI-015)
    → Audit Query AUDIT_STATUS (AI-015, isolado)
         → QueryService → Formatter
    → Action Intent Resolver + Planner (AI-012, isolado)
         → ActionRequest → Gateway → LocalActionAdapter → Formatter
    → Insight Intent Resolver + Planner (AI-011, isolado)
         → InsightRequest → Gateway → Quote Insight Adapter → Formatter
    → Conversation Planner (AI-010) + Read Planner (AI-009)
         → ReadQuery → Gateway → Quote Read Adapter → Formatter
  → AssistantResponse
       (… | auditResult | auditPresentation |
        workflowResult | workflowPresentation | writeResult)
```

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

Production write continua **default deny**. AI-016…019 não duplicam pipelines
nem regras de módulo; commands/capabilities são declarativos e o Gateway só entra na execução.

## Defaults

- `localDefaults()` → sem executores
- `localReadIntegration()` → client/agenda in-memory
- `localStructuredQuoteRead()` / `localQuoteInsights()` / `localSmartActions()` /
  `localSafeConfirmation()` / `localTransactionExecution()` /
  `localAuditTrail()` / `localWorkflow()` / `localBusinessWorkflow()` → opt-in progressivo

## Dependência

Módulos ERP dependem dos contratos do assistente (ports), nunca o inverso para DAOs concretos.
