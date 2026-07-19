# Assistente EventPRO — Conversation Context Engine (AI-010)

Contexto conversacional **determinístico** entre múltiplos turnos de leitura de orçamentos. Sem LLM, embeddings, persistência ou escrita.

## Pipeline

```
Pergunta
  → Intent Resolver (AI-009) / Reference Resolver (AI-010)
  → Conversation Session
  → Conversation Context
  → Conversation Planner
  → AssistantReadQuery
  → Gateway → Quote Adapter → Query Service
  → ReadResult → Formatter
  → Conversation Presentation
  → AssistantResponse
```

## Sessão

`AssistantConversationSession` é isolada por `sessionId` (`AssistantRequest.context.sessionId`).

Contém um snapshot `AssistantConversationContext`:

| Campo | Uso |
|-------|-----|
| `sessionId` | Isolamento |
| `lastIntent` | Último intent de leitura |
| `lastQuery` / `lastFilters` / `lastPagination` | Reuso em follow-ups |
| `lastResult` | Lista/foco para “esse”, “segundo”, etc. |
| `lastQuoteId` / `lastQuoteNumber` | Detalhes / “esse” |
| `lastClientName` | “Quem é o cliente?” |
| `focusedIndex` | Posição na lista atual |
| `version` / `updatedAt` | Ciclo de vida do contexto |

Regras:

- sem variáveis globais;
- registry injetável (`AssistantConversationSessionRegistry`);
- sem persistência (memória do processo / composition root);
- `reset()` limpa o contexto explicitamente.

Sem `sessionId`, o turno comporta-se como AI-009 (single-turn); follow-ups não acumulam estado.

## Ciclo de vida

1. `getOrCreate(sessionId)` no registry.
2. Planner resolve referência ou intent fresco.
3. Leitura bem-sucedida → `session.rememberTurn(...)`.
4. Drill-down (ordinal / esse / detalhes) preserva a lista anterior e atualiza o foco.
5. `reset(sessionId)` ou `remove` descarta o estado.

## Follow-up planner

`LocalAssistantConversationPlanner` reutiliza o contexto para montar a próxima `AssistantReadQuery` sem reconstruir a consulta manualmente.

Exemplos:

| Turno | Efeito |
|-------|--------|
| “Mostre os últimos cinco.” | Lista recente (intent fresco) |
| “Agora apenas os abertos.” | Refine de filtro de status |
| “E o segundo?” | Foco ordinal → by id |
| “Mostre os detalhes.” | By id do foco |
| “Quem é o cliente?” | Resposta contextual (sem round-trip) |

## Resolução de referências

`LocalAssistantReferenceResolver` — regras determinísticas sobre texto normalizado:

| Referência | Kind |
|------------|------|
| esse / ele / aquele | `thisOne` |
| último | `last` |
| anterior | `previous` |
| próximo | `next` |
| próximos / mais | `nextPage` |
| primeiro…quinto / “o 2” | `ordinal` |
| detalhes | `details` |
| cliente / quem é o cliente | `client` |
| agora apenas os abertos… | `filterRefine` |

Sem inferência probabilística. Toda resolução usa apenas o contexto atual da sessão.

## Conversation response

`AssistantConversationPresentation` envolve a continuidade:

- `naturalLanguage` — texto determinístico;
- `isFollowUp` / `missingContext`;
- `sessionId` / `contextVersion`.

Quando a referência não puder ser resolvida, retorna mensagem fixa de ausência de contexto. **Nenhuma exceção** é lançada por contexto vazio.

## Limitações

- Sem LLM / embeddings / vetores.
- Sem persistência entre reinícios do app.
- Sem escrita, confirmação, financeiro, módulo de clientes ou eventos.
- Referências só funcionam com `sessionId` estável entre turnos.
- Drill-down preserva a lista da sessão; um novo listagem substitui o contexto.
- Lexicon de status/refine é o mesmo de AI-009 (cues explícitos: agora/apenas/somente…).

## Compatibilidade

- AI-009 continua válido sem `sessionId`.
- Capabilities opt-in (`canPlanStructuredQuoteRead` / `canExecuteStructuredQuoteRead`).
- Write path inalterado.
- `schemaVersion` inalterado (12).
