# Write Integration — Quote Draft (AI-006 / AI-007)

## Objetivo

Primeira integração **real** de escrita Assistente → EventPRO.

Operação única permitida:

> **create quote draft**

**AI-007 não adiciona novos casos de uso.** Fortalece idempotência, observabilidade, policies e auditoria.

## Por que Quote Draft?

- fluxo comercial frequente;
- estado Draft é seguro (editável, sem envio/aprovação/financeiro);
- serviço oficial já possui criação atômica via Drift transaction.

## Fronteira hexagonal (AI-007)

```
AssistantWriteRequest
  → Validator / Authorizer
  → Execution Validator / Confirmation
  → Production Write Policy Registry
  → Idempotency Service
  → Write Coordinator
  → AssistantWriteGateway
  → QuoteAssistantWriteAdapter (módulo quotes)
  → QuoteDraftCreationService
  → QuoteRepository.insert → QuotesDao.insertQuoteGraph (transaction)
  → WriteResult
  → Audit + Observation
  → AssistantResponse
```

Invariantes:

- policy validada **antes** da mutação;
- idempotência protege **antes** do adapter;
- `completed` somente após sucesso confirmado;
- timeout incerto **não** vira `failed` automaticamente;
- observer não controla a decisão;
- audit reflete o que realmente ocorreu.

## Serviço reutilizado

| Item | Valor |
|------|--------|
| Serviço | `QuoteDraftCreationService` |
| Extraído de | `QuotesNotifier.addQuote` |
| Método | `createDraft(Quote)` |
| Persistência | `QuoteRepository.insert` (transação Drift) |
| Estado forçado | `QuoteStatus.draft` |

## Modos de execução

| Mode | Escreve? | `executed` | `mutatedErp` |
|------|----------|------------|--------------|
| dryRun | Não | false | false |
| simulation | Não | false | false |
| production | Somente create quote Draft com todos os gates | true se criou/replay | true só na 1ª criação |

## Production Write Policies (AI-007)

Default **deny**. Registry resolve **uma** policy ativa por `operation/target/state`.

| Policy | Ativa? | Efeito |
|--------|--------|--------|
| `QuoteDraftProductionPolicy` | sim | permite só create quote draft |
| `EventProductionPolicy` | não | placeholder bloqueado |
| `CustomerProductionPolicy` | não | placeholder bloqueado |

Gates obrigatórios (policy não os ignora): Validator, Authorizer, Confirmation, Idempotency, adapter aprovado, mode=production.

`AssistantExecutionPolicy.ai006QuoteDraftProduction` continua no ExecutionContext; a autorização de escrita real é da **policy registry**, não de comparações hardcoded no orchestrator.

## Idempotência

Ver [idempotency.md](idempotency.md).

- Serviço dedicado + store local + lookup complementar do Draft AI-006.
- ID determinístico permanece proteção complementar (UNIQUE `quote.id`).
- Sem nova tabela / `schemaVersion` = 12.

## Observabilidade

Ver [observability.md](observability.md).

## Transação e rollback

- `insertQuoteGraph` roda em `transaction()` Drift.
- Falha ⇒ rollback automático do SQLite (sem Draft parcial).
- Audit **não** alega rollback quando ele não ocorreu.

## Timeout / uncertain

- Adapter aplica `Future.timeout`.
- Timeout ⇒ lifecycle `uncertain` + outcome distinto de `failed`.
- Recovery: `completedLookup` / `findById(derivedDraftId)` antes de nova mutação.

## Auditoria

`AssistantWriteAuditRecord` (autoritativo):

correlationId, requestId, executionId, execution token, idempotency fingerprint (não a key bruta), lifecycle + write idempotency status, operation, target, states, mode, policy, adapter, authorization, confirmation, timestamps, duration, outcome, failure code, created Draft ID (só se conhecido), executed, mutatedErp, rollback*, warnings ordenados.

Serialização determinística via `toDeterministicMap()`; relógio/IDs injetáveis — sem IDs aleatórios na serialização.

## Erros estruturados

`validationDenied`, `authorizationDenied`, `confirmationRequired`, `confirmationInvalid`, `unsupportedOperation`, `unsupportedTarget`, `invalidDraftState`, `adapterUnavailable`, `serviceFailure`, `timeout`, `rollbackFailure`, `duplicateOperation`, `uncertainOutcome`, `missingIdempotencyKey`, `productionNotAllowed`.

## Limitações / proibições

- sem create event / customer / contract;
- sem update / delete / cancel;
- sem aprovação / envio / emissão / financeiro;
- sem HTTP externo;
- placeholders de policy ≠ funcionalidade disponível;
- idempotência dedicada ainda tem limitações sem armazenamento próprio (claim pending cross-process).

**`canExecuteCreateQuote` não significa acesso irrestrito ao ERP.**  
A única escrita real permitida nesta versão é: **create quote draft**.
