# Assistente EventPRO — Business Workflow Integration (AI-017)

Conecta o Workflow Engine (AI-016) aos primeiros serviços de negócio
do EventPRO **sem** embutir regras de domínio no motor de workflow.

## Fluxo

```
User
  → Orchestrator
  → Workflow Planner → Definition Registry
  → Workflow Executor
       → StepKind.business
       → Business Bridge
       → Business Registry → Gateway → handlers (stubs)
       → Entity References no WorkflowContext
  → WorkflowResult → Formatter → AssistantResponse
```

## Business Gateway

`AssistantBusinessGateway` é a porta de invocação. A implementação local
(`LocalAssistantBusinessGateway`) apenas:

1. consulta o registry;
2. despacha o handler registrado;
3. devolve `AssistantBusinessResult`.

Sem Drift, HTTP, DAOs ou regras de módulo.

## Registry

`AssistantBusinessRegistry` / `LocalAssistantBusinessRegistry` — mapa
extensível `code → (Operation, Handler)`. **Proibido** switch gigante.

Operações iniciais (stubs):

| Code | Papel |
|------|--------|
| `FIND_CLIENT` | Resolve `ClientReference` |
| `CREATE_QUOTE` | Exige `clientReference` → `QuoteReference` |
| `FIND_EVENT` | Resolve `EventReference` |
| `OPEN_EVENT` | Exige `eventReference` |
| `FIND_QUOTE` | Resolve `QuoteReference` |
| `FIND_CONTRACT` | Resolve `ContractReference` |

## Bridge

`AssistantWorkflowBusinessBridge` implementa `AssistantWorkflowStepHandler`
para `StepKind.business`:

- lê `params.operation` + referências do contexto;
- monta `AssistantBusinessRequest`;
- chama o Gateway;
- grava referências / `businessResult` no contexto.

Não conhece regras de negócio.

## Entity References

Hierarquia imutável, independente de Flutter/Drift/ERP:

- `AssistantBusinessReference` (base)
- `ClientReference` / `QuoteReference` / `EventReference` / `ContractReference`

Compartilham identidade entre etapas via `AssistantWorkflowContext`
(`AssistantWorkflowBusinessKeys` + extension tipada).

## Recipes (Definition Registry)

| id | Etapas |
|----|--------|
| `findClientThenCreateQuote` | FIND_CLIENT → CREATE_QUOTE |
| `findEventThenOpenEvent` | FIND_EVENT → OPEN_EVENT |
| `findQuoteThenFindContract` | FIND_QUOTE → FIND_CONTRACT |

Capability: `AssistantCapabilities.localBusinessWorkflow()`.

## Isolamento

| Camada | Conhece ERP? |
|--------|--------------|
| Workflow Engine | Não |
| Business Bridge | Não |
| Business Registry/Gateway | Não (stubs) |
| Futuros adapters ERP | Sim (fora do assistente) |

## Limitações

- Stubs in-memory apenas
- Sem persistência / migrations / LLM
- Um workflow por turno
- `schemaVersion` permanece **12**
