# Write Pipeline — preparação segura (AI-005)

## Objetivo

Modelar e validar **intenções de escrita** no Assistente EventPRO **sem** alterar o ERP.

Nesta sprint:

- nenhuma operação cria, atualiza, cancela ou exclui registros;
- nenhum comando é enviado a Repository, DAO, Gateway concreto, SQLite ou HTTP;
- `AssistantWriteResult.executed` permanece **sempre** `false`.

## Intenção de escrita

`AssistantWriteRequest` descreve o que *poderia* ser escrito no futuro:

| Campo | Papel |
|-------|--------|
| `operation` | `create` / `update` (`delete`/`cancel` reservados) |
| `target` | alvo lógico (`event`, `quote`, `client`, …) |
| `capability` | capacidade declarada (`createEvent`, …) |
| `constraints` | pré-condições da intenção |
| `authorization` | snapshot de autorização (não executa) |
| `attributes` | mapa opaco `String → String` (sem entidades ERP) |
| `relatedStepId` | vínculo opcional com passo do Execution Plan |

## Componentes

### Validator (`LocalAssistantWriteValidator`)

Valida operação suportada, target, capability correspondente, constraints, autorização e consistência da request.

**Nunca** consulta o ERP.

### Authorizer (`LocalAssistantWriteAuthorizer`)

Avalia apenas autorização:

- `authorized`
- `denied`
- `insufficientPrivileges`
- `confirmationRequired`

**Nunca** executa, modifica ou persiste.

### Coordinator (`LocalAssistantWriteCoordinator`)

Fluxo (AI-007):

```
WriteRequest
  → WriteValidator
  → WriteAuthorizer
  → Production Write Policy Registry (production)
  → Idempotency Service
  → Write Gateway (somente create quote draft)
  → WriteResult + Audit + Observation
```

Em `prepare()` isolado / dryRun / simulation: **não** muta o ERP.

Produz `AssistantWritePreparation` com:

- `writeResult`
- `writeValidation`
- `writeAuthorization`
- `writeWarnings`
- `context` (eco do `AssistantExecutionContext`)
- `writeAudit` (quando aplicável)

## Integração com Execution Pipeline (AI-004)

```
Parser → Intent → Drafts → Planner → Consultant
  → Execution Validator / Confirmation / Dispatcher (dryRun|simulation)
  → WriteIntentFactory (se intenção de escrita)
  → WriteCoordinator + ExecutionContext
  → AssistantResponse (campos de escrita)
```

- Reutiliza o mesmo `AssistantExecutionContext` do dry-run/simulation.
- Confirmação de passo no contexto **não** habilita escrita.
- Modo `production` no contexto bloqueia a preparação aceita.
- Não há Dispatcher novo de escrita.

## Campos na resposta

| Campo | Conteúdo |
|-------|----------|
| `writeResult` | Resultado da preparação (`executed == false`) |
| `writeValidation` | Erros, constraints bloqueadas, warnings |
| `writeAuthorization` | Status de autorização |
| `writeWarnings` | Avisos do coordinator |

Mensagem explícita quando há preparação:

> A operação foi apenas preparada. Nenhuma alteração foi realizada no EventPRO.

## Invariantes

1. `executed` é sempre `false` no coordinator.
2. Validator/Authorizer/Coordinator não importam ERP concreto.
3. Writes `canExecuteCreateEvent` / `canExecuteCreateQuote` permanecem `false` por padrão.
4. `schemaVersion` do Drift não é alterado por esta sprint.
5. Módulos ERP existentes não são modificados.

## Limitações (AI-005)

- Sem persistência da intenção.
- Sem adapter ERP de escrita.
- `delete` / `cancel` e capabilities reservadas ficam bloqueados.
- Targets `contract` / `invoice` sem capability mapeada.

## Ligação com ERP

AI-006 implementou a primeira ligação real: **create quote draft**.

AI-007 fortalece a infraestrutura (idempotência, observabilidade, production policies, audit) **sem** novos casos de uso.

Ver [write-integration.md](write-integration.md), [idempotency.md](idempotency.md), [observability.md](observability.md).

Escritas adicionais (evento, update, delete, financeiro) permanecem **proibidas** até nova sprint aprovada.
