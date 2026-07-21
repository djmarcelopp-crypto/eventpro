# Assistente EventPRO — Business Capability Engine (AI-018)

Camada declarativa que descreve, valida e resolve as capacidades de
negócio disponíveis **antes** da execução. O Workflow Engine permanece
desacoplado do ERP e do Business Gateway.

## Fluxo

```
Intent
  → Workflow Definition
  → Capability Resolver  (status / inputs / restrições / deps)
  → Capability Registry
  → Execution Plan       (resolvedCapabilities + executionNodes)
  → Workflow Executor
  → Business Gateway     (stubs AI-017)
  → AssistantResponse
```

O **Planner não conhece o Gateway** — só Definition + Capability Resolver.

## Capability Model

| Contrato | Papel |
|----------|--------|
| `AssistantBusinessCapability` | Declaração imutável |
| `AssistantBusinessCapabilityId` | Id estável (`FindClient`, …) |
| `AssistantBusinessCapabilityVersion` | Semântica `major.minor.patch` (catálogo v1) |
| `AssistantBusinessCapabilityCategory` | `lookup` / `create` / `open` / `mutate` / `other` |
| `Metadata` | Label, description, `operationCode` (ponte AI-017), tags |
| `Input` / `Output` | Slots declarados |
| `Constraint` | Pré-requisitos (`requiresContextKey`, `requiresSatisfiedDependency`, `requiresPriorCapability`) |
| `CapabilityResolutionStatus` | `ready` / `notFound` / `missingInput` / `unmetConstraint` / `blocked` |
| `CapabilityExecutionNode` | Nó ordenado no plano (id, version, category, status, stepId) |

## Registry

`LocalAssistantBusinessCapabilityRegistry` — mapa extensível id → capability.
Sem switch. Capacidades iniciais (todas `version = 1.0.0`):

| Id | Category | Operation code | Deps |
|----|----------|----------------|------|
| `FindClient` | lookup | FIND_CLIENT | — |
| `CreateQuote` | create | CREATE_QUOTE | `clientReference` |
| `FindEvent` | lookup | FIND_EVENT | — |
| `OpenEvent` | open | OPEN_EVENT | `eventReference` |
| `FindQuote` | lookup | FIND_QUOTE | — |
| `FindContract` | lookup | FIND_CONTRACT | `quoteReference` |

## Resolver

`LocalAssistantBusinessCapabilityResolver`:

- localiza no registry;
- valida inputs obrigatórios;
- valida constraints;
- atribui `CapabilityResolutionStatus` (e `ready` derivado);
- `resolveSequence` simula deps/outputs entre etapas;
- **nunca executa** operações.

## Planejamento

`LocalAssistantWorkflowPlanner.planExecution` (AI-019 + AI-018):

1. carrega Definition;
2. steps `business`: `operation` → **Command** (`operationCode`);
3. **CommandResolver** resolve a Capability correspondente;
4. Capability `resolveSequence`;
5. `ExecutionPlan` com `commandExecutionNodes` (`plannerOrder`, deps, outputs).

Recipes sem steps business (AI-016) seguem inalteradas (`executionNodes` vazio).

Ver [business_commands.md](business_commands.md).

## Contexto

`AssistantWorkflowContext` aceita (além das refs AI-017):

- `resolvedCapabilities`
- `producedEntities`
- `satisfiedDependencies`
- `sharedOutputs`
- `resolvedCommands` / `commandExecutionNodes` (AI-019)

## Multimodal (AI-020)

Capabilities e Commands só recebem conteúdo **já normalizado** (texto ready).
Entradas de imagem/áudio/documento sem processor **não** chegam como texto
vazio ao Capability Resolver. Ver [multimodal_inputs.md](multimodal_inputs.md).

## Context Engine (AI-021)

Capabilities resolvidas em turnos anteriores podem constar na memória
conversacional (IDs), sem reexecução automática. Ver
[context_engine.md](context_engine.md).

## Limitações

- Sem Drift / HTTP / LLM / persistência
- Sem regras reais de módulo ERP
- Gateways continuam stubs locais
- `schemaVersion` = **12**
