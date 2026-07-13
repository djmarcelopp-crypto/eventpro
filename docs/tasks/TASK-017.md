# TASK-017 — Detalhes, edição e status do Orçamento

## Objetivo

Permitir abrir um orçamento, visualizar todos os seus dados, editar somente em Rascunho e controlar o ciclo de status com histórico imutável.

## Entregas

### Rotas

- `/quotes/:id` — `QuoteDetailScreen`
- `/quotes/:id/edit` — `NewQuoteScreen(quoteId)`
- `/quotes/new` permanece declarada antes de `/:id`

### Modelo e provider

- `QuoteStatusHistoryEntry` + campo `statusHistory` em `Quote`
- `quoteClockProvider` para relógio testável
- `addQuote` ignora histórico do draft; cria entrada inicial `null → draft` com `changedAt == createdAt`
- `transitionStatus` append no histórico; `updateQuote` preserva histórico

### Detalhes

- Seções: cabeçalho, cliente, evento, itens, financeiro, observações, histórico
- Ações por status com diálogos de confirmação
- Proteção contra duplo clique (`_transitioning` em `finally`)
- Estado amigável para ID inexistente

### Edição

- `QuoteFormInitializer` + `QuoteLineDraft.isExistingLine`
- `QuoteLineDraftSaver` para regras de save (snapshot vs catálogo atual)
- Avisos para item inativo/ausente em linhas existentes
- Linhas novas somente de itens ativos

### Testes

- Provider: histórico, relógio via override
- `QuoteLineDraftSaver`: item renomeado, inativo, ausente
- `QuoteFormInitializer`, `QuoteDateTimeFormatter`

## Verificação

```bash
flutter analyze
flutter test
```

## Fora de escopo

- PDF, envio real, contrato, exclusão, persistência Firebase
