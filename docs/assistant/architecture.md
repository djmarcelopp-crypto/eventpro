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
    → Safe Confirmation Planner (AI-013, isolado — lifecycle only)
         → ConfirmationRequest → Session → Pending → Result → Formatter
    → Action Intent Resolver + Planner (AI-012, isolado)
         → ActionRequest → Gateway → LocalActionAdapter → Formatter
    → Insight Intent Resolver + Planner (AI-011, isolado)
         → InsightRequest → Gateway → Quote Insight Adapter → Formatter
    → Conversation Planner (AI-010) + Read Planner (AI-009)
         → ReadQuery → Gateway → Quote Read Adapter → Formatter
  → AssistantResponse
       (moduleResults | readResult | readPresentation |
        conversationPresentation | insightResult | insightPresentation |
        actionResult | actionPresentation |
        confirmationResult | confirmationPresentation | writeResult)
```

Pipelines posteriores são pulados quando um anterior já atendeu o turno (confirmation → action → insight → conversation/read).

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

O assistente **não** importa DAOs/Drift. Adapters vivem no módulo ERP e dependem dos contratos do assistente.

## Camadas

| Camada | Responsabilidade |
|--------|------------------|
| Models | DTOs (intent, plan, write, read, conversation, insight, action, confirmation) |
| Domain contracts | Gateways, Idempotency, Policy, Planners/Formatters |
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
| AI-013 | **Safe confirmation engine** — sessão/preview/confirm/cancel/expire (sem escrita) |

Production write continua **default deny**. AI-009…013 não alteram write coordinator, gateway, policies, idempotency ou audit.

## Defaults

- `localDefaults()` → sem executores
- `localReadIntegration()` → client/agenda in-memory
- `localStructuredQuoteRead()` / `localQuoteInsights()` / `localSmartActions()` / `localSafeConfirmation()` → opt-in progressivo

## Dependência

Módulos ERP dependem dos contratos do assistente (ports), nunca o inverso para DAOs concretos.
