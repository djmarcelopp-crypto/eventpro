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

## Limitações

- Sem execução real no Gateway
- `schemaVersion` = **12**
