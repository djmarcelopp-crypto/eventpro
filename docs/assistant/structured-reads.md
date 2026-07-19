# Structured ERP Reads (AI-008)

## Objetivo

Consultas estruturadas ao ERP via contratos genéricos de leitura.

**Somente READ.** AI-008 não adiciona escrita, confirmação, policies de production nem comandos.

## Fluxo

```
AssistantReadQuery
  → Validation (LocalAssistantReadValidator)
  → AssistantReadGateway
  → QuoteAssistantReadAdapter
  → QuoteQueryService
  → QuoteRepository
  → AssistantReadResult (+ AssistantReadMetadata)
  → AssistantResponse.readResult
```

`moduleResults` (AI-003) permanece intacto e ortogonal a `readResult`.

## Query object

`AssistantReadQuery` descreve:

| Campo | Papel |
|-------|--------|
| `module` | chave lógica (`quote`) |
| `filters` | field/operator/value genéricos |
| `projection` | campos lógicos desejados |
| `sorting` | ordenação genérica |
| `pagination` | obrigatória (`limit` ≤ 50) |
| `requiredCapabilities` | declaração tipada |

Não existem helpers `findById` / `findByStatus` nos contratos — o **adapter** interpreta os filtros.

## Gateway e adapter

- `AssistantReadGateway` / `LocalAssistantReadGateway`
- `QuoteAssistantReadAdapter` (módulo quotes) — único adapter AI-008
- `QuoteQueryService` — usa `findById` / `listAll` do repositório; aplica filtros, sort e página

O assistente **não** importa DAO. O adapter depende apenas dos contratos do assistente + serviço do módulo quotes.

## Capacidades

- `canPlanStructuredQuoteRead` / `canExecuteStructuredQuoteRead` (default `false`)
- Perfil de teste: `AssistantCapabilities.localStructuredQuoteRead()`

## Metadata

`AssistantReadMetadata`: timestamp, source, appliedFilters, pagination, executionTimeMs, totalMatched, warnings.

## Limitações atuais

- Somente módulo `quote`.
- Sem `findByNumber` / `findByStatus` no repositório → `listAll` + filtro in-memory, com `maxScan` (500) e paginação obrigatória.
- Varredura completa do repositório pode carregar mais linhas do que a página retornada (documentado; sem migração).
- Clientes, eventos, financeiro e escrita **fora de escopo**.

## Futura expansão

Novos adapters (`client`, `event`, …) implementam `AssistantReadAdapter` e registram-se no gateway, sem alterar os contratos genéricos.
