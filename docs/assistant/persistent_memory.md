# Assistente EventPRO — Persistent Memory Engine (AI-024)

Camada de **memória operacional** do Assistente.

> Não é memória do modelo.
> Não é cache.
> Não usa LLM, embeddings, banco vetorial, HTTP, Drift ou SQLite.
> Não altera `schemaVersion`.

Armazena conhecimento operacional estruturado do EventPRO para o próprio
Assistente (último cliente, orçamento, decisão, workflow, etc.).

## Arquitetura

```
Conversation (AI-021)
        ↓
Persistent Memory (AI-024)   ← opt-in
        ↓
Context Builder
        ↓
Execution Context
        ↓
… pipelines existentes …
```

## Contratos (CP-1)

`lib/features/assistant/domain/memory/`

| Contrato | Papel |
|----------|--------|
| `AssistantMemoryEntry` | Entrada imutável (tipo, escopo, key, value, refs, metadata, status, timestamps) |
| `AssistantMemoryId` | Identificador estável |
| `AssistantMemoryType` | Classification (conversation, preference, entity, business, workflow, reasoning, userPreference, temporary, permanent, system) |
| `AssistantMemoryScope` | session / user / company / global / system |
| `AssistantMemoryMetadata` | origin, reason, confidence, priority, tags, expiresAt |
| `AssistantMemorySearch` | Critérios estruturados (sem NLP) |
| `AssistantMemoryResult` | Resultado de search/list |
| `AssistantMemoryReference` | Referência opaca a entidade/decisão |
| `AssistantMemoryKeys` | Chaves bem-conhecidas (`last.client`, …) |

## Port (CP-2)

`AssistantPersistentMemory`

- `remember` / `forget` / `search` / `find` / `update` / `archive` / `list`

Sem implementação concreta no port.

## Local Engine (CP-3)

`LocalAssistantPersistentMemory` — **InMemory** no processo.

- Sem Drift / SQLite / migrations
- Políticas de expiração / substituição / capacidade aplicadas em memória
- Observer de observabilidade (contratos; default no-op)

## Classification (CP-4)

Cada entrada possui:

- `type` (`AssistantMemoryType`)
- `scope` (`AssistantMemoryScope`)
- `createdAt` / `updatedAt`
- `metadata.origin`
- `metadata.confidence`

## Retrieval (CP-5)

Consultas tipadas via keys (sem NLP):

- `last.client` / `last.quote` / `last.event` / `last.supplier`
- `last.decision` / `last.workflow` / `last.capability` / `last.entity`

## Integração (CP-6)

Opt-in via `AssistantCapabilities.canUsePersistentMemory`
(`localPersistentMemory()` também liga o Context Engine).

Fluxo padrão (quando Context Engine + Persistent Memory):

1. Conversation memory carrega/atualiza estado
2. Persistent Memory injeta hints (`persistentMemory:N`, `mem:key:value:confidence`)
3. Context Builder inclui hints no `traceHints` do Execution Context
4. Orchestrator propaga hints no `effectiveRequest` (sem mudar specialty paths)

Sem flag: comportamento idêntico a AI-014…AI-023.

## Policies (CP-7)

`AssistantMemoryPolicy` / `AssistantMemoryPolicyEvaluator`

- expiração (`defaultTtl`, `expiresAt`)
- prioridade
- retenção mínima
- substituição same-key
- arquivamento / eviction por capacidade

Infraestrutura apenas — sem persistência durável.

## Observabilidade (CP-8)

`AssistantMemoryOperationRecord` + `AssistantMemoryObserver`

Cada operação registra: origin, reason, timestamp, confidence, scope.
Sem logs concretos (no-op por padrão; collector só para testes).

## Compatibilidade

- AI-014…AI-023 preservados
- `schemaVersion` 12
- Sem migrations
- Sem LLM / HTTP / embeddings / vector DB
