# Assistente EventPRO — Business Command Engine (AI-019)

Camada declarativa de **comandos de negócio**.

## Fonte única de resolução

| Conceito | Dono |
|----------|------|
| `operationCode` | **Business Command** (declaração) |
| Capability correspondente | **CommandResolver** (resolve via `operationCode`) |

```
step.params.operation
  → Command Registry.findByOperationCode
  → Command Resolver  (resolve Capability pelo operationCode)
  → Capability Resolver
  → ExecutionPlan
```

Commands **não** declaram `capabilityId`.

## CommandExecutionNode

| Campo | Papel |
|-------|--------|
| `plannerOrder` | Ordem no plano |
| `commandId` | Id do command |
| `version` / `category` | Metadados |
| `status` | `CapabilityResolution`-equivalente do command |
| `operationCode` | Código de operação |
| `stepId` | Step da definition |
| `dependencyIndexes` | Ordens de commands produtores de deps |
| `producedOutputs` | Keys de resultados declarados |

AR-002: esses nodes permanecem no `AssistantWorkflow` / `WorkflowContext`
durante a execução (sem serem executados ainda).

## Multimodal (AI-020)

Commands/Capabilities recebem apenas conteúdo **já normalizado** (texto).
Entradas de mídia sem processor não chegam ao Command Resolver.

Ver [multimodal_inputs.md](multimodal_inputs.md).

## Context Engine (AI-021)

O Context Engine pode fornecer intents/commands/entidades recentes ao
contexto do turno, sem executar Commands. Ver
[context_engine.md](context_engine.md).

## Limitações

- Sem execução real no Gateway
- `schemaVersion` = **12**
