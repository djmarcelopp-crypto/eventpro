# Assistente EventPRO — Tool Calling Framework (AI-028)

Infraestrutura para o Assistente **invocar ferramentas** do EventPRO de forma
segura, auditável e desacoplada.

> Nesta sprint: **somente contratos**, registry, router e mock executor.
> Nenhuma ferramenta executa operações reais (sem DB, HTTP, APIs).

**Tool Framework não executa lógica de negócio.**
**Business Reasoning decide.**
**Tool Framework apenas disponibiliza capacidades.**

## Fluxo

```
Business Reasoning (AI-023)
        ↓
Tool Framework (AI-028)   ← opt-in
        ↓
Execution Plan
```

Flag `canUseToolFramework = false`: nenhuma alteração.

## Contratos

`lib/features/assistant/domain/tools/`

- Tool / Id / Category / Capability / Metadata / Parameter / Result / Error / Reference / Execution
- Request / Response / ExecutionContext / ExecutionStatus / ExecutionMetadata
- Security: Permission / Policy / Scope / Risk
- Observability: Execution + Observer (sem logger)

## Port

`AssistantToolPort` — `execute` · `validate` · `supports` · `describe` · `health`

## Registry / Router

- `LocalAssistantToolRegistry` — register / find / findByCapability / list / defaultTools
- `LocalAssistantToolRouter` — capability / categoria / prioridade / contexto / risco

## Mock tools

`LocalMockToolExecutor`: findCustomer, findEvent, findQuote, findContract,
findSupplier, createReminder, openWorkflow — respostas determinísticas,
**sem alterar estado**.

## Integração

Opt-in: `canUseToolFramework` / `localToolFramework()`.

## Compatibilidade

- AI-014…AI-027 preservados
- `schemaVersion` 12
- Sem migrations / HTTP / SDKs
