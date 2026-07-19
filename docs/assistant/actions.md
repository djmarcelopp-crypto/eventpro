# Assistente EventPRO — Smart Action Engine (AI-012)

Pipeline determinístico de ações de navegação. Sem escrita, sem mutação de dados ERP, sem LLM.

## Arquitetura

```
Pergunta
  → Action Intent Resolver
  → AssistantActionPlanner
  → AssistantActionRequest
  → AssistantActionGateway
  → LocalActionAdapter
  → AssistantActionResult
  → AssistantActionFormatter
  → AssistantResponse (actionResult / actionPresentation)
```

Independente de Write, Read, Conversation e Insight.

## Contratos

| Tipo | Papel |
|------|--------|
| `AssistantActionRequest` | Pedido planejado (sem navegação) |
| `AssistantActionResult` | Resultado / diretiva de navegação |
| `AssistantNavAction` | Unidade de ação (PLAY: AssistantAction; nome distinto de AI-001) |
| `AssistantActionTarget` | Módulo / rota / entidade |
| `AssistantActionMetadata` | Timestamp, kind, idempotência |
| `AssistantActionWarning` | Avisos (alvo ausente, replay, etc.) |

Imutáveis, sem Flutter/Quotes nos modelos.

> **Nota de nomenclatura:** AI-001 já possui `AssistantAction` (botões propostos). A unidade AI-012 chama-se `AssistantNavAction`.

## Ações suportadas

| Kind | Exemplo | Rota típica |
|------|---------|-------------|
| `OPEN_QUOTES` | “Abra a tela de Orçamentos.” | `/quotes` |
| `OPEN_CLIENT` | “Abra o cliente.” | `/clients/:id` |
| `OPEN_LAST_QUOTE` | “Abra o último orçamento.” | `/quotes/:id` |
| `OPEN_DASHBOARD` | “Abra o dashboard.” | `/dashboard` |
| `OPEN_SETTINGS` | “Abra configurações.” | `/settings` |

O Planner **nunca** navega — só monta `AssistantActionRequest`.

O Adapter emite diretivas (`routePath`, `entityId`) para a UI. Não chama GoRouter e não altera estado ERP.

## Responsabilidades

| Componente | Faz | Não faz |
|------------|-----|---------|
| Intent Resolver | Detecta frases de navegação | Inferência probabilística |
| Planner | Intent → Request | Executar navegação |
| Gateway/Adapter | Validar alvo, idempotência | Escrita / HTTP externo |
| Formatter | NL + payload estruturado | UI widgets |

## Idempotência

Repetir a mesma ação (mesmo fingerprint) reutiliza o resultado anterior e emite warning `idempotentReplay`.

## Capabilities

Opt-in: `canPlanSmartActions` / `canExecuteSmartActions`  
Factory: `AssistantCapabilities.localSmartActions()`

## Limitações

- Somente navegação / foco de registro conhecido.
- Sem escrita, edição, exclusão ou automação de processos.
- Sem persistência, LLM ou serviços externos.
- `OPEN_CLIENT` / `OPEN_LAST_QUOTE` exigem id conhecido (context/session).
- Adapter não muda a rota do app sozinho — UI consome o payload.

## Evolução futura

- Mais módulos (agenda, financeiro) no mesmo contrato.
- Confirmação para ações sensíveis (ainda sem escrita).
- Adapter de UI que aplica `routePath` via GoRouter.
