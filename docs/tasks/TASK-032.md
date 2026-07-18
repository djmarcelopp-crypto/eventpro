# TASK-032 — Faturamento & Documentos Fiscais

## Objetivo

Criar o módulo **Faturamento & Documentos Fiscais** do EventPro ERP: faturas (`Invoice`) e itens (`InvoiceItem`) vinculados a orçamentos, numeração automática, cálculo de totais no serviço, UI de gestão, integração no detalhe do orçamento e dashboard, resumo financeiro derivado desacoplado do módulo Financeiro, e **máquina de estados** com matriz única `InvoiceStatusTransitions` — sem PDF, NF-e/NFS-e, boleto, PIX, bancos ou conciliação nesta task.

**Branch:** `cursor/task-032-faturamento`

**Origem:** necessidade do MVP de registrar o ciclo de faturamento a partir do orçamento (`draft → issued → paid`), com cancelamento controlado e totais consistentes Invoice ↔ Items, preparando o terreno para emissão fiscal e meios de pagamento em fases futuras.

## Arquitetura do fluxo

```text
UI (InvoicesScreen, detalhe, NewInvoice, QuoteInvoicesScreen)
      │
      ▼
Providers / Notifiers (Riverpod)
  invoiceProvider / quoteInvoiceProvider
  invoiceFiltersProvider → filteredInvoicesProvider
  invoiceListSummaryProvider
  invoiceFinancialSummaryProvider
  invoiceWorkflowServiceProvider / invoiceWorkflowSummaryProvider
      │
      ▼
Services (casos de uso — regras de negócio)
  InvoiceService / QuoteInvoiceService
  InvoiceFinancialSummaryService
  InvoiceWorkflowService  ──consulta──► InvoiceStatusTransitions
      │
      └─► Repositories (somente leitura/escrita)
            DriftInvoiceRepository
            DriftInvoiceItemRepository
            (+ QuoteRepository para existência)
                  │
                  ▼
            DAOs → SQLite (schemaVersion 12)
```

- **Domínio puro (CP-A):** `Invoice`, `InvoiceItem`, `InvoiceStatus`, `InvoiceType`, validators, contratos de repositório.
- **Persistência (CP-B):** tabelas Drift, DAOs, mappers, migração v11→v12.
- **Serviços (CP-C / CP-D):** numeração, totais, quote-scoped ops, resumo financeiro derivado.
- **Gate arquitetural (Bloco 1):** matriz única, totais no serviço, numeração omitível, finance desacoplado.
- **Providers + UI (CP-E):** orquestração e apresentação — **nenhuma regra de total/transição na UI**.
- **Fluxo (CP-F):** `InvoiceWorkflowService` consulta `InvoiceStatusTransitions` (não duplica matriz) e produz summary para ações.
- **Carregamento:** sob demanda via `AsyncNotifier` — **não** hidratado no `appBootstrapProvider` nesta task.

## Checkpoints

| CP | Descrição | Commit | Status |
|----|-----------|--------|--------|
| A | Fundação do domínio (entidades, enums, validadores, contratos) | *(pendente)* | ✅ Concluído |
| B | Persistência Drift — invoices/items, migração v11→v12 | *(pendente)* | ✅ Concluído |
| C | Casos de uso — InvoiceService (numeração, totais, transições) | *(pendente)* | ✅ Concluído |
| D | QuoteInvoiceSummary + QuoteInvoiceService | *(pendente)* | ✅ Concluído |
| Gate | Correções: numeração, totais, matriz única, finance desacoplado | *(pendente)* | ✅ Concluído |
| E | UI, providers, dashboard e seção em orçamentos | *(pendente)* | ✅ Concluído |
| F | Fluxo de faturamento (workflow + summary + providers) | *(pendente)* | ✅ Concluído |
| G | Documentação final — este documento, `docs/business-rules/billing.md`, revisão de `ARCHITECTURE.md`/`PROJECT.md`/`TASKS.md`/`docs/roadmap.md` | *(pendente)* | ✅ Concluído |

**TASK-032 implementada nesta branch.** Commits aguardam aprovação do PO/CTO (trabalho ainda não versionado).

### Checkpoint A — Fundação do domínio ✅

- `Invoice`, `InvoiceItem`, `InvoiceStatus`, `InvoiceType`
- Validadores e contratos `InvoiceRepository` / `InvoiceItemRepository`
- Sem Drift, providers ou UI

### Checkpoint B — Persistência Drift ✅

- Tabelas `invoices` e `invoice_items`
- DAOs, mappers e `Drift*Repository`
- `schemaVersion` **11 → 12**; FK quote **RESTRICT**; FK items→invoice **CASCADE**
- Snapshot legado v11

### Checkpoint C — Casos de uso ✅

- `InvoiceService` com result objects; relógio injetável
- Número `INV-YYYY-####`; totais recomputados; transições via matriz

### Checkpoint D — Integração com Orçamentos ✅

- `QuoteInvoiceSummary` / `QuoteInvoiceService`
- Gerar (create+issue), status, pagar, cancelar por orçamento
- Sem UI neste checkpoint

### Gate arquitetural (Bloco 1) ✅

1. **Numeração:** omit/blank → auto; manual após trim; unicidade case-insensitive.
2. **Totais:** sempre recompute no serviço; validação de itens; rollback CASCADE se item falhar.
3. **Matriz única:** `InvoiceStatusTransitions` (única fonte).
4. **Financeiro:** `InvoiceFinancialSummary` derivado — sem criar `FinancialEntry`.

**Verificação Bloco 1:** `flutter test` com **1577** testes passando.

### Checkpoint E — UI e providers ✅

- Providers Riverpod (repos, services, clock, invoices, filtros, quote invoice, list/financial summaries)
- Telas: listagem/busca/filtros, criação, consulta, emissão, pagamento, cancelamento, itens/totais
- Seção Faturamento no orçamento; módulo e resumo no Dashboard
- Schema **inalterado** (permanece v12)
- UI **não** calcula totais nem decide transições

**Verificação:** `flutter test` com **1592** testes passando.

### Checkpoint F — Fluxo de faturamento ✅

- `InvoiceWorkflowService` + `InvoiceWorkflowSummary`
- Consulta `InvoiceStatusTransitions` — **não** cria matriz independente
- Coordena `draft → issued → paid` e cancelamento; bloqueia regressões/repetições
- Persistência delegada a `InvoiceService`; summary alimenta a UI
- Sem emissão fiscal, PDF, boleto, PIX, banco

**Verificação:** `flutter test` com **1601** testes passando.

### Checkpoint G — Documentação final ✅

- `docs/tasks/TASK-032.md` e `docs/business-rules/billing.md` criados
- `ARCHITECTURE.md`, `PROJECT.md`, `TASKS.md` e `docs/roadmap.md` atualizados
- Nenhuma alteração em `lib/` / `test/` neste checkpoint — exclusivamente documental

**Verificação:** `flutter analyze` e `flutter test` com **1601** testes (suíte inalterada).

## Arquivos principais da task

```text
lib/features/billing/
  models/          # Invoice, Item, Status, Type, Summaries, Workflow*
  data/
    mappers/
    repositories/  # interfaces + Drift*
  utils/           # validators, totals, transitions, services, workflow
  providers/
  widgets/
  *_screen.dart

lib/core/database/
  tables.dart                    # Invoices, InvoiceItems
  app_database.dart              # schemaVersion 12, onUpgrade v11→v12
  daos/invoice*_dao.dart

test/features/billing/           # unitários, providers, widgets, fakes
test/core/database/
  invoice_migration_test.dart
  legacy_schema/legacy_*_v11*
```

## Testes e verificação

| Checkpoint | Testes totais |
|---|---|
| Bloco 1 (A–D + gate) | 1577 |
| CP-E | 1592 |
| CP-F | 1601 |
| CP-G | 1601 (inalterado — checkpoint documental) |

## Lições aprendidas

1. **UI sem regras** — totais e transições ficam em `InvoiceService` / `InvoiceWorkflowService`; telas só orquestram Result Objects e summaries.
2. **Matriz única** — `InvoiceStatusTransitions` é a única fonte; workflow **consulta**, não duplica.
3. **Consistência Invoice ↔ Items** — totais sempre recompute; rollback com CASCADE se persistência de item falhar.
4. **Financeiro desacoplado** — `InvoiceFinancialSummary` é visão derivada; não escreve no módulo Financeiro.
5. **Dashboard: módulos primeiro** — resumos densos abaixo dos atalhos evitam regressão de hit-test.
6. **Dialogs com controllers** — ownership no `StatefulWidget` do diálogo evita dispose precoce.

## Fora de escopo (mantido)

- Emissão fiscal real (NF-e / NFS-e)
- Geração de PDF da fatura
- Boleto, PIX e integração bancária
- Conciliação automática / webhooks / envio externo
- Hidratação do módulo Faturamento no bootstrap do app
- Criação automática de `FinancialEntry` a partir de fatura

## Critérios de aceite (TASK-032)

- [x] Domínio, persistência (schema v12), serviços, UI e fluxo documentados
- [x] Matriz única `InvoiceStatusTransitions`; workflow sem segunda matriz
- [x] Totais e numeração no serviço; UI sem cálculo/transição local
- [x] Integração com orçamento e dashboard; finance derivado desacoplado
- [x] Sem PDF/NF-e/boleto/PIX/banco nesta task
- [x] Testes passando em cada checkpoint; documentação alinhada à arquitetura
