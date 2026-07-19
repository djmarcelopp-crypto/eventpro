# Pipeline de execução controlada (AI-004)

## Objetivo

Preparar a infraestrutura definitiva de execução do Assistente EventPRO **sem** criar, alterar ou excluir registros reais.

## Pipeline

```
Parser → Intent → Planner → Execution Plan
  → Module Consultant (leituras opcionais AI-003)
  → Execution Validator
  → Confirmation Engine
  → Execution Dispatcher
  → Dry Run / Simulation Report
  → AssistantResponse
```

O Dispatcher **nunca** chama gateways/ERP diretamente. Sempre passa por Validator e Confirmation Engine.

## Modos (`AssistantExecutionMode`)

| Modo | AI-004 |
|------|--------|
| `dryRun` | Permitido (default) |
| `simulation` | Permitido |
| `production` | Reservado — rejeitado pelo validator |

## Componentes

- **AssistantExecutionContext / Request / Token / Policy / Audit / Report**
- **LocalAssistantExecutionValidator** — plano, policy, capabilities (writes off), consistência
- **LocalAssistantConfirmationEngine** — confirmação necessária / suficiente / inválida / ausente
- **LocalAssistantExecutionDispatcher** — relatório tipado; `mutatedErp == false`

## Confirmação

Confirmação **não** executa comandos. Mesmo com `providedValid`, o outcome é `simulated`.

## Auditoria

`AssistantExecutionAudit` permanece **somente em memória** (timestamp, token, mode, steps, confirmationStatus, plannerVersion, integrationMode, dataSources).

## Resposta

Campos AI-004: `executionReport`, `executionMode`, `executionAudit`, `executableSteps`, `simulatedSteps`, `skippedSteps`, `executionWarnings`.

Mensagem padrão:

> O assistente simulou a execução. Nenhuma alteração foi realizada no EventPRO.

Integração com preparação de escrita (AI-005): ver [write-pipeline.md](write-pipeline.md).

Primeira escrita real (AI-006 quote draft): ver [write-integration.md](write-integration.md).

Production continua bloqueada por padrão; a única exceção aprovada é create quote draft com policy `ai006QuoteDraftProduction`.
