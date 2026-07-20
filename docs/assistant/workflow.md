# Assistente EventPRO — Workflow Engine (AI-016)

Motor determinístico que compõe **pipelines existentes** em uma sequência
ordenada, sem duplicar Read / Insight / Action / Confirmation / Transaction
Execution / Audit.

## Ciclo

```
Intent (multi-step)
  → WorkflowIntentResolver
  → WorkflowPlanner
       → WorkflowDefinitionRegistry.find(recipe)
       → ExecutionPlan (from Definition + requestId)
       → toWorkflow()  // bridge compatível
  → WorkflowExecutor
       → WorkflowExecutionState (imutável)
       → StepRegistry.handlerFor(kind)
       → pipeline existente (via bridge)
       → StepResult por etapa
       → interrompe se required step falha
  → WorkflowResult → Formatter → AssistantResponse
```

## Contratos novos (desacoplamento)

| Contrato | Papel |
|----------|--------|
| `WorkflowDefinition` | Recipe declarativa (id + steps), sem `requestId` |
| `WorkflowDefinitionRegistry` | Catálogo de definitions (receitas concretas) |
| `ExecutionPlan` | Plano request-scoped gerado a partir da definition |
| `StepResult` | Resultado de uma etapa (`StepOutcome` = alias) |
| `WorkflowExecutionState` | Snapshot imutável do progresso no executor |

O **Planner não conhece receitas concretas** — só resolve intent → registry → plan.
As recipes vivem em `LocalAssistantWorkflowDefinitionRegistry.defaults()`.

## Step Registry

`LocalAssistantWorkflowStepRegistry` é um mapa extensível
`StepKind → StepHandler`. Novos kinds/handlers são registrados sem switch
gigante. A bridge (`LocalAssistantWorkflowBridge`) apenas **delega** aos
serviços já existentes.

## Executor

Percorre etapas em ordem via `WorkflowExecutionState`; não conhece regras
de negócio. Em falha de etapa `required` ou `interrupt=true`, para e marca
`interrupted`.

## Contexto

`AssistantWorkflowContext` é imutável (`put` / `putAll` retornam cópia).
Outputs estruturados (ex.: `confirmationResult`, `auditResult`) são
compartilhados entre etapas e podem ser elevados ao `AssistantResponse`.

## Recipes iniciais (Definition Registry)

| Definition id | Etapas |
|---------------|--------|
| `confirmationStatusThenAudit` | confirmation(status) → audit |
| `confirmationCreateThenAudit` | confirmation(create) → audit |
| `reviewQuotesThenOpenLast` | insight(last) → action(openLast) |
| `findClientThenCreateQuote` | business(FIND_CLIENT) → business(CREATE_QUOTE) |
| `findEventThenOpenEvent` | business(FIND_EVENT) → business(OPEN_EVENT) |
| `findQuoteThenFindContract` | business(FIND_QUOTE) → business(FIND_CONTRACT) |

## Business integration (AI-017)

`StepKind.business` é atendido por `AssistantWorkflowBusinessBridge`, que
delega a `AssistantBusinessGateway` via registry extensível. Ver
[business_workflows.md](business_workflows.md).

Referências (`ClientReference`, …) fluem no `WorkflowContext` sem modelos ERP.

## Business capabilities (AI-018)

Antes da execução, o Planner resolve capabilities declarativas
(`FindClient`, `CreateQuote`, …) via
`AssistantBusinessCapabilityResolver`, com
`CapabilityResolutionStatus`, `AssistantBusinessCapabilityVersion`,
`AssistantBusinessCapabilityCategory` e `CapabilityExecutionNode` no
`ExecutionPlan`. Ver [business_capabilities.md](business_capabilities.md).

Fluxo de planejamento:

`Definition → Capability Resolver → ExecutionPlan (nodes) → Executor → Gateway`

## Extensibilidade

1. Registrar `WorkflowDefinition` no definition registry.
2. Registrar handler no step registry (se kind novo).
3. Registrar operação no business registry (AI-017).
4. Registrar capability no capability registry (AI-018).
5. Resolver frases no intent resolver.

## Limitações

- Sem rollback / filas / persistência / paralelismo / LLM
- Um workflow por turno
- TX/Read nas recipes atuais são stubs de reconhecimento (extensíveis)
- Business ops atuais são stubs locais (sem ERP)
- Sem alteração de `schemaVersion` (continua **12**)
