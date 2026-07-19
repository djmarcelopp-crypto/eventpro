# Idempotência — Write Pipeline (AI-007)

## Objetivo

Infraestrutura tipada e reutilizável para impedir mutações duplicadas no pipeline de escrita controlada.

**AI-007 não adiciona novos casos de uso.** Apenas **Create Quote Draft** continua habilitado.

## Contratos

| Tipo | Papel |
|------|--------|
| `AssistantWriteIdempotencyKey` | Chave opaca existente (reutilizada; sem tipo duplicado) |
| `AssistantIdempotencyService` | begin / complete / fail / markUncertain / findByKey |
| `AssistantIdempotencyStore` | Backend intercambiável (claim + save) |
| `AssistantIdempotencyRecord` | Snapshot sem chave bruta |
| `AssistantIdempotencyResult` | Decisão de begin + record |
| `AssistantIdempotencyStatus` | `pending` \| `completed` \| `failed` \| `uncertain` |

## Lifecycle e transições

```
(absent) --begin--> pending --complete--> completed
                 |            --fail-----> failed ----begin(retry)--> pending
                 |            --markUncertain--> uncertain
                 |
completed --begin--> replay (sem mutação)
pending (órfão) --begin--> blockedPending
uncertain --begin--> blockedUncertain
uncertain + Draft persistido --begin--> replayCompleted
```

## Comportamento concorrente

| Cenário | Comportamento |
|---------|----------------|
| Primeira requisição | `begin` → `proceed` (pending) |
| Repetição após sucesso | `replayCompleted` — recupera Draft ID/número |
| Repetição após falha | novo `pending` (retry explícito) |
| Repetição com `uncertain` | `blockedUncertain` até recovery via lookup |
| Duas concorrentes (mesmo processo) | claim serializado + waiters no inflight; só uma muta |
| Pending órfão (outro isolado / store compartilhada) | `blockedPending` — não muta |

**Não** há check-then-act vulnerável no store local: `claimPending` é serializado por fingerprint no isolado.

## Backend atual

- `LocalAssistantIdempotencyStore` — processo/isolado atual (mapa + lock).
- Lookup complementar: `quoteIdempotencyCompletedLookup` → `QuoteRepository.findById(derivedDraftId)`.
- ID determinístico do Quote (`asst-quote-{hash}`) permanece proteção complementar via UNIQUE de `quote.id`.
- **Sem tabela dedicada / sem migração / `schemaVersion` permanece 12.**

## Limitações sem tabela dedicada

- Claim atômico **cross-process / cold-start pending** não é possível sem schema novo.
- Após crash com pending local perdido, a recuperação de **completed** usa o Draft persistido (AI-006).
- Pending órfão sem Draft: bloqueia nova mutação até intervenção / recovery futura.
- Não substituímos garantia persistente por cache-only: completed continua recuperável pelo recurso ERP.

## Chave bruta

- Nunca em logs, audit ou `toString` do record.
- Audit usa apenas `auditFingerprint`.
- `AssistantWriteIdempotencyKey.toString()` → `AssistantWriteIdempotencyKey(*)`.

## Relação com o fluxo AI-006

1. Policy de production autoriza create quote draft.
2. `IdempotencyService.begin` antes do adapter.
3. Adapter / `QuoteDraftCreationService` ainda usa id determinístico + `findById`.
4. `complete` somente após sucesso confirmado; timeout → `uncertain` (não vira `failed` automaticamente).
