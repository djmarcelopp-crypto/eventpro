# TASK-015 — Fundação do módulo de Orçamentos

## Objetivo

Criar a base profissional do módulo de Orçamentos, preparando a futura montagem de orçamentos com clientes e itens do Catálogo.

## Escopo

- Card Orçamentos ativo no Dashboard (`DashboardModuleId.quotes`).
- Rota `/quotes` e `QuotesScreen`.
- Estado vazio Premium Dark com botão **Novo orçamento** (sem formulário).
- Modelos: `Quote`, `QuoteClientSnapshot`, `QuoteEventSnapshot`, `QuoteLineItem`, `QuoteStatus`, `QuoteClientType`.
- Snapshots imutáveis; dinheiro em centavos; quantidade `double` fracionada.
- Provider Riverpod em memória com `addQuote`, `findById`, `updateQuote`, `transitionStatus`.
- Numeração `ORC-AAAA-NNNN` com sequência por ano.
- Documentação de integração futura com Contratos.

## Fora de escopo

- Formulário de novo orçamento.
- PDF, WhatsApp, assinatura, pagamento/PIX.
- Módulo de Contratos (`features/contracts/`).
- `toJson`/`fromJson`.
- Cópia de imagens do Catálogo.
- Firebase e persistência.
- Alteração de Clientes, Catálogo, fotos ou formatadores de preço.

## Critérios de aceite

- Dashboard → Orçamentos com `push`; Voltar preserva pilha; fallback para Dashboard.
- Empty state profissional; botão **Novo orçamento** sem ação.
- Status, transições, snapshots, centavos, quantidade e numeração conforme regras.
- `updateQuote` somente em rascunho; `transitionStatus` única via de mudança de status.
- `approvedAt` preservado como histórico.
- `QuoteClientType` local; sem `contractId`.
- `Quote.items` imutável.
- `QuoteLineItem` sem `imageReference`.
- Testes unitários e de navegação passando.
- `flutter analyze` e `flutter test` sem erros.

## Decisões

- Pasta `lib/features/quotes/`; rota `/quotes`; UI "Orçamentos".
- Totais financeiros em `int` (centavos); Catálogo permanece em `double` reais.
- Orçamentos enviados+ são imutáveis; futura "Criar nova versão".
- Contratos documentados como evolução; `ContractSnapshot` especificado em `quotes.md`.
- Imagens: sem referência ao Catálogo; cópia dedicada documentada para PDF futuro.
