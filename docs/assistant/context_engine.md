# Assistente EventPRO — Context Engine (AI-021)

Camada responsável pelo **contexto conversacional** do Assistente.

> A AI-021 **não** utiliza LLM, **não** implementa memória permanente,
> **não** usa Drift/banco e **não** altera `schemaVersion`.

Complementa (não substitui) o Conversation Context de leituras de orçamento
([conversation-context.md](conversation-context.md) — AI-010).

## Ownership (AR-002)

| Concern | Owner | Escreve | Lê |
|---------|-------|---------|-----|
| `sessionId` / `correlationId` | `AssistantTurnIdentity` em `effectiveRequest` | Caller / intake | Todos os pipelines |
| Quote-read follow-ups | AI-010 SessionRegistry | Planner após read OK | AI-010 / smart actions |
| Turns / summary / cmd-cap labels | AI-021 ConversationMemory | Context pipeline (opt-in) | Context Builder / hints |
| Confirmation pending | ConfirmationSessionRegistry | Confirmation planner | TX |

Regras:

- AI-010 **não** escreve memória AI-021.
- AI-021 **não** escreve `AssistantConversationContext` (AI-010).
- AI-021 **não inventa** `sessionId` para forçar sessão AI-010; usa
  `req:{requestId}` só como `conversationId` interno quando não há sessão.

## Arquitetura

```
Conversation
        ↓
Memory
        ↓
Context Builder
        ↓
Execution Context
        ↓
Intent
        ↓
Business Command
        ↓
Capability
        ↓
Workflow
        ↓
Execution Plan
        ↓
Gateway
```

## Contratos (CP-1)

Local: `lib/features/assistant/domain/context/`

- `AssistantConversation` / `AssistantConversationId`
- `AssistantConversationTurn`
- `AssistantConversationState`
- `AssistantConversationMetadata`
- `AssistantConversationSummary`
- `AssistantConversationSnapshot`
- `AssistantConversationStatus`

Imutáveis; sem Flutter UI, HTTP ou Drift.

## Memory (CP-2)

`LocalAssistantConversationMemory` (processo local):

- histórico de turnos (capado);
- resumo;
- última intenção / workflow / commands / capabilities / entidades;
- contexto ativo.

## Context Builder (CP-3)

`LocalAssistantContextBuilder` monta
`AssistantConversationExecutionContext` (Execution Context do Context Engine).

> Distinto do `AssistantExecutionContext` de write (AI-002/004).

Não executa Commands, Capabilities, Workflow ou Gateway.

## Summarizer (CP-4)

`LocalAssistantConversationSummarizer` — resumo **determinístico** sem IA:

- reduz histórico antigo;
- preserva intents, commands, capabilities, entidades e workflows.

## Pipeline (CP-5)

`LocalAssistantContextPipeline`:

Conversation → [opt] Persistent Memory (AI-024) → Context Builder → Execution Context

Quando `LocalAssistantPersistentMemory` é injetado, hints `persistentMemory:*`
/ `mem:*` entram no Execution Context sem alterar o fluxo default.

## Integração (CP-6)

Opt-in: `AssistantCapabilities.canUseContextEngine` /
`localContextEngine()`.

Persistent Memory: `canUsePersistentMemory` / `localPersistentMemory()`
(ver [persistent_memory.md](persistent_memory.md)).

Orchestrator adiciona `traceHints` ao `AssistantContext.hints` sem breaking
changes. Fluxo textual default permanece intacto.

## Limitações

- Sem LLM / embeddings
- Sem persistência / Drift / migrations
- Sem memória cross-process
- `schemaVersion` = **12**
- AI-010 quote-read sessions continuam separadas
- AI-024 Persistent Memory é in-memory (não é memória permanente em disco)

## Futuro

Persistência opcional, unificação com AI-010 e enrichment multimodal
permanecem fora desta sprint.
