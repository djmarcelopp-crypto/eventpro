# Write Integration — Quote Draft (AI-006)

## Objetivo

Primeira integração **real** de escrita Assistente → EventPRO.

Operação única permitida:

> **create quote draft**

## Por que Quote Draft?

- fluxo comercial frequente;
- estado Draft é seguro (editável, sem envio/aprovação/financeiro);
- serviço oficial já possui criação atômica via Drift transaction.

## Fronteira hexagonal

```
AssistantWriteRequest
  → Validator / Authorizer
  → Execution Validator / Confirmation
  → Write Coordinator
  → AssistantWriteGateway
  → QuoteAssistantWriteAdapter (módulo quotes)
  → QuoteDraftCreationService
  → QuoteRepository.insert → QuotesDao.insertQuoteGraph (transaction)
  → AssistantWriteResult / ExecutionReport / Audit
```

O assistente **não** importa DAO/repository. O adapter vive em `lib/features/quotes/assistant/` e depende dos contratos do assistente.

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

## Autorização restrita de production

AI-004 continua bloqueando production por padrão.

Exceção AI-006 (`AssistantExecutionPolicy.ai006QuoteDraftProduction`):

- `operation=create`
- `target=quote`
- `requestedState=draft`
- `canExecuteCreateQuote=true`
- `canExecuteCreateEvent=false`
- confirmação satisfeita
- adapter disponível
- idempotency key válida

Qualquer outro caso permanece rejeitado.

## Idempotência (persistente)

- Key obrigatória para escrita real.
- Draft id = `asst-quote-{hash(key)}`.
- `findById` antes do insert: se existir Draft, retorna replay (`mutatedErp=false`).
- Persistente via UNIQUE de `quote.id` — sem nova tabela / sem mudança de `schemaVersion`.

## Transação e rollback

- `insertQuoteGraph` roda em `transaction()` Drift.
- Falha ⇒ rollback automático do SQLite (sem Draft parcial).
- `rollbackAttempted` / `rollbackSucceeded` registrados quando a falha ocorre após tentativa de persistência.
- **Não** afirmamos rollback se a falha for anterior à persistência.

## Timeout

- Adapter aplica `Future.timeout`.
- Timeout ⇒ `uncertainOutcome` / `TimeoutException` estruturado.
- **Não** repetir automaticamente — consultar idempotência (mesmo id) antes de nova tentativa.

## Auditoria

`AssistantWriteAuditRecord` / campos em `WriteResult` + `ExecutionReport`:

token, fingerprint da key (não a key crua), operation, target, mode, confirmation, authorization, adapter, outcome, draft id, executed, mutatedErp, rollback, warnings, erro estruturado.

## Erros estruturados

`validationDenied`, `authorizationDenied`, `confirmationRequired`, `confirmationInvalid`, `unsupportedOperation`, `unsupportedTarget`, `invalidDraftState`, `adapterUnavailable`, `serviceFailure`, `timeout`, `rollbackFailure`, `duplicateOperation`, `uncertainOutcome`, `missingIdempotencyKey`, `productionNotAllowed`.

## Limitações / proibições

- sem create event;
- sem update/delete/cancel;
- sem aprovação/envio/conversão;
- sem financeiro/faturamento/emissão;
- sem HTTP externo.

**`canExecuteCreateQuote` não significa acesso irrestrito ao ERP.**  
A única escrita real permitida nesta versão é: **create quote draft**.
