# Assistente EventPRO — Context Engine (AI-021)

Camada responsável pelo **contexto conversacional** do Assistente.

> A AI-021 **não** utiliza LLM, **não** implementa memória permanente,
> **não** usa Drift/banco e **não** altera `schemaVersion`.

Complementa (não substitui) o Conversation Context de leituras de orçamento
([conversation-context.md](conversation-context.md) — AI-010).

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

Conversation → Memory → Context Builder → Execution Context

## Integração (CP-6)

Opt-in: `AssistantCapabilities.canUseContextEngine` /
`localContextEngine()`.

Orchestrator adiciona `traceHints` ao `AssistantContext.hints` sem breaking
changes. Fluxo textual default permanece intacto.

## Limitações

- Sem LLM / embeddings
- Sem persistência / Drift / migrations
- Sem memória cross-process
- `schemaVersion` = **12**
- AI-010 quote-read sessions continuam separadas

## Futuro

Persistência opcional, unificação com AI-010 e enrichment multimodal
permanecem fora desta sprint.
