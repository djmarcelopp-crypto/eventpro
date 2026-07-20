# Assistente EventPRO — Safe Confirmation Engine (AI-013)

Motor transversal de confirmação para operações sensíveis. Nesta sprint **não executa escrita** — apenas ciclo de vida (preview → confirmar / cancelar / expirar).

## Arquitetura

```
Intent
  → Confirmation Planner
  → Confirmation Request
  → Confirmation Session
  → Pending Confirmation
  → Confirmation Result
  → Confirmation Formatter
  → AssistantResponse
```

Independente de Write, Read, Conversation, Insight e Action.

> **Nota:** O gate AI-004 (`AssistantConfirmationEngine` + `confirmedStepIds`) permanece intacto. AI-013 é um pipeline paralelo de sessão/UX.

## Contratos

| Tipo | Papel |
|------|--------|
| `AssistantConfirmationRequest` | Pedido planejado |
| `AssistantConfirmationResult` | Resultado do turno |
| `PendingConfirmation` | Estado pendente em memória |
| `AssistantConfirmationToken` | Token opaco |
| `AssistantConfirmationMetadata` | Timestamp / outcome / expiração |
| `AssistantConfirmationWarning` | Avisos (missing, expired, …) |

## Ciclo de vida

1. **Criar** — gera preview + `PendingConfirmation` + token (TTL default 5 min).
2. **Confirmar** — valida pendente ativo; marca confirmado; **não escreve no ERP**.
3. **Cancelar** — marca cancelado.
4. **Expirar** — após TTL; acesso subsequente retorna `expired`.
5. **Reset** — `session.reset()` / registry `reset(sessionId)`.

Sem persistência. Sessões isoladas por `sessionId` via registry injetável.

## Frases determinísticas (exemplos)

| Intent | Exemplos |
|--------|----------|
| create | “Solicitar confirmação para criar orçamento” |
| confirm | “Confirmar”, “Confirmo” |
| cancel | “Cancelar confirmação”, “Cancelar” |
| status | “Qual confirmação está pendente?” |

## Capabilities

Opt-in: `canPlanSafeConfirmation` / `canExecuteSafeConfirmation`  
Factory: `AssistantCapabilities.localSafeConfirmation()`

## Integração futura

- Quando uma escrita sensível for autorizada, o write path poderá exigir um `AssistantConfirmationToken` confirmado nesta sessão.
- AI-004 `confirmedStepIds` pode ser alimentado a partir de um pending confirmado (adapter futuro).
- Sem confirmação automática.

## Limitações

- Nenhuma escrita / edição / exclusão nesta sprint.
- Sem LLM, persistência ou serviços externos.
- Requer `context.sessionId` para multi-turno.
- Preview é declarativo (não executa a operação descrita).
